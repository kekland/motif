#include "geometry.h"

#include <stdio.h>

#include <algorithm>
#include <vector>

#include "core/SkPath.h"
#include "core/SkPathMeasure.h"
#include "core/SkPoint.h"
#include "pathops/SkPathOps.h"
#include "src/core/SkGeometry.h"
#include "src/pathops/SkIntersections.h"
#include "src/pathops/SkPathOpsCubic.h"

namespace {
inline void read_d_cubic(SkDCubic& cubic, const Cubic2* src) {
  cubic[0].fX = src->p0.x;
  cubic[0].fY = src->p0.y;
  cubic[1].fX = src->p1.x;
  cubic[1].fY = src->p1.y;
  cubic[2].fX = src->p2.x;
  cubic[2].fY = src->p2.y;
  cubic[3].fX = src->p3.x;
  cubic[3].fY = src->p3.y;
}
inline void write_d_cubic(Cubic2* dst, const SkDCubic& cubic) {
  dst->p0.x = cubic[0].fX;
  dst->p0.y = cubic[0].fY;
  dst->p1.x = cubic[1].fX;
  dst->p1.y = cubic[1].fY;
  dst->p2.x = cubic[2].fX;
  dst->p2.y = cubic[2].fY;
  dst->p3.x = cubic[3].fX;
  dst->p3.y = cubic[3].fY;
}

inline void read_point(SkPoint& pt, const Vector2* src) {
  pt.fX = src->x;
  pt.fY = src->y;
}

inline void read_d_point(SkDPoint& pt, const Vector2* src) {
  pt.fX = src->x;
  pt.fY = src->y;
}

inline void write_point(Vector2* dst, const SkPoint& pt) {
  dst->x = pt.fX;
  dst->y = pt.fY;
}

inline void write_d_point(Vector2* dst, const SkDPoint& pt) {
  dst->x = pt.fX;
  dst->y = pt.fY;
}

inline double eval_cubic_1d(double a, double b, double c, double d, double t) {
  const double mt = 1.0 - t;
  const double b0 = mt * mt * mt;
  const double b1 = 3 * mt * mt * t;
  const double b2 = 3 * mt * t * t;
  const double b3 = t * t * t;
  return b0 * a + b1 * b + b2 * c + b3 * d;
}

inline void approximate_cubic_to_quads(const SkPoint cubic[4], float tolerance, std::vector<Quadratic2>& out_quads,
                                       double t_start, double t_end, std::vector<double>& out_t) {
  SkVector t0, t1;
  SkEvalCubicAt(cubic, 0.0f, nullptr, &t0, nullptr);
  SkEvalCubicAt(cubic, 1.0f, nullptr, &t1, nullptr);

  SkPoint q1;
  float det = t0.cross(t1);
  if (std::abs(det) < 1e-5) {
    q1 = (cubic[0] + cubic[3]) * 0.5f;
  } else {
    SkVector d = cubic[3] - cubic[0];
    float t = d.cross(t1) / det;
    q1 = cubic[0] + t0 * t;
  }

  SkPoint quadMid = (cubic[0] + q1 * 2.0f + cubic[3]) * 0.25f;

  SkPoint cubicMid;
  SkEvalCubicAt(cubic, 0.5f, &cubicMid, nullptr, nullptr);

  float error = (cubicMid - quadMid).length();
  if (error <= tolerance) {
    Vector2 p0 = {cubic[0].fX, cubic[0].fY};
    Vector2 p1 = {q1.fX, q1.fY};
    Vector2 p2 = {cubic[3].fX, cubic[3].fY};
    out_quads.push_back({p0, p1, p2});

    if (t_end < 1.0 - 1e-6) out_t.push_back(t_end);
  } else {
    SkPoint chopped[7];
    SkChopCubicAtHalf(cubic, chopped);

    double t_mid = (t_start + t_end) * 0.5;
    approximate_cubic_to_quads(&chopped[0], tolerance, out_quads, t_start, t_mid, out_t);
    approximate_cubic_to_quads(&chopped[3], tolerance, out_quads, t_mid, t_end, out_t);
  }
}

inline void approximate_circle_to_cubics(const Circle2* circle, SkDCubic* out_cubics) {
  const double k = 0.55228474983079339840;
  const double r = circle->radius;
  const double cx = circle->center.x;
  const double cy = circle->center.y;
  const double kr = k * r;

  out_cubics[0][0] = {cx, cy - r};
  out_cubics[0][1] = {cx + kr, cy - r};
  out_cubics[0][2] = {cx + r, cy - kr};
  out_cubics[0][3] = {cx + r, cy};

  out_cubics[1][0] = {cx + r, cy};
  out_cubics[1][1] = {cx + r, cy + kr};
  out_cubics[1][2] = {cx + kr, cy + r};
  out_cubics[1][3] = {cx, cy + r};

  out_cubics[2][0] = {cx, cy + r};
  out_cubics[2][1] = {cx - kr, cy + r};
  out_cubics[2][2] = {cx - r, cy + kr};
  out_cubics[2][3] = {cx - r, cy};

  out_cubics[3][0] = {cx - r, cy};
  out_cubics[3][1] = {cx - r, cy - kr};
  out_cubics[3][2] = {cx - kr, cy - r};
  out_cubics[3][3] = {cx, cy - r};
}

}  // namespace

