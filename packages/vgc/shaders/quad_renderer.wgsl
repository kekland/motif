struct Quadratic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
};

struct Uniforms {
  screen_size: vec2f,
  tile_size: f32,
  max_per_tile: u32,
  tiles_width: u32,
};

@group(0) @binding(0) var<uniform> u: Uniforms;
@group(0) @binding(1) var<storage, read> in_quadratics: array<Quadratic2>;
@group(0) @binding(2) var<storage, read> in_tile_counts: array<u32>;
@group(0) @binding(3) var<storage, read> in_tile_indices: array<u32>;

const PI = 3.141592653589;
const TWO_PI = 2.0 * PI;

/*
  Vertex shader
*/

struct VertexOutput {
  @builtin(position) position: vec4f,
};

@vertex
fn vs_main(@builtin(vertex_index) index: u32) -> VertexOutput {
  let pos = array<vec2f, 3>(
    vec2f(-1.0, -1.0),
    vec2f(3.0, -1.0),
    vec2f(-1.0, 3.0),
  );

  var output: VertexOutput;
  output.position = vec4f(pos[index], 0.0, 1.0);
  return output;
}

/*
  Fragment shader
*/

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
fn fs_main(in: VertexOutput) -> @location(0) vec4f {
  let frag_world = in.position.xy;

  let tile_x = u32(frag_world.x / u.tile_size);
  let tile_y = u32(frag_world.y / u.tile_size);
  let tile_index = tile_y * u.tiles_width + tile_x;

  let count = min(in_tile_counts[tile_index], u.max_per_tile);
  if (count == 0u) { discard; }

  var min_sdf = 1.0e20;
  for (var i = 0u; i < count; i++) {
    let address = tile_index * u.max_per_tile + i;
    let quad_id = in_tile_indices[address];
    let quad = in_quadratics[quad_id];

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
