struct Uniforms {
  tolerance: f32,
  max_quadratics: u32,
  test_array: array<mat4x4f, 4>,
  _pad1: u32,
  _pad2: u32,
  transform: mat4x4f,
}

struct Cubic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
  p3: vec2f,
};

struct Quadratic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
};

@group(0) @binding(0) var<uniform> u: Uniforms;
@group(0) @binding(1) var<storage, read> in_cubics: array<Cubic2>;
@group(0) @binding(2) var<storage, read_write> out_quadratics: array<Quadratic2>;
@group(0) @binding(3) var<storage, read_write> out_counter: atomic<u32>;
@group(0) @binding(4) var<uniform> asdf: f32;
@group(0) @binding(5) var<uniform> asdf2: array<mat4x4f, 4>;

fn vec2f_cross(a: vec2f, b: vec2f) -> f32 { return a.x * b.y - a.y * b.x; }

fn cubic2_eval_pos_tan(c: Cubic2, t: f32) -> vec4f {
  let mt = 1.0 - t;
  let mt2 = mt * mt;
  let t2 = t * t;

  let p = c.p0 * (mt2 * mt) + c.p1 * (3.0 * mt2 * t) + c.p2 * (3.0 * mt * t2) + c.p3 * (t2 * t);
  let d = (c.p1 - c.p0) * (3.0 * mt2) + (c.p2 - c.p1) * (6.0 * mt * t) + (c.p3 - c.p2) * (3.0 * t2);

  return vec4f(p, d);
}

struct ChoppedCubic2 {
  left: Cubic2,
  right: Cubic2,
};

fn cubic2_chop_at(c: Cubic2, t: f32) -> ChoppedCubic2 {
  let p01 = mix(c.p0, c.p1, t);
  let p12 = mix(c.p1, c.p2, t);
  let p23 = mix(c.p2, c.p3, t);

  let p012 = mix(p01, p12, t);
  let p123 = mix(p12, p23, t);

  let p0123 = mix(p012, p123, t);

  var out: ChoppedCubic2;
  out.left = Cubic2(c.p0, p01, p012, p0123);
  out.right = Cubic2(p0123, p123, p23, c.p3);
  return out;
}

fn cubic2_chop_at_half(c: Cubic2) -> ChoppedCubic2 { return cubic2_chop_at(c, 0.5); }

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

    out.cubics[0] = chopped.left;
    out.t0[0] = 0.0;
    out.t1[0] = t1;

    out.cubics[1] = chopped.right;
    out.t0[1] = t1;
    out.t1[1] = 1.0;

    out.count = 2u;
  }
  else if (inflection_count == 2u) {
    let t1 = inflection_ts[0];
    let t2 = inflection_ts[1];
    
    let chopped1 = cubic2_chop_at(c, t1);
    out.cubics[0] = chopped1.left;
    out.t0[0] = 0.0;
    out.t1[0] = t1;

    let local_t2 = (t2 - t1) / (1.0 - t1);
    let chopped2 = cubic2_chop_at(chopped1.right, local_t2);
    out.cubics[1] = chopped2.left;
    out.t0[1] = t1;
    out.t1[1] = t2;

    out.cubics[2] = chopped2.right;
    out.t0[2] = t2;
    out.t1[2] = 1.0;

    out.count = 3u;
  }

  return out;
}

struct StackItem {
  cubic: Cubic2,
  t0: f32,
  t1: f32,
};

@compute @workgroup_size(64)
fn main(@builtin(global_invocation_id) id: vec3u) {
  let index = id.x;
  if (index >= arrayLength(&in_cubics)) { return; }

  var initial_cubic = in_cubics[index];
  initial_cubic.p0 = (u.transform * vec4f(initial_cubic.p0, 0.0, 1.0)).xy;
  initial_cubic.p1 = (u.transform * vec4f(initial_cubic.p1, 0.0, 1.0)).xy;
  initial_cubic.p2 = (u.transform * vec4f(initial_cubic.p2, 0.0, 1.0)).xy;
  initial_cubic.p3 = (u.transform * vec4f(initial_cubic.p3, 0.0, 1.0)).xy;


  var stack: array<StackItem, 16>;
  var stack_ptr = 0u;

  let chopped_res = cubic2_chop_at_inflections(initial_cubic);
  for (var i = chopped_res.count; i > 0u; i--) {
    let idx = i - 1u;
    stack[stack_ptr] = StackItem(chopped_res.cubics[idx], chopped_res.t0[idx], chopped_res.t1[idx]);
    stack_ptr++;
  }

  while (stack_ptr > 0u) {
    stack_ptr--;
    let item = stack[stack_ptr];
    let c = item.cubic;

    let eval0 = cubic2_eval_pos_tan(c, 0.0);
    let eval1 = cubic2_eval_pos_tan(c, 1.0);
    let tan0 = eval0.zw;
    let tan1 = eval1.zw;

    var q1: vec2f;
    let det = vec2f_cross(tan0, tan1);
    if (abs(det) < 1.0e-5) {
      q1 = mix(c.p0, c.p3, 0.5);
    }
    else {
      let d = c.p3 - c.p0;
      let t = vec2f_cross(d, tan1) / det;
      q1 = c.p0 + tan0 * t;
    }

    let quad_mid = (c.p0 + q1 * 2.0 + c.p3) * 0.25;
    let cubic_mid = cubic2_eval_pos_tan(c, 0.5).xy;

    let err = length(quad_mid - cubic_mid);
    if (err <= u.tolerance) {
      let out_idx = atomicAdd(&out_counter, 1u);
      if (out_idx < u.max_quadratics) {
        let quad: Quadratic2 = Quadratic2(c.p0, q1, c.p3);
        out_quadratics[out_idx] = quad;
      }
    }
    else {
      if (stack_ptr + 2u <= 16u) {
        let chopped = cubic2_chop_at_half(c);
        let t_mid = (item.t0 + item.t1) * 0.5;

        stack[stack_ptr] = StackItem(chopped.right, t_mid, item.t1);
        stack_ptr++;
        stack[stack_ptr] = StackItem(chopped.left, item.t0, t_mid);
        stack_ptr++;
      }
      else {
        // fallback
        let out_idx = atomicAdd(&out_counter, 1u);
        if (out_idx < u.max_quadratics) {
          let quad: Quadratic2 = Quadratic2(c.p0, q1, c.p3);
          out_quadratics[out_idx] = quad;
        }
      }
    }
  }
}