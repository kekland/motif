#import "../shared/constants.wgsl"

fn vec2_orthogonal(v: vec2f) -> vec2f {
  return vec2f(-v.y, v.x);
}

fn vec2_safe_tangent(tan: vec2f, fallback: vec2f) -> vec2f {
  return select(normalize(tan), normalize(fallback), dot(tan, tan) < 1e-9);
}

fn count_arc_segments(angle: f32, r: f32, tolerance: f32) -> u32 {
  let x = tolerance / r;

  var step: f32;
  if (x >= 2.0) {
    step = 2.0 * PI;
  }
  else if (x > 1e-3) {
    step = 2.0 * acos(1.0 - x);
  }
  else {
    step = 2.0 * sqrt(2.0 * x);
  }

  return clamp(u32(ceil(angle / step)), 1u, MAX_ARC_SEGMENTS);
}
