#include <cmath>

#include "types.h"


Vector2 vector2_normalize(const Vector2& v) {
  double length = std::hypot(v.x, v.y);
  if (length > 0.0) return {v.x / length, v.y / length};
  return {0.0, 0.0};
}

double vector2_distance(const Vector2& v1, const Vector2& v2) { return std::hypot(v2.x - v1.x, v2.y - v1.y); }

Vector2 cubic2_pos(const Cubic2& c, double t) {
  double mt = 1 - t, mt2 = mt * mt, t2 = t * t;
  return {
      c.p0.x * (mt2 * mt) + c.p1.x * (3 * mt2 * t) + c.p2.x * (3 * mt * t2) + c.p3.x * (t2 * t),
      c.p0.y * (mt2 * mt) + c.p1.y * (3 * mt2 * t) + c.p2.y * (3 * mt * t2) + c.p3.y * (t2 * t),
  };
}

Vector2 cubic2_tan(const Cubic2& c, double t) {
  double mt = 1 - t, mt2 = mt * mt, t2 = t * t;
  return {
      (c.p1.x - c.p0.x) * (3 * mt2) + (c.p2.x - c.p1.x) * (6 * mt * t) + (c.p3.x - c.p2.x) * (3 * t2),
      (c.p1.y - c.p0.y) * (3 * mt2) + (c.p2.y - c.p1.y) * (6 * mt * t) + (c.p3.y - c.p2.y) * (3 * t2),
  };
}

Vector2 cubic2_acc(const Cubic2& c, double t) {
  double mt = 1 - t;
  return {
      (c.p2.x - 2 * c.p1.x + c.p0.x) * (6 * mt) + (c.p3.x - 2 * c.p2.x + c.p1.x) * (6 * t),
      (c.p2.y - 2 * c.p1.y + c.p0.y) * (6 * mt) + (c.p3.y - 2 * c.p2.y + c.p1.y) * (6 * t),
  };
}
