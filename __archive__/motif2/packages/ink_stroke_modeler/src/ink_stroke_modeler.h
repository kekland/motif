#ifndef INK_STROKE_MODELER_H
#define INK_STROKE_MODELER_H

#include <stdbool.h>
#include <stddef.h>

#include "exports.h"

typedef struct InkStrokeModeler InkStrokeModeler;

typedef enum {
  INK_EVENT_DOWN,
  INK_EVENT_MOVE,
  INK_EVENT_UP,
} InkEventType;

typedef struct {
  InkEventType event_type;
  float x;
  float y;
  double time_seconds;
  float pressure;
  float tilt;
  float orientation;
} InkInput;

typedef struct {
  float x;
  float y;
  float velocity_x;
  float velocity_y;
  double time_seconds;
  float pressure;
  float tilt;
  float orientation;
} InkResult;

typedef struct {
  bool is_enabled;
  double timeout_seconds;
  float speed_floor;
  float speed_ceiling;
} WobbleSmootherParams;

typedef struct {
  bool is_enabled;
  float speed_lower_bound;
  float speed_upper_bound;
  float interpolation_strength_at_speed_lower_bound;
  float interpolation_strength_at_speed_upper_bound;
  double min_speed_sampling_window_seconds;
} LoopContractionMitigationParams;

typedef struct {
  float spring_mass_constant;
  float drag_constant;
  LoopContractionMitigationParams loop_contraction_mitigation_params;
} PositionModelerParams;

typedef struct {
  double min_output_rate;
  float end_of_stroke_stopping_distance;
  int end_of_stroke_max_iterations;
  int max_outputs_per_call;
  double max_estimated_angle_to_traverse_per_input;
} SamplingParams;

typedef struct {
  bool use_stroke_normal_projection;
} StylusStateModelerParams;

typedef enum {
  PREDICTOR_TYPE_DISABLED,
  PREDICTOR_TYPE_KALMAN,
  PREDICTOR_TYPE_STROKE_END
} PredictorType;

typedef struct {
  int desired_number_of_samples;
  float max_estimation_distance;
  float min_travel_speed;
  float max_travel_speed;
  float max_linear_deviation;
  float baseline_linearity_confidence;
} KalmanPredictorConfidenceParams;

typedef struct {
  double process_noise;
  double measurement_noise;
  int min_stable_iteration;
  int max_time_samples;
  float min_catchup_velocity;
  float acceleration_weight;
  float jerk_weight;
  double prediction_interval_seconds;
  KalmanPredictorConfidenceParams confidence_params;
} KalmanPredictorParams;

typedef struct {
  PredictorType type;
  union {
    void* disabled;
    void* stroke_end;
    KalmanPredictorParams kalman;
  };
} PredictorParams;

typedef struct {
  WobbleSmootherParams wobble_smoother_params;
  PositionModelerParams position_modeler_params;
  SamplingParams sampling_params;
  StylusStateModelerParams stylus_state_modeler_params;
  PredictorParams prediction_params;
} StrokeModelerParams;

FFI InkStrokeModeler* ink_stroke_modeler_create();
FFI void ink_stroke_modeler_destroy(InkStrokeModeler* modeler);

FFI bool ink_stroke_modeler_reset(InkStrokeModeler* modeler, StrokeModelerParams params);

FFI size_t ink_stroke_modeler_update(
  InkStrokeModeler* modeler,
  InkInput input,
  const InkResult** out_results
);

FFI size_t ink_stroke_modeler_predict(
  InkStrokeModeler* modeler,
  const InkResult** out_results
);

FFI void a();

#endif  // INK_STROKE_MODELER_H
