#import "math.wgsl"

struct Cubic2 { p0: vec2f, p1: vec2f, p2: vec2f, p3: vec2f }

fn cubic2_reversed(c: Cubic2) -> Cubic2 {
  return Cubic2(c.p3, c.p2, c.p1, c.p0);
}

fn cubic2_transform(c: Cubic2, m: mat4x4f) -> Cubic2 {
  return Cubic2(
    (m * vec4f(c.p0, 0.0, 1.0)).xy,
    (m * vec4f(c.p1, 0.0, 1.0)).xy,
    (m * vec4f(c.p2, 0.0, 1.0)).xy,
    (m * vec4f(c.p3, 0.0, 1.0)).xy
  );
}

// Evaluates the cubic bezier at parameter [t].
fn cubic2_pos(c: Cubic2, t: f32) -> vec2f {
  let mt = 1.0 - t;
  let mt2 = mt * mt;
  let t2 = t * t;

  return c.p0 * (mt2 * mt) + c.p1 * (3.0 * mt2 * t) + c.p2 * (3.0 * mt * t2) + c.p3 * (t2 * t);
}

// Evaluates the tangent of the cubic bezier at parameter [t].
fn cubic2_tan(c: Cubic2, t: f32) -> vec2f {
  let mt = 1.0 - t;
  let mt2 = mt * mt;
  let t2 = t * t;
  return (c.p1 - c.p0) * (3.0 * mt2) + (c.p2 - c.p1) * (6.0 * mt * t) + (c.p3 - c.p2) * (3.0 * t2);
}

// Evaluates the acceleration of the cubic bezier at parameter [t].
fn cubic2_acc(c: Cubic2, t: f32) -> vec2f {
  let mt = 1.0 - t;
  return (c.p2 - 2.0 * c.p1 + c.p0) * (6.0 * mt) + (c.p3 - 2.0 * c.p2 + c.p1) * (6.0 * t);
}

// Evaluates the position and the tangent of the cubic bezier at parameter [t].
fn cubic2_pos_tan(c: Cubic2, t: f32) -> vec4f {
  let mt = 1.0 - t;
  let mt2 = mt * mt;
  let t2 = t * t;

  let pos = c.p0 * (mt2 * mt) + c.p1 * (3.0 * mt2 * t) + c.p2 * (3.0 * mt * t2) + c.p3 * (t2 * t);
  let tan = (c.p1 - c.p0) * (3.0 * mt2) + (c.p2 - c.p1) * (6.0 * mt * t) + (c.p3 - c.p2) * (3.0 * t2);
  return vec4f(pos, tan);
}

// Returns the number of line segments needed to approximate the cubic bezier within the given tolerance.
fn cubic2_wang(c: Cubic2, tolerance: f32) -> f32 {
  let chord = c.p3 - c.p0;
  let chord_len2 = dot(chord, chord);
  let d1 = c.p1 - c.p0;
  let d2 = c.p2 - c.p0;
  let c1 = vec2_cross(d1, chord);
  let c2 = vec2_cross(d2, chord);
  let max_cross2 = max(c1 * c1, c2 * c2);
  if (9.0 * max_cross2 <= 16.0 * tolerance * tolerance * chord_len2) {
    let pr1 = dot(d1, chord);
    let pr2 = dot(d2, chord);
    if (pr1 >= 0.0 && pr1 <= chord_len2 && pr2 >= 0.0 && pr2 <= chord_len2) { return 1.0; }
  }

  let v1 = c.p2 - 2.0 * c.p1 + c.p0;
  let v2 = c.p3 - 2.0 * c.p2 + c.p1;
  let m = max(dot(v1, v1), dot(v2, v2));
  if (m < 1.0e-6) { return 1.0; }
  return max(1.0, sqrt(sqrt(m) * 3.0 / (4.0 * tolerance)));
}

// Splits the cubic bezier at [t].
fn cubic2_split_at(c: Cubic2, t: f32) -> array<Cubic2, 2> {
  let p01 = mix(c.p0, c.p1, t);
  let p12 = mix(c.p1, c.p2, t);
  let p23 = mix(c.p2, c.p3, t);

  let p012 = mix(p01, p12, t);
  let p123 = mix(p12, p23, t);

  let p0123 = mix(p012, p123, t);

  return array<Cubic2, 2>(
    Cubic2(c.p0, p01, p012, p0123),
    Cubic2(p0123, p123, p23, c.p3)
  );
}

// Returns the cubic bezier piece between [t0] and [t1].
fn cubic2_piece_at(c: Cubic2, t0: f32, t1: f32) -> Cubic2 {
  let pos_tan_t0 = cubic2_pos_tan(c, t0);
  let pos_tan_t1 = cubic2_pos_tan(c, t1);
  let dt = (t1 - t0) / 3.0;

  return Cubic2(
    pos_tan_t0.xy,
    pos_tan_t0.xy + pos_tan_t0.zw * dt,
    pos_tan_t1.xy - pos_tan_t1.zw * dt,
    pos_tan_t1.xy
  );
}

fn cubic2_bbox(c: Cubic2) -> vec4f {
  var lo = min(c.p0, min(c.p1, min(c.p2, c.p3)));
  var hi = max(c.p0, max(c.p1, max(c.p2, c.p3)));
  return vec4f(lo, hi);
}