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
  tiles_height: u32,
  stroke_width: f32,
};

@group(0) @binding(0) var<uniform> u: Uniforms;
@group(0) @binding(1) var<storage, read> in_quadratics: array<Quadratic2>;
@group(0) @binding(2) var<storage, read> in_quad_counts: u32;
@group(0) @binding(3) var<storage, read_write> out_tile_counts: array<atomic<u32>>;
@group(0) @binding(4) var<storage, read_write> out_tile_indices: array<u32>;

@compute @workgroup_size(64)
fn main(@builtin(global_invocation_id) id: vec3u) {
  let quad_id = id.x;
  if (quad_id >= in_quad_counts) { return; }

  let quad = in_quadratics[quad_id];

  var min_p = min(quad.p0, min(quad.p1, quad.p2));
  var max_p = max(quad.p0, max(quad.p1, quad.p2));
  
  min_p = min_p - vec2f(u.stroke_width);
  max_p = max_p + vec2f(u.stroke_width);

  let min_tile_x = u32(clamp(floor(min_p.x / u.tile_size), 0.0, f32(u.tiles_width - 1)));
  let max_tile_x = u32(clamp(floor(max_p.x / u.tile_size), 0.0, f32(u.tiles_width - 1)));
  let min_tile_y = u32(clamp(floor(min_p.y / u.tile_size), 0.0, f32(u.tiles_height - 1)));
  let max_tile_y = u32(clamp(floor(max_p.y / u.tile_size), 0.0, f32(u.tiles_height - 1)));

  for (var y = min_tile_y; y <= max_tile_y; y++) {
    for (var x = min_tile_x; x <= max_tile_x; x++) {
      let tile_index = y * u.tiles_width + x;
      let slot = atomicAdd(&out_tile_counts[tile_index], 1u);
      if (slot < u.max_per_tile) {
        let address = tile_index * u.max_per_tile + slot;
        out_tile_indices[address] = quad_id;
      }
    }
  }
}