#import "math.wgsl"

struct Quadratic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
}

fn quadratic2_pos_tan(q: Quadratic2, t: f32) -> vec4f {
  let u = 1.0 - t;
  let pos = u * u * q.p0 + 2.0 * u * t * q.p1 + t * t * q.p2;
  let tan = 2.0 * u * (q.p1 - q.p0) + 2.0 * t * (q.p2 - q.p1);
  return vec4f(pos, tan);
}

fn quadratic2_bbox(c: Quadratic2) -> vec4f {
  var lo = min(c.p0, min(c.p1, c.p2));
  var hi = max(c.p0, max(c.p1, c.p2));
  return vec4f(lo, hi);
}

fn quadratic2_transform(q: Quadratic2, m: mat4x4f) -> Quadratic2 {
  return Quadratic2(
    (m * vec4f(q.p0, 0.0, 1.0)).xy,
    (m * vec4f(q.p1, 0.0, 1.0)).xy,
    (m * vec4f(q.p2, 0.0, 1.0)).xy,
  );
}

fn quadratic2_wang(q: Quadratic2, tolerance: f32) -> f32 {
  let chord = q.p2 - q.p0;
  let chord_len2 = dot(chord, chord);
  let d = q.p1 - q.p0;
  let c = vec2_cross(d, chord);
  if (c * c <= 4.0 * tolerance * tolerance * chord_len2) {
    let pr = dot(d, chord);
    if (pr >= 0.0 && pr <= chord_len2) { return 1.0; }
  }

  let v = q.p2 - 2.0 * q.p1 + q.p0;
  let m = dot(v, v);
  if (m < 1.0e-6) { return 1.0; }
  return max(1.0, sqrt(sqrt(m) * 3.0 / (4.0 * tolerance)));
}
