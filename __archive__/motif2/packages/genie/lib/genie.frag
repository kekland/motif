#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 f_color;

uniform vec2 u_size;
uniform sampler2D u_texture;

uniform float u_pixel_ratio;
uniform vec2 u_offset;
uniform float u_padding;

uniform vec4 u_src_rect; // ltwh
uniform vec4 u_dst_rect; // ltwh
uniform vec2 u_total_size;

uniform vec4 u_cubic1_x;
uniform vec4 u_cubic1_y;
uniform vec4 u_cubic2_x;
uniform vec4 u_cubic2_y;

uniform vec2 u_direction;
uniform vec2 u_src_edge_center;
uniform vec2 u_dst_edge_center;

uniform float u_t0;
uniform float u_t1;
uniform float u_opacity;

vec2 cubic_eval(vec4 x, vec4 y, float t) {
  float mt = 1.0 - t;
  float mt2 = mt * mt;
  float t2 = t * t;

  vec2 p0 = vec2(x.x, y.x);
  vec2 p1 = vec2(x.y, y.y);
  vec2 p2 = vec2(x.z, y.z);
  vec2 p3 = vec2(x.w, y.w);

  return p0 * (mt2 * mt) + p1 * (3.0 * mt2 * t) + p2 * (3.0 * mt * t2) + p3 * (t2 * t);
}

vec2 cubic1_eval(float t) {
  return cubic_eval(u_cubic1_x, u_cubic1_y, t);
}

vec2 cubic2_eval(float t) {
  return cubic_eval(u_cubic2_x, u_cubic2_y, t);
}

float axis_t_eval(vec2 pos, bool is_horizontal) {
  vec2 p1 = u_src_edge_center;
  vec2 p2 = u_dst_edge_center;
  vec2 dir = p2 - p1;

  if (is_horizontal) {
    return (pos.x - p1.x) / dir.x;
  }
  else {
    return (pos.y - p1.y) / dir.y;
  }
}

bool is_approx_equal(float a, float b) {
  return abs(a - b) < 1.0;
}

void main() {
  float t_shrink = 1.0 - u_t0;
  float t_slide = 1.0 - u_t1;

  vec2 total_size = u_size / u_pixel_ratio;
  
  vec2 pos = (FlutterFragCoord().xy / u_pixel_ratio);

  vec2 flutter_size = u_size / u_pixel_ratio;
  bool is_clipped = !is_approx_equal(flutter_size.x, total_size.x) || !is_approx_equal(flutter_size.y, total_size.y);
  if (is_clipped) {
    pos = pos - u_offset;
  }

  bool is_horizontal = abs(u_direction.x) > abs(u_direction.y);

  float axis_t = axis_t_eval(pos, is_horizontal);
  vec2 c1_pos = cubic1_eval(axis_t);
  vec2 c2_pos = cubic2_eval(axis_t);

  vec2 c1_cutoff = mix(u_dst_rect.xy, c1_pos, t_shrink);
  vec2 c2_cutoff = mix(u_dst_rect.xy + u_dst_rect.zw, c2_pos, t_shrink);
  
  vec2 mod_pos = pos - u_dst_rect.xy;

  if (is_horizontal) {
    mod_pos = vec2(
      pos.x - u_dst_rect.x + (t_slide * total_size.x) * u_direction.x,
      mix(0.0, u_dst_rect.w, (pos.y - c1_cutoff.y) / (c2_cutoff.y - c1_cutoff.y))
    );
  }
  else {
    mod_pos = vec2(
      mix(0.0, u_dst_rect.z, (pos.x - c1_cutoff.x) / (c2_cutoff.x - c1_cutoff.x)),
      pos.y - u_dst_rect.y + (t_slide * total_size.y) * u_direction.y
    );
  }

  if (axis_t > (1.0 - t_slide)) { discard; }

  float opacity_factor = smoothstep(0.75, 1.0, 1.0 - t_slide);
  float axis_opacity = mix(opacity_factor, 1.0, axis_t);

  vec2 uv = (u_dst_rect.xy + mod_pos) / u_total_size;

  if (is_clipped) {
    uv = uv * u_total_size + u_offset;
    uv = uv / flutter_size;
  }

  f_color = texture(u_texture, uv) * u_opacity * axis_opacity;
}
