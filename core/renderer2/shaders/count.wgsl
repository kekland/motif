#define BINDINGS_DEFINED

#import "shared/structs.wgsl"
#import "shared/uniforms.wgsl"
#import "shared/constants.wgsl"
#import "shared/utils.wgsl"
#import "storage/geometry.wgsl"
#import "storage/topology.wgsl"
#import "storage/style.wgsl"
#import "geometry/cubic.wgsl"
#import "geometry/vector.wgsl"
#import "utils/vertex.wgsl"
#import "utils/edge.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;

@group(1) @binding(0) var<storage, read> geometry: array<u32>;
@group(1) @binding(1) var<storage, read> topology: array<u32>;
@group(1) @binding(2) var<storage, read> style: array<u32>;

@group(2) @binding(0) var<storage, read_write> count: array<u32>;

@compute @workgroup_size(64)
fn main(@builtin(global_invocation_id) global_id: vec3u) {
  let draw_count = storage_offsets.topology_draw_count;
  if (global_id.x >= draw_count) { return; }

  let draw_entry = read_draw_entry(global_id.x);
  let kind = draw_entry.kind;
  let cell = draw_entry.cell;
  let cell_index = cell >> 2;

  var out_count = 0u;
  switch (kind) {
    case DRAW_ENTRY_KIND_VERTEX: { out_count = count_vertex(cell_index); }
    case DRAW_ENTRY_KIND_EDGE: { out_count = count_edge(cell_index); }
    case DRAW_ENTRY_KIND_FACE_FAN: { out_count = count_face_fan(cell_index); }
    case DRAW_ENTRY_KIND_FACE_COVER: { out_count = count_face_cover(cell_index); }
    default: { }
  }

  count[global_id.x] = out_count;
}

// ---------------------------------------------------------------------------------------------------------------------
// Vertex
// ---------------------------------------------------------------------------------------------------------------------

fn count_vertex(vertex_index: u32) -> u32 {
  let position = read_vertex_position_world(vertex_index);
  var incident: array<VertexIncident, MAX_VERTEX_VALENCE>;
  let valence = get_vertex_incidence(vertex_index, position, &incident);

  if (valence == 1u) {
    return count_arc_segments(PI, 1.0, world.tolerance);
  }

  var join: array<VertexIncident, 2>;
  let join_gap = get_vertex_join(valence, &incident, &join);
  if (join_gap > 0.0) {
    return count_arc_segments(join_gap - PI, 1.0, world.tolerance);
  }

  return 0u;
}

// ---------------------------------------------------------------------------------------------------------------------
// Edge
// ---------------------------------------------------------------------------------------------------------------------

fn count_edge(edge_index: u32) -> u32 {
  let world_cubic = read_edge_cubic_world(edge_index);
  return get_cubic_segment_count(world_cubic);
}

// ---------------------------------------------------------------------------------------------------------------------
// Face
// ---------------------------------------------------------------------------------------------------------------------

fn count_face_fan(face_index: u32) -> u32 {
  let face_topology = read_face_topology(face_index);
  var total = 0u;
  for (var i = 0u; i < face_topology.boundary_count; i++) {
    let c = read_face_boundary_cubic_world(face_topology.boundary_start + i);
    total += get_cubic_segment_count(c);
  }

  return total;
}

fn count_face_cover(face_index: u32) -> u32 {
  let face_topology = read_face_topology(face_index);
  if (face_topology.boundary_count == 0u) { return 0u; }
  return 1u;
}
