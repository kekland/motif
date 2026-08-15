#include <Eigen/Dense>
#include <vector>

#include "geometry.h"
#include "methods.hpp"
#include "types.h"

std::vector<double> compute_chord_lengths(const std::vector<InputPoint>& points) {
  std::vector<double> t_values(points.size(), 0.0);
  double total_length = 0.0;

  for (size_t i = 1; i < points.size(); i++) {
    total_length += vector2_distance(points[i - 1].position, points[i].position);
    t_values[i] = total_length;
  }

  if (total_length > 0.0) {
    for (size_t i = 1; i < points.size(); i++) t_values[i] /= total_length;
  }

  return t_values;
}

std::vector<double> reparameterize(const std::vector<InputPoint>& points, std::vector<double> t_values,
                                   const Cubic2& c) {
  for (size_t i = 0; i < points.size(); i++) {
    Vector2 point = points[i].position;
    double t = t_values[i];
    Vector2 p = cubic2_pos(c, t);
    Vector2 d1 = cubic2_tan(c, t);
    Vector2 d2 = cubic2_acc(c, t);

    Vector2 q = {p.x - point.x, p.y - point.y};
    double numerator = q.x * d1.x + q.y * d1.y;
    double denominator = (d1.x * d1.x + d1.y * d1.y) + (q.x * d2.x + q.y * d2.y);

    if (denominator != 0.0) t_values[i] -= numerator / denominator;
    t_values[i] = std::clamp(t_values[i], 0.0, 1.0);
  }

  return t_values;
}

Cubic2 fit_bezier_unconstrained(const std::vector<InputPoint>& points, const std::vector<double>& t_values) {
  size_t n = points.size();
  Cubic2 curve = {points.front().position, {0, 0}, {0, 0}, points.back().position};

  if (n <= 2) {
    curve.p1 = {(2.0 * curve.p0.x + curve.p3.x) / 3.0, (2.0 * curve.p0.y + curve.p3.y) / 3.0};
    curve.p2 = {(curve.p0.x + 2.0 * curve.p3.x) / 3.0, (curve.p0.y + 2.0 * curve.p3.y) / 3.0};
    return curve;
  }

  Eigen::MatrixXd A(n, 2);
  Eigen::MatrixXd B(n, 2);

  for (size_t i = 0; i < n; i++) {
    Vector2 point = points[i].position;

    double t = t_values[i], mt = 1 - t;
    double t2 = t * t, t3 = t2 * t, mt2 = mt * mt, mt3 = mt2 * mt;

    A(i, 0) = 3.0 * mt2 * t;
    A(i, 1) = 3.0 * mt * t2;
    B(i, 0) = point.x - (mt3 * curve.p0.x) - (t3 * curve.p3.x);
    B(i, 1) = point.y - (mt3 * curve.p0.y) - (t3 * curve.p3.y);
  }

  Eigen::MatrixXd X = A.bdcSvd(Eigen::ComputeThinU | Eigen::ComputeThinV).solve(B);
  curve.p1 = {X(0, 0), X(0, 1)};
  curve.p2 = {X(1, 0), X(1, 1)};

  double dist = vector2_distance(curve.p0, curve.p3);
  double max_dist = dist * 2.0;

  double d1 = vector2_distance(curve.p0, curve.p1);
  if (d1 > max_dist && d1 > 0.0) {
    curve.p1 = {curve.p0.x + (curve.p1.x - curve.p0.x) * (max_dist / d1),
                curve.p0.y + (curve.p1.y - curve.p0.y) * (max_dist / d1)};
  }

  double d2 = vector2_distance(curve.p3, curve.p2);
  if (d2 > max_dist && d2 > 0.0) {
    curve.p2 = {curve.p3.x + (curve.p2.x - curve.p3.x) * (max_dist / d2),
                curve.p3.y + (curve.p2.y - curve.p3.y) * (max_dist / d2)};
  }

  return curve;
}

