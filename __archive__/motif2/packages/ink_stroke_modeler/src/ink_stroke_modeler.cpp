#include "ink_stroke_modeler.h"

#include <iostream>
#include <vector>

#include "absl/time/time.h"
#include "ink_stroke_modeler/stroke_modeler.h"

namespace {
inline ink::stroke_model::Input to_cpp_input(const InkInput& input) {
  ink::stroke_model::Input in;
  in.event_type = static_cast<ink::stroke_model::Input::EventType>(input.event_type);
  in.position = {input.x, input.y};
  in.time = ink::stroke_model::Time(input.time_seconds);
  in.pressure = input.pressure;
  in.tilt = input.tilt;
  in.orientation = input.orientation;
  return in;
}

inline InkResult to_c_result(const ink::stroke_model::Result& r) {
  InkResult cr;
  cr.x = r.position.x;
  cr.y = r.position.y;
  cr.velocity_x = r.velocity.x;
  cr.velocity_y = r.velocity.y;
  cr.time_seconds = r.time.Value();
  cr.pressure = r.pressure;
  cr.tilt = r.tilt;
  cr.orientation = r.orientation;
  return cr;
}

inline ink::stroke_model::StrokeModelParams to_cpp_params(const StrokeModelerParams& params) {
  auto wobble_p = params.wobble_smoother_params;
  auto position_p = params.position_modeler_params;
  auto loop_contraction_p = position_p.loop_contraction_mitigation_params;
  auto sampling_p = params.sampling_params;
  auto stylus_state_p = params.stylus_state_modeler_params;
  auto prediction_p = params.prediction_params;

  ink::stroke_model::PredictionParams cpp_prediction_params;
  if (prediction_p.type == PredictorType::PREDICTOR_TYPE_DISABLED) {
    cpp_prediction_params = ink::stroke_model::DisabledPredictorParams{};
  } else if (prediction_p.type == PredictorType::PREDICTOR_TYPE_STROKE_END) {
    cpp_prediction_params = ink::stroke_model::StrokeEndPredictorParams{};
  } else if (prediction_p.type == PredictorType::PREDICTOR_TYPE_KALMAN) {
    cpp_prediction_params = ink::stroke_model::KalmanPredictorParams{
      .process_noise = prediction_p.kalman.process_noise,
      .measurement_noise = prediction_p.kalman.measurement_noise,
      .min_stable_iteration = prediction_p.kalman.min_stable_iteration,
      .max_time_samples = prediction_p.kalman.max_time_samples,
      .min_catchup_velocity = prediction_p.kalman.min_catchup_velocity,
      .acceleration_weight = prediction_p.kalman.acceleration_weight,
      .jerk_weight = prediction_p.kalman.jerk_weight,
      .prediction_interval = ink::stroke_model::Duration{prediction_p.kalman.prediction_interval_seconds},
      .confidence_params = {
        .desired_number_of_samples = prediction_p.kalman.confidence_params.desired_number_of_samples,
        .max_estimation_distance = prediction_p.kalman.confidence_params.max_estimation_distance,
        .min_travel_speed = prediction_p.kalman.confidence_params.min_travel_speed,
        .max_travel_speed = prediction_p.kalman.confidence_params.max_travel_speed,
        .max_linear_deviation = prediction_p.kalman.confidence_params.max_linear_deviation,
        .baseline_linearity_confidence = prediction_p.kalman.confidence_params.baseline_linearity_confidence,
      },
    };
  } else {
    cpp_prediction_params = ink::stroke_model::DisabledPredictorParams{};
  }

  ink::stroke_model::StrokeModelParams cpp_params{
    .wobble_smoother_params = {
      .is_enabled = wobble_p.is_enabled,
      .timeout = ink::stroke_model::Duration{wobble_p.timeout_seconds},
      .speed_floor = wobble_p.speed_floor,
      .speed_ceiling = wobble_p.speed_ceiling,
    },
    .position_modeler_params = {
      .spring_mass_constant = position_p.spring_mass_constant,
      .drag_constant = position_p.drag_constant,
      .loop_contraction_mitigation_params = {
        .is_enabled = loop_contraction_p.is_enabled,
        .speed_lower_bound = loop_contraction_p.speed_lower_bound,
        .speed_upper_bound = loop_contraction_p.speed_upper_bound,
        .interpolation_strength_at_speed_lower_bound = loop_contraction_p.interpolation_strength_at_speed_lower_bound,
        .interpolation_strength_at_speed_upper_bound = loop_contraction_p.interpolation_strength_at_speed_upper_bound,
        .min_speed_sampling_window = ink::stroke_model::Duration{loop_contraction_p.min_speed_sampling_window_seconds},
      }
    },
    .sampling_params = {
      .min_output_rate = sampling_p.min_output_rate,
      .end_of_stroke_stopping_distance = sampling_p.end_of_stroke_stopping_distance,
      .end_of_stroke_max_iterations = sampling_p.end_of_stroke_max_iterations,
      .max_outputs_per_call = sampling_p.max_outputs_per_call,
      .max_estimated_angle_to_traverse_per_input = sampling_p.max_estimated_angle_to_traverse_per_input,
    },
    .stylus_state_modeler_params = {
      .use_stroke_normal_projection = stylus_state_p.use_stroke_normal_projection,
    },
    .prediction_params = cpp_prediction_params,
  };

  return cpp_params;
}
}  // namespace

