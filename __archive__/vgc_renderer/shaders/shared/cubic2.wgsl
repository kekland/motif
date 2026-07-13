// A cubic bezier curve.
struct Cubic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
  p3: vec2f,
}

fn cubic2_transform(c: Cubic2, m: mat4x4f) -> Cubic2 {
  return Cubic2(
    (m * vec4f(c.p0, 0.0, 1.0)).xy,
    (m * vec4f(c.p1, 0.0, 1.0)).xy,
    (m * vec4f(c.p2, 0.0, 1.0)).xy,
    (m * vec4f(c.p3, 0.0, 1.0)).xy
  );
}

// #region Evaluation

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

// Evaluates the position and the tangent of the cubic bezier at parameter [t] as (pos.x, pos.y, tan.x, tan.y).
fn cubic2_pos_tan(c: Cubic2, t: f32) -> vec4f {
  let mt = 1.0 - t;
  let mt2 = mt * mt;
  let t2 = t * t;

  let pos = c.p0 * (mt2 * mt) + c.p1 * (3.0 * mt2 * t) + c.p2 * (3.0 * mt * t2) + c.p3 * (t2 * t);
  let tan = (c.p1 - c.p0) * (3.0 * mt2) + (c.p2 - c.p1) * (6.0 * mt * t) + (c.p3 - c.p2) * (3.0 * t2);

  return vec4f(pos, tan);
}

// Evalutes the signed curvature of the cubic at parameter [t].
fn cubic2_signed_curvature(c: Cubic2, t: f32) -> f32 {
  let tan = cubic2_tan(c, t);
  let acc = cubic2_acc(c, t);
  let cross = tan.x * acc.y - tan.y * acc.x;
  let speed = length(tan);
  let speed3 = speed * speed * speed;
  if (speed3 < 1.0e-9) { return 0.0; }
  return cross / speed3;
}

// Evaluates the center of curvature of the cubic at parameter [t].
fn cubic2_curvature_center(c: Cubic2, t: f32) -> vec2f {
  let pos_tan = cubic2_pos_tan(c, t);
  let pos = pos_tan.xy;
  let tan = normalize(pos_tan.zw);
  let normal = vec2f(-tan.y, tan.x);

  let k = cubic2_signed_curvature(c, t);
  if (abs(k) < 1.0e-5) { return pos + normal * (1.0e6 * sign(k)); }

  let radius = 1.0 / k;
  return pos + normal * radius;
}

// #endregion

// #region Key metrics

struct Cubic2InflectionsResult {
  count: u32,
  t: vec2f,
}

// Returns the number of inflection points and their parameter values.
fn cubic2_inflections(c: Cubic2) -> Cubic2InflectionsResult {
  const T_EPS = 1.0e-4;

  let A = c.p1 - c.p0;
  let B = c.p2 - 2.0 * c.p1 + c.p0;
  let C = c.p3 - 3.0 * c.p2 + 3.0 * c.p1 - c.p0;

  let a = B.x * C.y - B.y * C.x;
  let b = A.x * C.y - A.y * C.x;
  let c_ = A.x * B.y - A.y * B.x;

  var root_count = 0u;
  var roots = vec2f(-1.0);

  if (abs(a) < 1.0e-5) {
    if (abs(b) > 1.0e-5) {
      let t = -c_ / b;
      if (t > T_EPS && t < 1.0 - T_EPS) {
        roots[0] = t;
        root_count = 1u;
      }
    }
  }
  else {
    let disc = b * b - 4.0 * a * c_;
    if (disc >= 0.0) {
      let sqrt_disc = sqrt(disc);
      let t1 = (-b + sqrt_disc) / (2.0 * a);
      let t2 = (-b - sqrt_disc) / (2.0 * a);
      
      if (t1 > T_EPS && t1 < 1.0 - T_EPS) {
        roots[root_count] = t1;
        root_count++;
      }
      if (disc > 1.0e-6 && t2 > T_EPS && t2 < 1.0 - T_EPS) {
        roots[root_count] = t2;
        root_count++;
      }
    }
  }

  if (root_count == 2u && roots[0] > roots[1]) {
    let temp = roots[0];
    roots[0] = roots[1];
    roots[1] = temp;
  }

  return Cubic2InflectionsResult(root_count, roots);
}


