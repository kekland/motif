struct Quadratic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
};

struct Uniforms {
  screen_size: vec2f,
  tiles_size: vec2u,
  tolerance: f32,
  tile_size: f32,
  max_quadratics: u32,
  stroke_width: f32,
  transform: mat4x4f,
}

struct Quadratic2Storage {
  count: u32,
  quadratics: array<Quadratic2>,
}

@group(0) @binding(0) var<uniform> u: Uniforms;
@group(0) @binding(1) var<storage, read> in_quadratics: Quadratic2Storage;
@group(0) @binding(2) var<storage, read> in_tile_offset: array<u32>;
@group(0) @binding(3) var<storage, read_write> in_tile_counts: array<atomic<u32>>;
@group(0) @binding(4) var<storage, read_write> out_tile_indices: array<u32>;

@compute @workgroup_size(64)
fn cs_main(@builtin(global_invocation_id) id: vec3u) {
  let in_quad_counts = in_quadratics.count;

  let quad_id = id.x;
  if (quad_id >= in_quad_counts) { return; }

  let quad = in_quadratics.quadratics[quad_id];
  let tiles_size = u.tiles_size;

  var min_p = min(quad.p0, min(quad.p1, quad.p2));
  var max_p = max(quad.p0, max(quad.p1, quad.p2));
  
  min_p = min_p - vec2f(u.stroke_width);
  max_p = max_p + vec2f(u.stroke_width);

  let min_tile_x = u32(clamp(floor(min_p.x / u.tile_size), 0.0, f32(tiles_size.x - 1)));
  let max_tile_x = u32(clamp(floor(max_p.x / u.tile_size), 0.0, f32(tiles_size.x - 1)));
  let min_tile_y = u32(clamp(floor(min_p.y / u.tile_size), 0.0, f32(tiles_size.y - 1)));
  let max_tile_y = u32(clamp(floor(max_p.y / u.tile_size), 0.0, f32(tiles_size.y - 1)));

  for (var y = min_tile_y; y <= max_tile_y; y++) {
    for (var x = min_tile_x; x <= max_tile_x; x++) {
      let tile_index = y * u.tiles_size.x + x;
      let local_offset = atomicAdd(&in_tile_counts[tile_index], 1u);
      let global_offset = in_tile_offset[tile_index] + local_offset;
      out_tile_indices[global_offset] = quad_id;
    }
  }
}
