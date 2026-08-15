#ifndef TYPES_H
#define TYPES_H

#include "stddef.h"

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
  Vector2* points;
  size_t count;
} Polyline2;

typedef struct {
  Vector2 center;
  double radius;
} Circle2;

typedef struct {
  Vector2 p0;
  Vector2 p1;
  Vector2 p2;
} Quadratic2;

typedef struct {
  Vector2 pt;
  double tA, tB;
} Intersection;

typedef struct {
  Vector2 position;
  double timestamp_ms;
  double pressure;
} InputPoint;

typedef struct {
  Cubic2* cubics;
  size_t count;
} CubicSpline2;

typedef struct {
  double arc_length;
  double weight;
} WeightSample;

typedef struct {
  WeightSample* samples;
  size_t count;
} SplineWeightProfile;

#endif  // TYPES_H