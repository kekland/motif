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

const PI = 3.141592653589;
const TWO_PI = 2.0 * PI;

// #region cubic_to_quads

struct CubicToQuadsUniforms {
  tolerance: f32,
  max_quadratics: u32,
  _pad1: u32,
  _pad2: u32,
  transform: mat4x4f,
}

@group(0) @binding(0) var<uniform> u_cubic_to_quads: CubicToQuadsUniforms;
@group(0) @binding(1) var<storage, read> in_cubics: array<Cubic2>;
@group(0) @binding(2) var<storage, read_write> out_quadratics: array<Quadratic2>;
@group(0) @binding(3) var<storage, read_write> out_counter: atomic<u32>;


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
fn cs_cubic_to_quads(@builtin(global_invocation_id) id: vec3u) {
  let index = id.x;
  if (index >= arrayLength(&in_cubics)) { return; }

  let tolerance = u_cubic_to_quads.tolerance;
  let max_quadratics = u_cubic_to_quads.max_quadratics;
  let transform = u_cubic_to_quads.transform;

  var initial_cubic = in_cubics[index];
  initial_cubic.p0 = (transform * vec4f(initial_cubic.p0, 0.0, 1.0)).xy;
  initial_cubic.p1 = (transform * vec4f(initial_cubic.p1, 0.0, 1.0)).xy;
  initial_cubic.p2 = (transform * vec4f(initial_cubic.p2, 0.0, 1.0)).xy;
  initial_cubic.p3 = (transform * vec4f(initial_cubic.p3, 0.0, 1.0)).xy;

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
    if (err <= tolerance) {
      let out_idx = atomicAdd(&out_counter, 1u);
      if (out_idx < max_quadratics) {
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
        if (out_idx < max_quadratics) {
          let quad: Quadratic2 = Quadratic2(c.p0, q1, c.p3);
          out_quadratics[out_idx] = quad;
        }
      }
    }
  }
}

// #endregion

// #region quad_binning

struct QuadBinningUniforms {
  screen_size: vec2f,
  tile_size: f32,
  max_per_tile: u32,
  tiles_width: u32,
  tiles_height: u32,
  stroke_width: f32,
};

@group(1) @binding(0) var<uniform> u_quad_binning: QuadBinningUniforms;
@group(1) @binding(1) var<storage, read> in_quadratics: array<Quadratic2>;
@group(1) @binding(2) var<storage, read> in_quad_counts: u32;
@group(1) @binding(3) var<storage, read_write> out_tile_counts: array<atomic<u32>>;
@group(1) @binding(4) var<storage, read_write> out_tile_indices: array<u32>;

@compute @workgroup_size(64)
fn cs_quad_binning(@builtin(global_invocation_id) id: vec3u) {
  let quad_id = id.x;
  if (quad_id >= in_quad_counts) { return; }

  let quad = in_quadratics[quad_id];

  let screen_size = u_quad_binning.screen_size;
  let tile_size = u_quad_binning.tile_size;
  let max_per_tile = u_quad_binning.max_per_tile;
  let tiles_width = u_quad_binning.tiles_width;
  let tiles_height = u_quad_binning.tiles_height;
  let stroke_width = u_quad_binning.stroke_width;

  var min_p = min(quad.p0, min(quad.p1, quad.p2));
  var max_p = max(quad.p0, max(quad.p1, quad.p2));
  
  min_p = min_p - vec2f(stroke_width);
  max_p = max_p + vec2f(stroke_width);

  let min_tile_x = u32(clamp(floor(min_p.x / tile_size), 0.0, f32(tiles_width - 1)));
  let max_tile_x = u32(clamp(floor(max_p.x / tile_size), 0.0, f32(tiles_width - 1)));
  let min_tile_y = u32(clamp(floor(min_p.y / tile_size), 0.0, f32(tiles_height - 1)));
  let max_tile_y = u32(clamp(floor(max_p.y / tile_size), 0.0, f32(tiles_height - 1)));

  for (var y = min_tile_y; y <= max_tile_y; y++) {
    for (var x = min_tile_x; x <= max_tile_x; x++) {
      let tile_index = y * tiles_width + x;
      let slot = atomicAdd(&out_tile_counts[tile_index], 1u);
      if (slot < max_per_tile) {
        let address = tile_index * max_per_tile + slot;
        out_tile_indices[address] = quad_id;
      }
    }
  }
}

// #endregion

// #region quad_renderer

struct QuadRendererUniforms {
  screen_size: vec2f,
  tile_size: f32,
  max_per_tile: u32,
  tiles_width: u32,
};

@group(2) @binding(0) var<uniform> u_quad_renderer: QuadRendererUniforms;
@group(2) @binding(1) var<storage, read> in_renderer_quadratics: array<Quadratic2>;
@group(2) @binding(2) var<storage, read> in_tile_counts: array<u32>;
@group(2) @binding(3) var<storage, read> in_tile_indices: array<u32>;


struct VertexOutput {
  @builtin(position) position: vec4f,
};

