#import "math.wgsl"

fn count_arc_segments(angle: f32, r: f32, tolerance: f32, max_segments: u32) -> u32 {
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

  return clamp(u32(ceil(angle / step)), 1u, max_segments);
}
