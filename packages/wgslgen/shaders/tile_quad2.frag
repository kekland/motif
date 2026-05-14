#version 460 core
#include <flutter/runtime_effect.glsl>

const int MAX_QUAD_COUNT = 128;

#define PI 3.14159265358979
#define TWO_PI 6.28318530717958

uniform float u_stroke_width;
uniform float u_quad_count;

uniform vec2 u_quad_point[MAX_QUAD_COUNT * 3];
uniform vec4 u_quad_bbox[MAX_QUAD_COUNT];

out vec4 f_color;

vec2 bezier_pt(float t, vec2 p0, vec2 p1, vec2 p2) {
  float mt = 1.0 - t;
  return mt * mt * p0 + 2.0 * mt * t * p1 + t * t * p2;
}

float cbrt(float x) {
  return sign(x) * pow(abs(x), 1.0 / 3.0);
}

float cos_acos_3(float x) {
  x = sqrt(0.5 + 0.5 * x);
  return x * (x * (x * (x * -0.008972 + 0.039071) - 0.107074) + 0.576975) + 0.5;
}

float solve_cardano(vec2 q, vec2 p0, vec2 p1, vec2 p2) {
  vec2 A = p1 - p0;
  vec2 B = p2 - 2.0 * p1 + p0;
  vec2 C = p0 - q;

  float a = dot(B, B);
  float b = 3.0 * dot(A, B);
  float c = 2.0 * dot(A, A) + dot(C, B);
  float d = dot(A, C);

  if (abs(a) < 1e-6) {
    vec2 line_dir = p2 - p0;
    float line_len_sq = dot(line_dir, line_dir);
    if (line_len_sq < 1e-6) return 0.0;
    return clamp(dot(-C, line_dir) / line_len_sq, 0.0, 1.0);
  }

  b /= a; c /= a; d /= a;

  float p = c - (b * b) / 3.0;
  float q_coeff = d - (b * c) / 3.0 + (2.0 * b * b * b) / 27.0;
  float discriminant = (q_coeff * q_coeff) / 4.0 + (p * p * p) / 27.0;

  float best_t = 0.0;
  float min_dist_sq = 1e20;

  #define CHECK_T(t_val) \
    { \
      float clamped_t = clamp(t_val, 0.0, 1.0); \
      vec2 pt = bezier_pt(clamped_t, p0, p1, p2); \
      float dist_sq = dot(pt - q, pt - q); \
      if (dist_sq < min_dist_sq) { \
        min_dist_sq = dist_sq; \
        best_t = clamped_t; \
      } \
    }

  if (discriminant > 0.0) {
    float root = sqrt(discriminant);
    float u = cbrt(-q_coeff / 2.0 + root);
    float v = cbrt(-q_coeff / 2.0 - root);
    float t = u + v - b / 3.0;
    CHECK_T(t);
  }
  else {
    float r = 2.0 * sqrt(-p / 3.0);
    float k = -q_coeff / (2.0 * sqrt(-(p * p * p) / 27.0));
    
    float c1 = cos_acos_3(clamp(k, -1.0, 1.0));
    float s1 = sqrt(max(0.0, 1.0 - c1 * c1));

    const float SQRT3_2 = 0.86602540378; // sqrt(3)/2
    float c2 = c1 * -0.5 - s1 * SQRT3_2;
    float c3 = c1 * -0.5 + s1 * SQRT3_2;

    float boff = b / 3.0;
    float t1 = r * c1 - boff;
    float t2 = r * c2 - boff;
    float t3 = r * c3 - boff;

    CHECK_T(t1);
    CHECK_T(t2);
    CHECK_T(t3);
  }

  return best_t;
}

float dist_to_aabb_sq(vec2 q, vec2 bmin, vec2 bmax) {
  vec2 d = max(max(bmin - q, q - bmax), vec2(0.0));
  return dot(d, d);
}

void main() {
  vec2 frag_world = FlutterFragCoord().xy;
  float min_dist_sq = 1e20;
  int count = int(u_quad_count);

  float reject_threshold_sq = (u_stroke_width * 0.5) + 0.5;
  reject_threshold_sq *= reject_threshold_sq;

  for (int i = 0; i < MAX_QUAD_COUNT; i++) {
    if (i >= count) break;
    vec4 bbox = u_quad_bbox[i];
    float dist_sq_aabb = dist_to_aabb_sq(frag_world, bbox.xy, bbox.zw);
    if (dist_sq_aabb > reject_threshold_sq) continue;
    if (dist_sq_aabb > min_dist_sq) continue;

    vec2 p0 = u_quad_point[i * 3];
    vec2 p1 = u_quad_point[i * 3 + 1];
    vec2 p2 = u_quad_point[i * 3 + 2];

    float t = solve_cardano(frag_world, p0, p1, p2);

    vec2 pt = bezier_pt(t, p0, p1, p2);
    vec2 d = pt - frag_world;
    float dist_sq = dot(d, d);

    min_dist_sq = min(min_dist_sq, dist_sq);
  }

  float pixel_dist = sqrt(min_dist_sq) - (u_stroke_width / 2.0);
  float coverage = 1.0 - smoothstep(-0.5, 0.5, pixel_dist);
  f_color = vec4(1.0) * coverage;
}