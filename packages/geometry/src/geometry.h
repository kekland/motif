#ifndef GEOMETRY_H
#define GEOMETRY_H

#include "stdbool.h"
#include "stddef.h"

// Export attributes
#if defined(_WIN32)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((__visibility__("default"))) __attribute__((__used__))
#endif

#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC
#endif

#define FFI EXTERNC EXPORT

typedef struct {
  double x, y;
} Vector2;

typedef struct {
  Vector2 min, max;
} Aabb2;

typedef struct {
  Vector2 p0;
  Vector2 p1;
  Vector2 p2;
  Vector2 p3;
} Cubic2;

typedef struct {
  Vector2 p0;
  Vector2 p1;
  Vector2 p2;
} Quadratic2;

typedef struct {
  Vector2 pt;
  double tA, tB;
} Intersection;

FFI int cubic_intersect(const Cubic2* a, const Cubic2* b, Intersection* out_hits);
FFI int cubic_self_intersect(const Cubic2* a, Intersection* out_hit);
FFI void cubic_bbox_tight(const Cubic2* a, Aabb2* out_bbox);
FFI double cubic_arc_length(const Cubic2* a);
FFI int cubic_pos_tan_at_distance(const Cubic2* a, double distance, Vector2* out_pos, Vector2* out_tan);
FFI int cubic_find_inflections(const Cubic2* a, double* out);
FFI int cubic_to_quads(const Cubic2* a, float tolerance, Quadratic2* out_quads, double* out_t, bool chop_at_inflections);

#endif  // GEOMETRY_H