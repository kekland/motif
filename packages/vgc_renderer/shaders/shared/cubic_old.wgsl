#define_import_path cubic

// A cubic Bezier curve.
struct Cubic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
  p3: vec2f,
}

// Returns an approximate bounding box for the cubic curve.
fn cubic2_bbox(c: Cubic2) -> vec4f {
  let min_pt = min(min(c.p0, c.p1), min(c.p2, c.p3));
  let max_pt = max(max(c.p0, c.p1), max(c.p2, c.p3));
  return vec4f(min_pt, max_pt);
}

fn _cubic2_arc_len_vel(v0: vec2f, v1: vec2f, v2: vec2f, t: f32) -> f32 {
  let mt = 1.0 - t;
  let vel = v0 * (mt * mt) + v1 * (2.0 * mt * t) + v2 * (t * t);
  return length(vel);
}

fn _cubic2_arc_len_quadrature(c: Cubic2) -> f32 {
  let v0 = 3.0 * (c.p1 - c.p0);
  let v1 = 3.0 * (c.p2 - c.p1);
  let v2 = 3.0 * (c.p3 - c.p2);

  var arc_len = 0.0;

  arc_len += 0.28444444 * _cubic2_arc_len_vel(v0, v1, v2, 0.5);
  
  arc_len += 0.23931434 * _cubic2_arc_len_vel(v0, v1, v2, 0.23076535);
  arc_len += 0.23931434 * _cubic2_arc_len_vel(v0, v1, v2, 0.76923465);
  
  arc_len += 0.11846344 * _cubic2_arc_len_vel(v0, v1, v2, 0.04691008);
  arc_len += 0.11846344 * _cubic2_arc_len_vel(v0, v1, v2, 0.95308992);

  return arc_len;
}

fn cubic2_arc_len(c: Cubic2) -> f32 {
  var splits: array<f32, 8>;
  var count = 0u;

  var inf_ts: vec2f;
  let inflection_count = cubic2_find_inflections(c, &inf_ts);
  for (var i = 0u; i < inflection_count; i++) {
    splits[count] = inf_ts[i];
    count += 1u;
  }

  let extrema = cubic2_find_extrema(c);
  for (var i = 0u; i < extrema.count; i++) {
    splits[count] = extrema.t[i];
    count += 1u;
  }

  for (var i = 1u; i < count; i++) {
    let key = splits[i];
    var j = i;
    while (j > 0u && splits[j - 1u] > key) {
      splits[j] = splits[j - 1u];
      j -= 1u;
    }
    splits[j] = key;
  }

  var total_len = 0.0;
  var t0 = 0.0;

  for (var i = 0u; i < count; i++) {
    let t1 = splits[i];
    if (t1 - t0 > 1.0e-4) {
      let piece = cubic2_piece_at(c, t0, t1);
      total_len += _cubic2_arc_len_quadrature(piece);
      t0 = t1;
    }
  }

  if (1.0 - t0 > 1.0e-4) {
    let piece = cubic2_piece_at(c, t0, 1.0);
    total_len += _cubic2_arc_len_quadrature(piece);
  }

  return total_len;
}

fn cubic2_distance_to_t(c: Cubic2, dist: f32) -> f32 {
  var t_min = 0.0; var t_max = 1.0; var local_t = 0.5;

  for (var iter = 0u; iter < 12u; iter++) {
    local_t = (t_min + t_max) * 0.5;
    let sub_curve = cubic2_piece_at(c, 0.0, local_t);
    let dist_at_t = cubic2_arc_len(sub_curve);

    if (dist_at_t < dist) { t_min = local_t; }
    else { t_max = local_t; }
  }

  return local_t;
}

fn cubic2_distance_at_t(c: Cubic2, t: f32) -> f32 {
  let sub_curve = cubic2_piece_at(c, 0.0, t);
  return cubic2_arc_len(sub_curve);
}

fn cubic2_eval_pos(c: Cubic2, t: f32) -> vec2f {
  let mt = 1.0 - t;
  let mt2 = mt * mt;
  let t2 = t * t;

  return c.p0 * (mt2 * mt) + c.p1 * (3.0 * mt2 * t) + c.p2 * (3.0 * mt * t2) + c.p3 * (t2 * t);
}

fn cubic2_eval_tan(c: Cubic2, t: f32) -> vec2f {
  let mt = 1.0 - t;
  let mt2 = mt * mt;
  let t2 = t * t;

  return (c.p1 - c.p0) * (3.0 * mt2) + (c.p2 - c.p1) * (6.0 * mt * t) + (c.p3 - c.p2) * (3.0 * t2);
}

fn cubic2_eval_acc(c: Cubic2, t: f32) -> vec2f {
  let mt = 1.0 - t;
  return (c.p2 - 2.0 * c.p1 + c.p0) * (6.0 * mt) + (c.p3 - 2.0 * c.p2 + c.p1) * (6.0 * t);
}

