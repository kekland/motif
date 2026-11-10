#define BINDINGS_DEFINED

#import "storage/uniforms.wgsl"
#import "storage/topology.wgsl"
#import "storage/geometry.wgsl"
#import "storage/draw.wgsl"

#import "math/math.wgsl"
#import "utils/limits.wgsl"
#import "utils/world_utils.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;
@group(0) @binding(2) var<uniform> storage_counts: StorageCounts;
@group(0) @binding(3) var<uniform> storage_capacity: StorageCapacity;

@group(1) @binding(0) var<storage, read> topology: array<u32>;
@group(1) @binding(1) var<storage, read> geometry: array<u32>;
@group(1) @binding(4) var<storage, read> draw: array<u32>;

@group(2) @binding(0) var<storage, read_write> segment_offset: array<u32>;
@group(2) @binding(1) var<storage, read_write> segments: array<vec4f>;

var<private> edge_index: u32;

fn read_draw_edge_entry(invocation_index: u32) -> u32 {
  if (invocation_index >= storage_counts.draw_edge) { return 0u; }
  edge_index = read_draw_edge(invocation_index);
  return 1u;
}

@compute @workgroup_size(64)
fn count(@builtin(global_invocation_id) global_id: vec3u) {
  if (read_draw_edge_entry(global_id.x) != 1u) { return; }

  let cubic = read_edge_cubic_world(edge_index);
  let count = min(u32(ceil(cubic2_wang(cubic, world.tolerance))), MAX_CUBIC_SEGMENT_COUNT);
  segment_offset[edge_index] = select(0u, count + 1u, count > 0u);
}

#define PREFIX_SUM_BUFFER_NAME segment_offset
#define PREFIX_SUM_COUNT storage_counts.draw_edge
#define PREFIX_SUM_FN_NAME scan
#import "utils/prefix_sum.wgsl"

@compute @workgroup_size(64)
fn generate(@builtin(global_invocation_id) global_id: vec3u) {
  if (read_draw_edge_entry(global_id.x) != 1u) { return; }

  var offset = segment_offset[edge_index];
  let vertex_count = segment_offset[edge_index + 1u] - offset;
  if (vertex_count < 2u) { return; }

  let segment_count = vertex_count - 1u;
  let cubic = read_edge_cubic_world(edge_index);
  
  var last = cubic2_pos_tan(cubic, 0.0);
  var chord = vec2f(0.0, 0.0);
  let inv_count = 1.0 / f32(segment_count);

  for (var i = 1u; i <= segment_count; i++) {
    let t = f32(i) * inv_count;
    let current = cubic2_pos_tan(cubic, t);
    chord = current.xy - last.xy;

    segments[offset] = vec4f(last.xy, vec2_safe_tangent(last.zw, chord));
    offset++;
    last = current;
  }

  // fix final vertex tangent
  segments[offset] = vec4f(last.xy, vec2_safe_tangent(last.zw, chord));
}
