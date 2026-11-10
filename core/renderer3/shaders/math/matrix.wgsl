fn mat4_translate2(t: vec2f) -> mat4x4f {
  return mat4x4f(
    vec4f(1.0, 0.0, 0.0, 0.0),
    vec4f(0.0, 1.0, 0.0, 0.0),
    vec4f(0.0, 0.0, 1.0, 0.0),
    vec4f(t, 0.0, 1.0)
  );
}

fn mat4_scale2(s: vec2f) -> mat4x4f {
  return mat4x4f(
    vec4f(s.x, 0.0, 0.0, 0.0),
    vec4f(0.0, s.y, 0.0, 0.0),
    vec4f(0.0, 0.0, 1.0, 0.0),
    vec4f(0.0, 0.0, 0.0, 1.0)
  );
}

fn mat4_translate2_scale2(t: vec2f, s: vec2f) -> mat4x4f {
  return mat4x4f(
    vec4f(s.x, 0.0, 0.0, 0.0),
    vec4f(0.0, s.y, 0.0, 0.0),
    vec4f(0.0, 0.0, 1.0, 0.0),
    vec4f(t, 0.0, 1.0)
  );
}

fn mat4_get_scale2(m: mat4x4f) -> vec2f {
  return vec2f(m[0][0], m[1][1]);
}

fn mat4_get_max_scale_on_axis(m: mat4x4f) -> f32 {
  let scale = mat4_get_scale2(m);
  return max(scale.x, scale.y);
}