fn cubic2_eval_pos_tan(c: Cubic2, t: f32) -> vec4f {
  let mt = 1.0 - t;
  let mt2 = mt * mt;
  let t2 = t * t;

  let pos = c.p0 * (mt2 * mt) + c.p1 * (3.0 * mt2 * t) + c.p2 * (3.0 * mt * t2) + c.p3 * (t2 * t);
  let tan = (c.p1 - c.p0) * (3.0 * mt2) + (c.p2 - c.p1) * (6.0 * mt * t) + (c.p3 - c.p2) * (3.0 * t2);

  return vec4f(pos, tan);
}

fn cubic2_eval_signed_curvature(c: Cubic2, t: f32) -> f32 {
  let tan = cubic2_eval_tan(c, t);
  let acc = cubic2_eval_acc(c, t);
  let cross = tan.x * acc.y - tan.y * acc.x;
  let speed = length(tan);
  let speed3 = speed * speed * speed;
  if (speed3 < 1.0e-9) { return 0.0; }
  return cross / speed3;
}

fn cubic2_eval_center_of_curvature(c: Cubic2, t: f32) -> vec2f {
  let pos_tan = cubic2_eval_pos_tan(c, t);
  let pos = pos_tan.xy;

  let tan = normalize(pos_tan.zw);
  let normal = vec2f(-tan.y, tan.x);

  let k = cubic2_eval_signed_curvature(c, t);
  if (abs(k) < 1.0e-5) {
    return pos + normal * (1.0e6 * sign(k));
  }

  let radius = 1.0 / k;
  return pos + normal * radius;
}

fn cubic2_max_chord_deviation(c: Cubic2) -> f32 {
  let chord = c.p3 - c.p0;
  let len_sq = dot(chord, chord);
  if (len_sq < 1.0e-8) { return max(distance(c.p1, c.p0), distance(c.p2, c.p0)); }
  let inv_len = inverseSqrt(len_sq);
  let d1 = abs(chord.x * (c.p1.y - c.p0.y) - chord.y * (c.p1.x - c.p0.x)) * inv_len;
  let d2 = abs(chord.x * (c.p2.y - c.p0.y) - chord.y * (c.p2.x - c.p0.x)) * inv_len;
  return max(d1, d2);
}