int cubic_intersect(const Cubic2* a, const Cubic2* b, Intersection* out_hits) {
  SkDCubic ca, cb;
  read_d_cubic(ca, a);
  read_d_cubic(cb, b);

  SkIntersections result;
  result.intersect(ca, cb);

  const int n = result.used();
  for (int i = 0; i < n; i++) {
    const SkDPoint& p = result.pt(i);
    write_d_point(&out_hits[i].pt, p);
    out_hits[i].tA = result[0][i];
    out_hits[i].tB = result[1][i];
  }

  return n;
}

int cubic_circle_intersect(const Cubic2* a, const Circle2* b, Intersection* out_hits) {
  SkDCubic cubic;
  read_d_cubic(cubic, a);
  
  SkDCubic circle_cubics[4];
  approximate_circle_to_cubics(b, circle_cubics);

  int total_hits = 0;

  for (int c = 0; c < 4; c++) {
    SkIntersections result;
    result.intersect(cubic, circle_cubics[c]);

    const int n = result.used();
    for (int i = 0; i < n; i++) {
      bool duplicate = false;
      for (int j = 0; j < total_hits; j++) {
        if (std::abs(out_hits[j].tA - result[0][i]) < 1e-6) {
          duplicate = true;
          break;
        }
      }
      if (duplicate) continue;

      const SkDPoint& p = result.pt(i);
      write_d_point(&out_hits[total_hits].pt, p);
      out_hits[total_hits].tA = result[0][i];
      out_hits[total_hits].tB = (c + result[1][i]) / 4.0;
      total_hits++;
    }
  }

  return total_hits;
}

int cubic_self_intersect(const Cubic2* a, Intersection* out_hit) {
  SkPoint pts[4];
  read_point(pts[0], &a->p0);
  read_point(pts[1], &a->p1);
  read_point(pts[2], &a->p2);
  read_point(pts[3], &a->p3);

  double t[2], s[2];
  SkCubicType type = SkClassifyCubic(pts, t, s);
  if (type != SkCubicType::kLoop) return 0;

  const double t0 = t[0] / s[0];
  const double t1 = t[1] / s[1];

  if (t0 <= 0 || t0 >= 1 || t1 <= 0 || t1 >= 1) return 0;

  out_hit->pt.x = eval_cubic_1d(a->p0.x, a->p1.x, a->p2.x, a->p3.x, t0);
  out_hit->pt.y = eval_cubic_1d(a->p0.y, a->p1.y, a->p2.y, a->p3.y, t0);
  out_hit->tA = t0;
  out_hit->tB = t1;
  return 1;
}