struct InkStrokeModeler {
  ink::stroke_model::StrokeModeler modeler;

  std::vector<ink::stroke_model::Result> results;
  std::vector<InkResult> c_results;

  std::vector<ink::stroke_model::Result> prediction_results;
  std::vector<InkResult> c_prediction_results;

  absl::Status update(const ink::stroke_model::Input& input) {
    size_t start_size = results.size();
    auto status = modeler.Update(input, results);
    if (!status.ok()) return status;

    size_t new_size = results.size();
    c_results.reserve(new_size);

    for (size_t i = start_size; i < new_size; i++) {
      c_results.push_back(to_c_result(results[i]));
    }

    return status;
  }

  absl::Status predict() {
    auto status = modeler.Predict(prediction_results);
    c_prediction_results.clear();
    if (!status.ok()) return status;

    c_prediction_results.reserve(prediction_results.size());
    for (const auto& r : prediction_results) {
      c_prediction_results.push_back(to_c_result(r));
    }

    return status;
  }

  absl::Status reset(const ink::stroke_model::StrokeModelParams& params) {
    c_results.clear();
    c_prediction_results.clear();
    results.clear();
    prediction_results.clear();
    return modeler.Reset(params);
  }
};

InkStrokeModeler* ink_stroke_modeler_create() { return new InkStrokeModeler(); }

void ink_stroke_modeler_destroy(InkStrokeModeler* modeler) { delete modeler; }

bool ink_stroke_modeler_reset(InkStrokeModeler* modeler, StrokeModelerParams params) {
  ink::stroke_model::StrokeModelParams cpp_params = to_cpp_params(params);

  absl::Status status = modeler->reset(cpp_params);
  std::cout << "Reset status: " << status.ToString() << std::endl;
  return status.ok();
}

size_t ink_stroke_modeler_update(InkStrokeModeler* modeler, InkInput input, const InkResult** out_results) {
  ink::stroke_model::Input in = to_cpp_input(input);
  auto status = modeler->update(in);
  if (!status.ok()) {
    // std::cout << "Update failed with error: " << status.ToString() << std::endl;
    *out_results = nullptr;
    return 0;
  }
 
  *out_results = modeler->c_results.data();
  return modeler->c_results.size();
}

size_t ink_stroke_modeler_predict(InkStrokeModeler* modeler, const InkResult** out_results) {
  absl::Status status = modeler->predict();
  if (!status.ok()) {
    // std::cout << "Predict failed with error: " << status.ToString() << std::endl;
    *out_results = nullptr;
    return 0;
  }

  *out_results = modeler->c_prediction_results.data();
  return modeler->c_prediction_results.size();
}
