#ifndef GEOMETRY_H
#define GEOMETRY_H

#include "stdbool.h"
#include "stddef.h"

#include "exports.h"
#include "types.h"

FFI int cubic_intersect(const Cubic2* a, const Cubic2* b, Intersection* out_hits);
FFI int cubic_circle_intersect(const Cubic2* a, const Circle2* b, Intersection* out_hits);
FFI int cubic_self_intersect(const Cubic2* a, Intersection* out_hit);
FFI void cubic_bbox_tight(const Cubic2* a, Aabb2* out_bbox);
FFI double cubic_arc_length(const Cubic2* a);
FFI int cubic_pos_tan_at_distance(const Cubic2* a, double distance, Vector2* out_pos, Vector2* out_tan);
FFI int cubic_find_inflections(const Cubic2* a, double* out);
FFI int cubic_to_quads(const Cubic2* a, float tolerance, Quadratic2* out_quads, double* out_t, bool chop_at_inflections);

FFI size_t cull_noisy_points(InputPoint* points, size_t count, double spatial_tolerance);
FFI CubicSpline2 stroke_to_spline(const InputPoint* points, size_t count, double spatial_tolerance, double velocity_threshold);
// FFI SplineWeightProfile stroke_to_weight_profile(const InputPoint* points, size_t count, double weight_tolerance, double spatial_tolerance);

#endif  // GEOMETRY_H