void cubic_bbox_tight(const Cubic2* a, Aabb2* out_bbox) {
  double minX = std::min(a->p0.x, a->p3.x);
  double minY = std::min(a->p0.y, a->p3.y);
  double maxX = std::max(a->p0.x, a->p3.x);
  double maxY = std::max(a->p0.y, a->p3.y);

  SkScalar tx[2];
  const int nx = SkFindCubicExtrema(a->p0.x, a->p1.x, a->p2.x, a->p3.x, tx);
  for (int i = 0; i < nx; i++) {
    const double x = eval_cubic_1d(a->p0.x, a->p1.x, a->p2.x, a->p3.x, tx[i]);
    minX = std::min(minX, x);
    maxX = std::max(maxX, x);
  }

  SkScalar ty[2];
  const int ny = SkFindCubicExtrema(a->p0.y, a->p1.y, a->p2.y, a->p3.y, ty);
  for (int i = 0; i < ny; i++) {
    const double y = eval_cubic_1d(a->p0.y, a->p1.y, a->p2.y, a->p3.y, ty[i]);
    minY = std::min(minY, y);
    maxY = std::max(maxY, y);
  }

  out_bbox->min.x = minX;
  out_bbox->min.y = minY;
  out_bbox->max.x = maxX;
  out_bbox->max.y = maxY;
}

double cubic_arc_length(const Cubic2* a) {
  SkPath path;
  path.moveTo(a->p0.x, a->p0.y);
  path.cubicTo(a->p1.x, a->p1.y, a->p2.x, a->p2.y, a->p3.x, a->p3.y);
  SkPathMeasure measure(path, false);
  return static_cast<double>(measure.getLength());
}

int cubic_pos_tan_at_distance(const Cubic2* a, double distance, Vector2* out_pos, Vector2* out_tan) {
  SkPath path;
  path.moveTo(a->p0.x, a->p0.y);
  path.cubicTo(a->p1.x, a->p1.y, a->p2.x, a->p2.y, a->p3.x, a->p3.y);
  SkPathMeasure measure(path, false);
  SkPoint pos;
  SkVector tan;
  if (!measure.getPosTan(static_cast<SkScalar>(distance), &pos, &tan)) return 0;

  write_point(out_pos, pos);
  write_point(out_tan, tan);
  return 1;
}

int cubic_find_inflections(const Cubic2* a, double* out) {
  SkPoint pts[4];
  read_point(pts[0], &a->p0);
  read_point(pts[1], &a->p1);
  read_point(pts[2], &a->p2);
  read_point(pts[3], &a->p3);

  SkScalar t[2];
  const int n = SkFindCubicInflections(pts, t);
  int validRoots = 0;
  for (int i = 0; i < n; i++) {
    if (t[i] > 1e-4f && t[i] < 1.0f - 1e-4f) {
      out[validRoots++] = t[i];
    }
  }

  return validRoots;
}

int cubic_to_quads(const Cubic2* a, float tolerance, Quadratic2* out_quads, double* out_t, bool chop_at_inflections) {
  std::vector<Quadratic2> result;
  std::vector<double> result_t;

  SkPoint cubic[4];
  read_point(cubic[0], &a->p0);
  read_point(cubic[1], &a->p1);
  read_point(cubic[2], &a->p2);
  read_point(cubic[3], &a->p3);

  if (chop_at_inflections) {
    SkScalar inflectionTs[2];
    int roots = SkFindCubicInflections(cubic, inflectionTs);

    SkScalar validTs[2];
    int validRoots = 0;
    for (int i = 0; i < roots; i++) {
      if (inflectionTs[i] > 1e-4f && inflectionTs[i] < 1.0f - 1e-4f) {
        validTs[validRoots++] = inflectionTs[i];
      }
    }

    if (validRoots > 0) {
      SkPoint chopped[10];
      SkChopCubicAt(cubic, chopped, validTs, validRoots);

      double t_start = 0.0;
      for (int i = 0; i <= validRoots; i++) {
        double t_end = (i == validRoots) ? 1.0 : validTs[i];
        approximate_cubic_to_quads(&chopped[i * 3], tolerance, result, t_start, t_end, result_t);
      }
    } else {
      approximate_cubic_to_quads(cubic, tolerance, result, 0.0, 1.0, result_t);
    }
  } else {
    approximate_cubic_to_quads(cubic, tolerance, result, 0.0, 1.0, result_t);
  }

  const int n = static_cast<int>(result.size());
  for (int i = 0; i < n; i++) {
    out_quads[i].p0 = result[i].p0;
    out_quads[i].p1 = result[i].p1;
    out_quads[i].p2 = result[i].p2;
  }
  
  for (int i = 0; i < n - 1; i++) {
    out_t[i] = result_t[i];
  }

  return n;
}