Cubic2 fit_bezier_constrained(const std::vector<InputPoint>& points, const std::vector<double>& t_values,
                              Vector2 t_start, Vector2 t_end) {
  size_t n = points.size();
  Cubic2 curve = {points.front().position, {0, 0}, {0, 0}, points.back().position};

  Eigen::MatrixXd A(n * 2, 2);
  Eigen::VectorXd B(n * 2);

  for (size_t i = 0; i < n; i++) {
    Vector2 point = points[i].position;

    double t = t_values[i], mt = 1 - t;
    double a0 = 3.0 * mt * mt * t;
    double a1 = 3.0 * mt * t * t;

    double base_x = (mt * mt * mt + a0) * curve.p0.x + (a1 + t * t * t) * curve.p3.x;
    double base_y = (mt * mt * mt + a0) * curve.p0.y + (a1 + t * t * t) * curve.p3.y;

    A(i * 2, 0) = a0 * t_start.x;
    A(i * 2, 1) = a1 * t_end.x;
    B(i * 2) = point.x - base_x;

    A(i * 2 + 1, 0) = a0 * t_start.y;
    A(i * 2 + 1, 1) = a1 * t_end.y;
    B(i * 2 + 1) = point.y - base_y;
  }

  Eigen::VectorXd X = A.bdcSvd(Eigen::ComputeThinU | Eigen::ComputeThinV).solve(B);

  double dist = vector2_distance(curve.p0, curve.p3);
  double max_magnitude = dist * 2.0;

  double alpha = std::clamp(X(0), 0.0, max_magnitude);
  double beta = std::clamp(X(1), 0.0, max_magnitude);

  curve.p1 = {curve.p0.x + alpha * t_start.x, curve.p0.y + alpha * t_start.y};
  curve.p2 = {curve.p3.x + beta * t_end.x, curve.p3.y + beta * t_end.y};
  return curve;
}

Vector2 get_stable_tangent(const std::vector<InputPoint>& points, size_t index, int direction, double tolerance) {
  Vector2 p1 = points[index].position;
  for (size_t i = 1; i < points.size(); i++) {
    int idx = (int)index + direction * (int)i;
    if (idx < 0 || idx >= (int)points.size()) break;

    Vector2 p2 = points[idx].position;
    double d = vector2_distance(p1, p2);
    if (d > tolerance) {
      return vector2_normalize({p2.x - p1.x, p2.y - p1.y});
    }
  }

  int fallback_idx = std::clamp((int)index + direction, 0, (int)points.size() - 1);
  Vector2 fallback = points[fallback_idx].position;
  return vector2_normalize({fallback.x - p1.x, fallback.y - p1.y});
}

void fit_cubic_recursive(const std::vector<InputPoint>& points, double tolerance, std::vector<Cubic2>& output,
                         Vector2* t_start = nullptr, Vector2* t_end = nullptr) {
  if (points.size() < 2) return;

  std::vector<double> t_values = compute_chord_lengths(points);
  Cubic2 curve;

  if (t_start && t_end)
    curve = fit_bezier_constrained(points, t_values, *t_start, *t_end);
  else
    curve = fit_bezier_unconstrained(points, t_values);

  double max_error = 0.0;
  size_t split_index = points.size() / 2;

  for (int iter = 0; iter < 4; iter++) {
    max_error = 0.0;
    int points_above_threshold = 0;

    for (size_t i = 1; i < points.size() - 1; i++) {
      double error = vector2_distance(points[i].position, cubic2_pos(curve, t_values[i]));
      if (error > max_error) {
        max_error = error;
        split_index = i;
      }

      if (error > tolerance) points_above_threshold++;
    }

    if (max_error <= tolerance || points_above_threshold <= 2) break;
    t_values = reparameterize(points, t_values, curve);
    if (t_start && t_end)
      curve = fit_bezier_constrained(points, t_values, *t_start, *t_end);
    else
      curve = fit_bezier_unconstrained(points, t_values);
  }

  if (max_error <= tolerance) {
    output.push_back(curve);
    return;
  }

  if (split_index < 2 || split_index > points.size() - 3) {
    split_index = points.size() / 2;
  }

  Vector2 center_tangent_raw = {points[split_index + 1].position.x - points[split_index - 1].position.x,
                                points[split_index + 1].position.y - points[split_index - 1].position.y};

  Vector2 center_tangent = vector2_normalize(center_tangent_raw);
  Vector2 center_tangent_reverse = {-center_tangent.x, -center_tangent.y};

  std::vector<InputPoint> left_points(points.begin(), points.begin() + split_index + 1);
  std::vector<InputPoint> right_points(points.begin() + split_index, points.end());

  Vector2 left_start;
  if (t_start)
    left_start = *t_start;
  else
    left_start = get_stable_tangent(points, 0, 1, tolerance);

  Vector2 right_end;
  if (t_end)
    right_end = *t_end;
  else
    right_end = get_stable_tangent(points, points.size() - 1, -1, tolerance);

  fit_cubic_recursive(left_points, tolerance, output, &left_start, &center_tangent_reverse);
  fit_cubic_recursive(right_points, tolerance, output, &center_tangent, &right_end);
}