@vertex
fn vs_quad_renderer(@builtin(vertex_index) index: u32) -> VertexOutput {
  let pos = array<vec2f, 3>(
    vec2f(-1.0, -1.0),
    vec2f(3.0, -1.0),
    vec2f(-1.0, 3.0),
  );

  var output: VertexOutput;
  output.position = vec4f(pos[index], 0.0, 1.0);
  return output;
}


fn bezier_pt(t: f32, p0: vec2f, p1: vec2f, p2: vec2f) -> vec2f {
  let mt = 1.0 - t;
  return mt * mt * p0 + 2.0 * mt * t * p1 + t * t * p2;
}

fn cbrt(x: f32) -> f32 {
  return sign(x) * pow(abs(x), 1.0 / 3.0);
}

struct CardanoResult {
  t: f32,
  dist_sq: f32,
}

fn solve_cardano(q: vec2f, p0: vec2f, p1: vec2f, p2: vec2f) -> CardanoResult {
  let A = p1 - p0;
  let B = p2 - 2.0 * p1 + p0;
  let C = p0 - q;

  let a = dot(B, B);
  let b = 3.0 * dot(A, B);
  let c = 2.0 * dot(A, A) + dot(C, B);
  let d = dot(A, C);

  if (abs(a) < 1.0e-6) {
    let line_dir = p2 - p0;
    let line_len_sq = dot(line_dir, line_dir);
    if (line_len_sq < 1.0e-6) {
      let dist_sq = dot(p0 - q, p0 - q);
      return CardanoResult(0.0, dist_sq);
    }
    else {
      let t = clamp(dot(q - p0, line_dir) / line_len_sq, 0.0, 1.0);
      let pt = p0 + t * line_dir;
      let dist_sq = dot(pt - q, pt - q);
      return CardanoResult(t, dist_sq);
    }
  }

  let nb = b / a;
  let nc = c / a;
  let nd = d / a;

  let p = nc - (nb * nb) / 3.0;
  let q_coeff = nd - (nb * nc) / 3.0 + (2.0 * nb * nb * nb) / 27.0;
  let disc = (q_coeff * q_coeff) / 4.0 + (p * p * p) / 27.0;

  var t_candidates = vec3f(-1.0, -1.0, -1.0);
  var t_count = 0u;

  if (disc > 0.0) {
    let root = sqrt(disc);
    let u_val = cbrt(-q_coeff / 2.0 + root);
    let v_val = cbrt(-q_coeff / 2.0 - root);
    t_candidates[0] = u_val + v_val - nb / 3.0;
    t_count = 1u;
  }
  else {
    let r = 2.0 * sqrt(-p / 3.0);
    let k = clamp(-q_coeff / (2.0 * sqrt(-p * p * p / 27.0)), -1.0, 1.0);

    let acos_k = acos(k);
    let boff = nb / 3.0;

    t_candidates[0] = r * cos(acos_k / 3.0) - boff;
    t_candidates[1] = r * cos((acos_k + TWO_PI) / 3.0) - boff;
    t_candidates[2] = r * cos((acos_k - TWO_PI) / 3.0) - boff;
    t_count = 3u;
  }

  var best_t = 0.0;
  var min_dist_sq = 1.0e20;

  for (var i = 0u; i < t_count; i++) {
    let clamped_t = clamp(t_candidates[i], 0.0, 1.0);
    let pt = bezier_pt(clamped_t, p0, p1, p2);

    let dist_sq = dot(pt - q, pt - q);
    if (dist_sq < min_dist_sq) {
      min_dist_sq = dist_sq;
      best_t = clamped_t;
    }
  }

  let d0 = dot(p0 - q, p0 - q);
  if (d0 < min_dist_sq) { min_dist_sq = d0; best_t = 0.0; }

  let d2 = dot(p2 - q, p2 - q);
  if (d2 < min_dist_sq) { min_dist_sq = d2; best_t = 1.0; }

  return CardanoResult(best_t, min_dist_sq);
}

@fragment
fn fs_quad_renderer(in: VertexOutput) -> @location(0) vec4f {
  let frag_world = in.position.xy;

  let screen_size = u_quad_renderer.screen_size;
  let tile_size = u_quad_renderer.tile_size;
  let max_per_tile = u_quad_renderer.max_per_tile;
  let tiles_width = u_quad_renderer.tiles_width;

  let tile_x = u32(frag_world.x / tile_size);
  let tile_y = u32(frag_world.y / tile_size);
  let tile_index = tile_y * tiles_width + tile_x;

  let count = min(in_tile_counts[tile_index], max_per_tile);
  if (count == 0u) { discard; }

  var min_sdf = 1.0e20;
  for (var i = 0u; i < count; i++) {
    let address = tile_index * max_per_tile + i;
    let quad_id = in_tile_indices[address];
    let quad = in_renderer_quadratics[quad_id];

    let result = solve_cardano(frag_world, quad.p0, quad.p1, quad.p2);
    let t = result.t;
    let dist = sqrt(result.dist_sq);

    let sdf = dist;
    min_sdf = min(min_sdf, sdf);
  }

  let coverage = 1.0 - smoothstep(-0.5, 0.5, min_sdf);
  if (coverage <= 0.0) { discard; }

  return vec4f(1.0, 1.0, 1.0, coverage);
}

// #endregion