struct Extrema1D { count: u32, t: vec2f }
struct Extrema2D { count: u32, t: vec4f }

fn _find_unit_quad_roots(a: f32, b: f32, c: f32) -> Extrema1D {
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


fn _cubic_extrema_1d(a: f32, b: f32, c: f32, d: f32) -> Extrema1D {
  return _find_unit_quad_roots(
    d - a + 3.0 * (b - c),
    2.0 * (a - 2.0 * b + c),
    b - a,
  );
}


// Returns the number of extrema in x and y and their parameter values.
fn cubic2_extrema(c: Cubic2) -> Extrema2D {
  var out = Extrema2D(0u, vec4f(0.0));

  let x_extrema = _cubic_extrema_1d(c.p0.x, c.p1.x, c.p2.x, c.p3.x);
  for (var i = 0u; i < x_extrema.count; i++) {
    out.t[out.count] = x_extrema.t[i];
    out.count++;
  }

  let y_extrema = _cubic_extrema_1d(c.p0.y, c.p1.y, c.p2.y, c.p3.y);
  for (var i = 0u; i < y_extrema.count; i++) {
    out.t[out.count] = y_extrema.t[i];
    out.count++;
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

struct Cubic2KeyPointsResult {
  t: array<f32, 6>,
  count: u32,
}

// Returns the sorted parameter values of the inflection points and extrema of the cubic.
fn cubic2_key_points(c: Cubic2) -> Cubic2KeyPointsResult {
  var out: Cubic2KeyPointsResult;
  out.count = 0u;

  let v0 = c.p1 - c.p0;
  let v1 = c.p2 - c.p1;
  let v2 = c.p3 - c.p2;

  let A = v2 - 2.0 * v1 + v0;
  let B = 2.0 * (v1 - v0);
  let C = v0;

  let x_extrema = _find_unit_quad_roots(A.x, B.x, C.x);
  for (var i = 0u; i < x_extrema.count; i++) {
    out.t[out.count] = x_extrema.t[i];
    out.count++;
  }

  let y_extrema = _find_unit_quad_roots(A.y, B.y, C.y);
  for (var i = 0u; i < y_extrema.count; i++) {
    out.t[out.count] = y_extrema.t[i];
    out.count++;
  }

  let inf_a = B.x * A.y - B.y * A.x;
  let inf_b = 2.0 * (C.x * A.y - C.y * A.x);
  let inf_c = C.x * B.y - C.y * B.x;

  let inflections = _find_unit_quad_roots(inf_a, inf_b, inf_c);
  for (var i = 0u; i < inflections.count; i++) {
    out.t[out.count] = inflections.t[i];
    out.count++;
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

// #endregion

// #region Geometry

// Returns the rough bounding box of the cubic bezier.
fn cubic2_bbox(c: Cubic2) -> vec4f {
  let min_pt = min(c.p0, min(c.p1, min(c.p2, c.p3)));
  let max_pt = max(c.p0, max(c.p1, max(c.p2, c.p3)));
  return vec4f(min_pt, max_pt);
}

// Returns the tight bounding box of the cubic bezier.
fn cubic2_bbox_tight(c: Cubic2) -> vec4f {
  var min_pt = min(c.p0, c.p3);
  var max_pt = max(c.p0, c.p3);

  let extrema = cubic2_extrema(c);
  for (var i = 0u; i < extrema.count; i++) {
    let t = extrema.t[i];
    let pt = cubic2_pos(c, t);
    min_pt = min(min_pt, pt);
    max_pt = max(max_pt, pt);
  }

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

// Returns the approximate arc length of the cubic bezier.
fn cubic2_arc_length_approximate(c: Cubic2) -> f32 {
  return _cubic2_arc_len_quadrature(c);
}

// Returns a more refined arc length estimation of the cubic bezier.
fn cubic2_arc_length(c: Cubic2) -> f32 {
  let key_points = cubic2_key_points(c);

  var total = 0.0;
  var t0 = 0.0;
  for (var i = 0u; i < key_points.count; i++) {
    let t1 = key_points.t[i];
    if (t1 - t0 > 1.0e-4) {
      let piece = cubic2_piece_at(c, t0, t1);
      total += cubic2_arc_length_approximate(piece);
      t0 = t1;
    }
  }

  if (1.0 - t0 > 1.0e-4) {
    let piece = cubic2_piece_at(c, t0, 1.0);
    total += cubic2_arc_length_approximate(piece);
  }

  return total;
}

// Returns the parameter t at arc length.
fn cubic2_distance_to_t(c: Cubic2, dist: f32) -> f32 {
  var t_min = 0.0; var t_max = 1.0; var local_t = 0.5;

  for (var iter = 0u; iter < 12u; iter++) {
    local_t = (t_min + t_max) * 0.5;
    let sub_curve = cubic2_piece_at(c, 0.0, local_t);
    let dist_at_t = cubic2_arc_length(sub_curve);

    if (dist_at_t < dist) { t_min = local_t; }
    else { t_max = local_t; }
  }

  return local_t;
}

// Returns the arc distance at parameter t.
fn cubic2_distance_at_t(c: Cubic2, t: f32) -> f32 {
  let sub = cubic2_piece_at(c, 0.0, t);
  return cubic2_arc_length(sub);
}

// Returns the number of line segments needed to approximate the cubic bezier within the given tolerance.
fn cubic2_wang(c: Cubic2, tolerance: f32) -> f32 {
  let v1 = c.p2 - 2.0 * c.p1 + c.p0;
  let v2 = c.p3 - 2.0 * c.p2 + c.p1;
  let m = max(dot(v1, v1), dot(v2, v2));
  if (m < 1.0e-6) { return 1.0; }
  return sqrt(sqrt(m) * 3.0 / (4.0 * tolerance));
}

// #endregion

// #region Subdivision

// Splits the cubic bezier at [t].
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

// Splits the cubic bezier at [t=0.5].
fn cubic2_chop_at_half(c: Cubic2) -> array<Cubic2, 2> {
  return cubic2_chop_at(c, 0.5);
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


struct Cubic2ChopAtInflectionsResult {
  cubics: array<Cubic2, 3>,
  t0: array<f32, 3>,
  t1: array<f32, 3>,
  count: u32,
}


// Splits the cubic bezier at its inflection points.
fn cubic2_chop_at_inflections(c: Cubic2) -> Cubic2ChopAtInflectionsResult {
  var out: Cubic2ChopAtInflectionsResult;
  let inflections = cubic2_inflections(c);

  if (inflections.count == 0u) {
    out.cubics[0] = c;
    out.t0[0] = 0.0;
    out.t1[0] = 1.0;
    out.count = 1u;
  }
  else if (inflections.count == 1u) {
    let t1 = inflections.t[0];
    let pieces = cubic2_chop_at(c, t1);
  
    out.cubics[0] = pieces[0];
    out.t0[0] = 0.0;
    out.t1[0] = t1;

    out.cubics[1] = pieces[1];
    out.t0[1] = t1;
    out.t1[1] = 1.0;

    out.count = 2u;
  }
  else if (inflections.count == 2u) {
    let t1 = inflections.t[0];
    let t2 = inflections.t[1];
    
    let pieces1 = cubic2_chop_at(c, t1);
    out.cubics[0] = pieces1[0];
    out.t0[0] = 0.0;
    out.t1[0] = t1;

    let pieces2 = cubic2_chop_at(pieces1[1], (t2 - t1) / (1.0 - t1));
    out.cubics[1] = pieces2[0];
    out.t0[1] = t1;
    out.t1[1] = t2;

    out.cubics[2] = pieces2[1];
    out.t0[2] = t2;
    out.t1[2] = 1.0;

    out.count = 3u;
  }

  return out;
}

// #endregion