std::vector<size_t> detect_corners(std::vector<InputPoint>& points, double velocity_threshold) {
  if (points.size() < 5) return {};

  std::vector<double> velocity(points.size(), 0.0);

  for (size_t i = 1; i < points.size(); i++) {
    double dist = vector2_distance(points[i - 1].position, points[i].position);
    double dt = points[i].timestamp_ms - points[i - 1].timestamp_ms;
    velocity[i] = (dt > 0) ? dist / dt : 0.0;
  }

  std::vector<double> smoothed(points.size(), 0.0);
  for (size_t i = 1; i < points.size() - 1; i++) {
    smoothed[i] = (velocity[i - 1] + velocity[i] + velocity[i + 1]) / 3.0;
  }

  for (size_t i = 1; i < points.size() - 1; i++) {
    velocity[i] = smoothed[i];
  }

  std::vector<size_t> corners;
  const size_t window = 3;

  for (size_t i = window; i < points.size() - window; i++) {
    if (velocity[i] > velocity_threshold) continue;

    bool is_local_min = true;
    for (size_t j = i - window; j <= i + window; j++) {
      if (i == j) continue;
      if (velocity[j] <= velocity[i]) {
        is_local_min = false;
        break;
      }
    }

    if (is_local_min) {
      size_t prev_idx = std::max((size_t)0, i - window);
      size_t next_idx = std::min(points.size() - 1, i + window);

      Vector2 p_prev = points[prev_idx].position;
      Vector2 p = points[i].position;
      Vector2 p_next = points[next_idx].position;

      Vector2 v_in = vector2_normalize({p.x - p_prev.x, p.y - p_prev.y});
      Vector2 v_out = vector2_normalize({p_next.x - p.x, p_next.y - p.y});
      double dot = v_in.x * v_out.x + v_in.y * v_out.y;

      if (dot < 0.866) {
        corners.push_back(i);
        i += window;
      }
    }
  }

  return corners;
}

std::vector<InputPoint> cull_noisy_points_cpp(const std::vector<InputPoint>& raw_points, double tolerance) {
  if (raw_points.size() <= 1) return raw_points;

  std::vector<InputPoint> cleaned;
  cleaned.push_back(raw_points.front());

  double threshold = tolerance * 0.5;

  for (size_t i = 1; i < raw_points.size(); i++) {
    if (vector2_distance(raw_points[i].position, cleaned.back().position) > threshold) {
      cleaned.push_back(raw_points[i]);
    }
  }

  if (cleaned.size() == 1 && raw_points.size() > 1) {
    InputPoint nudged = raw_points.back();
    nudged.position.x += threshold;
    cleaned.push_back(nudged);
  }

  return cleaned;
}

std::vector<Cubic2> stroke_to_spline_cpp(std::vector<InputPoint>& input_points, double spatial_tolerance,
                                         double velocity_threshold) {
  std::vector<Cubic2> result;

  std::vector<size_t> corners = detect_corners(input_points, velocity_threshold);
  size_t start_index = 0;

  for (size_t corner_index : corners) {
    std::vector<InputPoint> segment = {input_points.begin() + start_index, input_points.begin() + corner_index + 1};
    fit_cubic_recursive(segment, spatial_tolerance, result);
    start_index = corner_index;
  }

  if (start_index < input_points.size() - 1) {
    std::vector<InputPoint> segment = {input_points.begin() + start_index, input_points.end()};
    fit_cubic_recursive(segment, spatial_tolerance, result);
  }

  return result;
}

CubicSpline2 stroke_to_spline(const InputPoint* points, size_t count, double spatial_tolerance, double velocity_threshold) {
  std::vector<InputPoint> input_points(points, points + count);
  std::vector<Cubic2> splines = stroke_to_spline_cpp(input_points, spatial_tolerance, velocity_threshold);

  CubicSpline2 result;
  result.count = splines.size();
  result.cubics = (Cubic2*)malloc(result.count * sizeof(Cubic2));
  for (size_t i = 0; i < result.count; i++) {
    result.cubics[i] = splines[i];
  }

  return result;
}

size_t cull_noisy_points(InputPoint* points, size_t count, double spatial_tolerance) {
  std::vector<InputPoint> input_points(points, points + count);
  std::vector<InputPoint> cleaned = cull_noisy_points_cpp(input_points, spatial_tolerance);

  for (size_t i = 0; i < cleaned.size(); i++) {
    points[i] = cleaned[i];
  }

  return cleaned.size();
}