fn cubic2_chop_at(c: Cubic2, t: f32) -> array<Cubic2, 2> {
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

fn cubic2_piece_at(c: Cubic2, t0: f32, t1: f32) -> Cubic2 {
  let pos_tan_t0 = cubic2_eval_pos_tan(c, t0);
  let pos_tan_t1 = cubic2_eval_pos_tan(c, t1);
  let dt = (t1 - t0) / 3.0;

  return Cubic2(
    pos_tan_t0.xy,
    pos_tan_t0.xy + pos_tan_t0.zw * dt,
    pos_tan_t1.xy - pos_tan_t1.zw * dt,
    pos_tan_t1.xy
  );
}

fn cubic2_chop_at_half(c: Cubic2) -> array<Cubic2, 2> {
  return cubic2_chop_at(c, 0.5);
}

fn vec2f_cross(a: vec2f, b: vec2f) -> f32 { return a.x * b.y - a.y * b.x; }

fn cubic2_find_inflections(c: Cubic2, out_t: ptr<function, vec2f>) -> u32 {
  let A = c.p1 - c.p0;
  let B = c.p2 - 2.0 * c.p1 + c.p0;
  let C = c.p3 - 3.0 * c.p2 + 3.0 * c.p1 - c.p0;

  let a = vec2f_cross(B, C);
  let b = vec2f_cross(A, C);
  let c_coeff = vec2f_cross(A, B);

  var roots_found = 0u;
  var roots = vec2f(-1.0, -1.0);

  if (abs(a) < 1.0e-5) {
    if (abs(b) > 1.0e-5) {
      let t = -c_coeff / b;
      if (t > 1.0e-4 && t < 1.0 - 1.0e-4) {
        roots[0] = t;
        roots_found = 1u;
      }
    }
  }
  else {
    let disc = b * b - 4.0 * a * c_coeff;
    if (disc >= 0.0) {
      let sqrt_disc = sqrt(disc);
      let t1 = (-b + sqrt_disc) / (2.0 * a);
      let t2 = (-b - sqrt_disc) / (2.0 * a);

      if (t1 > 1.0e-4 && t1 < 1.0 - 1.0e-4) {
        roots[roots_found] = t1;
        roots_found = roots_found + 1u;
      }

      if (t2 > 1.0e-4 && t2 < 1.0 - 1.0e-4) {
        roots[roots_found] = t2;
        roots_found = roots_found + 1u;
      }
    }
  }

  if (roots_found == 2u && roots[0] > roots[1]) {
    let temp = roots[0];
    roots[0] = roots[1];
    roots[1] = temp;
  }

  *out_t = roots;
  return roots_found;
}

struct Cubic2ChopAtInflectionsResult {
  cubics: array<Cubic2, 3>,
  t0: array<f32, 3>,
  t1: array<f32, 3>,
  count: u32,
}

fn cubic2_chop_at_inflections(c: Cubic2) -> Cubic2ChopAtInflectionsResult {
  var out: Cubic2ChopAtInflectionsResult;
  
  var inflection_ts: vec2f;
  let inflection_count = cubic2_find_inflections(c, &inflection_ts);

  if (inflection_count == 0u) {
    out.cubics[0] = c;
    out.t0[0] = 0.0;
    out.t1[0] = 1.0;
    out.count = 1u;
  }
  else if (inflection_count == 1u) {
    let t1 = inflection_ts[0];
    let chopped = cubic2_chop_at(c, t1);

    out.cubics[0] = chopped[0];
    out.t0[0] = 0.0;
    out.t1[0] = t1;

    out.cubics[1] = chopped[1];
    out.t0[1] = t1;
    out.t1[1] = 1.0;

    out.count = 2u;
  }
  else if (inflection_count == 2u) {
    let t1 = inflection_ts[0];
    let t2 = inflection_ts[1];
    
    let chopped1 = cubic2_chop_at(c, t1);
    out.cubics[0] = chopped1[0];
    out.t0[0] = 0.0;
    out.t1[0] = t1;

    let local_t2 = (t2 - t1) / (1.0 - t1);
    let chopped2 = cubic2_chop_at(chopped1[1], local_t2);
    out.cubics[1] = chopped2[0];
    out.t0[1] = t1;
    out.t1[1] = t2;

    out.cubics[2] = chopped2[1];
    out.t0[2] = t2;
    out.t1[2] = 1.0;

    out.count = 3u;
  }

  return out;
}

fn cubic2_wang(c: Cubic2, tolerance: f32) -> f32 {
  let v1 = c.p2 - 2.0 * c.p1 + c.p0;
  let v2 = c.p3 - 2.0 * c.p2 + c.p1;
  let m = max(dot(v1, v1), dot(v2, v2));
  if (m < 1.0e-6) { return 1.0; }
  return sqrt(sqrt(m) * 3.0 / (4.0 * tolerance));
}

fn cubic2_transform(c: Cubic2, m: mat4x4f) -> Cubic2 {
  return Cubic2(
    (m * vec4f(c.p0, 0.0, 1.0)).xy,
    (m * vec4f(c.p1, 0.0, 1.0)).xy,
    (m * vec4f(c.p2, 0.0, 1.0)).xy,
    (m * vec4f(c.p3, 0.0, 1.0)).xy
  );
}

struct Extrema1D { count: u32, t: vec2f }
struct Extrema2D { count: u32, t: vec4f }

fn find_unit_quad_roots(a: f32, b: f32, c: f32) -> Extrema1D {
  var out = Extrema1D(0u, vec2f(0.0));

  if (a == 0.0) {
    if (b != 0.0) {
      let t = -c / b;
      if (t > 0.0 && t < 1.0) {
        out.t[0] = t;
        out.count = 1u;
      }
    }

    return out;
  }

  let dr_sq = b * b - 4.0 * a * c;
  if (dr_sq < 0.0) { return out; }

  let r = sqrt(dr_sq);
  let q = select(-(b + r) * 0.5, -(b - r) * 0.5, b < 0.0);

  if (a != 0.0) {
    let t1 = q / a;
    if (t1 > 0.0 && t1 < 1.0) {
      out.t[out.count] = t1;
      out.count += 1u;
    }
  }

  if (q != 0.0) {
    let t2 = c / q;
    if (t2 > 0.0 && t2 < 1.0) {
      out.t[out.count] = t2;
      out.count += 1u;
    }
  }

  if (out.count == 2u) {
    if (out.t.x > out.t.y) { out.t = out.t.yx; }
    else if (out.t.x == out.t.y) { out.count = 1u; }
  }

  return out;
}

fn cubic_extrema_1d(a: f32, b: f32, c: f32, d: f32) -> Extrema1D {
  return find_unit_quad_roots(
    d - a + 3.0 * (b - c),
    2.0 * (a - 2.0 * b + c),
    b - a,
  );
}

fn cubic2_find_extrema(c: Cubic2) -> Extrema2D {
  var out = Extrema2D(0u, vec4f(0.0));

  let x_extrema = cubic_extrema_1d(c.p0.x, c.p1.x, c.p2.x, c.p3.x);
  for (var i = 0u; i < x_extrema.count; i++) {
    out.t[out.count] = x_extrema.t[i];
    out.count += 1u;
  }

  let y_extrema = cubic_extrema_1d(c.p0.y, c.p1.y, c.p2.y, c.p3.y);
  for (var i = 0u; i < y_extrema.count; i++) {
    out.t[out.count] = y_extrema.t[i];
    out.count += 1u;
  }

  if (out.count > 1u) {
    for (var i = 0u; i < out.count - 1u; i++) {
      for (var j = 0u; j < out.count - i - 1u; j++) {
        if (out.t[j] > out.t[j + 1u]) {
          let temp = out.t[j];
          out.t[j] = out.t[j + 1u];
          out.t[j + 1u] = temp;
        }
      }
    }
  }

  return out;
}
