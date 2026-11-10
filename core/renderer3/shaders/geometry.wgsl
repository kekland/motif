#define BINDINGS_DEFINED

#import "storage/uniforms.wgsl"
#import "storage/topology.wgsl"
#import "storage/geometry.wgsl"
#import "storage/style.wgsl"
#import "storage/draw.wgsl"
#import "storage/render_geometry.wgsl"

#import "utils/vertex_incidence.wgsl"
#import "utils/world_utils.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;
@group(0) @binding(2) var<uniform> storage_counts: StorageCounts;
@group(0) @binding(3) var<uniform> storage_capacity: StorageCapacity;

@group(1) @binding(0) var<storage, read> topology: array<u32>;
@group(1) @binding(1) var<storage, read> geometry: array<u32>;
@group(1) @binding(2) var<storage, read> style: array<u32>;
@group(1) @binding(4) var<storage, read> draw: array<u32>;

@group(2) @binding(0) var<storage, read_write> segment_offset: array<u32>;
@group(2) @binding(1) var<storage, read_write> segments: array<vec4f>;
@group(2) @binding(2) var<storage, read_write> render_geometry_offset: array<u32>;
@group(2) @binding(3) var<storage, read_write> render_geometry: array<RenderGeometry>;

var<private> cell: u32;
var<private> cell_index: u32;
var<private> draw_kind: u32;
var<private> decoration_span: vec2u;

fn prepare_draw_entry(invocation_index: u32) -> u32 {
  if (invocation_index >= storage_counts.draw) { return 0u; }

  let entry_index = read_draw_order(invocation_index);
  let entry = read_draw_entry(entry_index);
  
  if (entry.kind > DRAW_ENTRY_KIND_FACE_COVER) { return 0u; }

  cell = entry.cell;
  cell_index = cell >> 2;
  draw_kind = entry.kind;
  decoration_span = entry.decoration_span;
  return 1u;
}

@compute @workgroup_size(64)
fn count(@builtin(global_invocation_id) global_id: vec3u) {
  if (prepare_draw_entry(global_id.x) == 0) { return; }

  var out_count = 0u;
  switch (draw_kind) {
    case DRAW_ENTRY_KIND_VERTEX: { out_count = count_vertex(); }
    case DRAW_ENTRY_KIND_EDGE: { out_count = count_edge(); }
    case DRAW_ENTRY_KIND_FACE_FAN: { out_count = count_face_fan(); }
    case DRAW_ENTRY_KIND_FACE_COVER: { out_count = count_face_cover(); }
    default: { }
  }

  render_geometry_offset[global_id.x] = out_count;
}

#define PREFIX_SUM_BUFFER_NAME render_geometry_offset
#define PREFIX_SUM_COUNT storage_counts.draw
#define PREFIX_SUM_FN_NAME scan
#import "utils/prefix_sum.wgsl"

var<private> out_geometry_offset: u32;
var<private> out_geometry_end: u32;
var<private> out_geometry_count: u32;
var<private> out_geometry_idx: u32;

fn emit(geometry: RenderGeometry) {
  if (out_geometry_idx < out_geometry_end) {
    render_geometry[out_geometry_idx] = geometry;
    out_geometry_idx++;
  }
}

@compute @workgroup_size(64)
fn generate(@builtin(global_invocation_id) global_id: vec3u) {
  if (prepare_draw_entry(global_id.x) == 0) { return; }

  out_geometry_offset = render_geometry_offset[global_id.x];
  out_geometry_end = render_geometry_offset[global_id.x + 1u];
  out_geometry_count = out_geometry_end - out_geometry_offset;
  out_geometry_idx = out_geometry_offset;

  if (out_geometry_count == 0u) { return; }

  switch (draw_kind) {
    case DRAW_ENTRY_KIND_VERTEX: { generate_vertex(); }
    case DRAW_ENTRY_KIND_EDGE: { generate_edge(); }
    case DRAW_ENTRY_KIND_FACE_FAN: { generate_face_fan(); }
    case DRAW_ENTRY_KIND_FACE_COVER: { generate_face_cover(); }
    default: { }
  }

  for (var i = out_geometry_idx; i < out_geometry_end; i++) {
    render_geometry[i] = RENDER_GEOMETRY_NONE;
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Vertex
// ---------------------------------------------------------------------------------------------------------------------

fn count_vertex() -> u32 {
  let position = read_vertex_position_world(cell_index);
  var incident: array<VertexIncident, MAX_VERTEX_VALENCE>;
  let valence = get_vertex_incidence(cell_index, position, &incident);

  if (valence == 1u) {
    return count_arc_segments(PI, 1.0, world.tolerance, MAX_ARC_SEGMENTS);
  }

  var join: array<VertexIncident, 2>;
  let join_gap = get_vertex_join(valence, &incident, &join);
  if (join_gap > 0.0) {
    return count_arc_segments(join_gap - PI, 1.0, world.tolerance, MAX_ARC_SEGMENTS);
  }

  return 0u;
}

fn generate_arc(position: vec2f, r0: f32, r1: f32, a0: f32, span: f32, count: u32, decoration_span: vec2u, parent_index: u32) {
  var n = count;
  if (n == NONE) {
    n = count_arc_segments(span, (r0 + r1) / 2.0, world.tolerance, MAX_ARC_SEGMENTS);
  }

  for (var i = 0u; i < n; i++) {
    let t0 = a0 + span * f32(i) / f32(n);
    let t1 = a0 + span * f32(i + 1u) / f32(n);
    emit(render_geometry_create_tri(
      position,
      position + r0 * vec2f(cos(t0), sin(t0)),
      position + r1 * vec2f(cos(t1), sin(t1)),
      vec4f(0.0),
      cell,
      parent_index,
      decoration_span,
    ));
  }
}

fn generate_vertex() {
  let position = read_vertex_position_world(cell_index);
  let parent_index = read_vertex_topology(cell_index).parent;

  var incident: array<VertexIncident, MAX_VERTEX_VALENCE>;
  let valence = get_vertex_incidence(cell_index, position, &incident);
  if (valence == 0u) { return; }
  else if (valence == 1u) {
    let inc = incident[0];
    let edge_style = read_edge_style(inc.edge_index);
    let radius = edge_style.width / 2.0;
    generate_arc(position, radius, radius, inc.angle + PI * 0.5, PI, out_geometry_count, decoration_span, parent_index);
  }
  
  var join: array<VertexIncident, 2>;
  let join_gap = get_vertex_join(valence, &incident, &join);
  if (join_gap > 0.0) {
    let r0 = read_edge_style(join[0].edge_index).width / 2.0;
    let r1 = read_edge_style(join[1].edge_index).width / 2.0;
    generate_arc(position, r0, r1, join[0].angle + PI * 0.5, join_gap - PI, out_geometry_count, decoration_span, parent_index);
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Edge
// ---------------------------------------------------------------------------------------------------------------------

fn count_edge() -> u32 {
  let count = segment_offset[cell_index + 1u] - segment_offset[cell_index];
  return count;
}

fn generate_edge() {
  let offset = segment_offset[cell_index];
  let vertex_count = segment_offset[cell_index + 1u] - offset;

  let style = read_edge_style(cell_index);
  let half_width = style.width / 2.0;
  let parent_index = read_edge_topology(cell_index).parent;
  let inv_transform = read_frame_inverse_transform(parent_index);

  var local_bbox = BBOX_INV_INF;
  for (var i = 0u; i < vertex_count; i++) {
    let v_world = segments[offset + i].xy;
    let v_local = (inv_transform * vec4f(v_world, 0.0, 1.0)).xy;
    local_bbox = bbox_hull_point(local_bbox, v_local);
  }

  let rx = length(vec2_transform(inv_transform, vec2f(half_width, 0.0)));
  let ry = length(vec2_transform(inv_transform, vec2f(0.0, half_width)));
  local_bbox = bbox_inflate(local_bbox, rx, ry);

  var last = segments[offset];
  for (var i = 1u; i < vertex_count; i++) {
    let p0 = last.xy;
    let tan0 = last.zw;
    
    let current = segments[offset + i];
    let p1 = current.xy;
    let tan1 = current.zw;

    let n0 = normalize(vec2_orthogonal(tan0));
    let n1 = normalize(vec2_orthogonal(tan1));

    emit(render_geometry_create_quad(
      p0 - n0 * half_width,
      p0 + n0 * half_width,
      p1 - n1 * half_width,
      p1 + n1 * half_width,
      local_bbox,
      cell,
      parent_index,
      decoration_span,
    ));

    last = current;
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Face fan
// ---------------------------------------------------------------------------------------------------------------------

fn count_face_fan() -> u32 {
  let face_topology = read_face_topology(cell_index);
  var total = 0u;
  for (var i = 0u; i < face_topology.boundary_span.y; i++) {
    let entry = read_face_boundary_entry(face_topology.boundary_span.x + i);
    let edge_index = entry.edge;
    let segment_count = segment_offset[edge_index + 1u] - segment_offset[edge_index];
    total += segment_count;
  }

  return total;
}

fn generate_face_fan() {
  let face_topology = read_face_topology(cell_index);
  if (face_topology.boundary_span.y == 0u) { return; }

  let parent_index = face_topology.parent;

  let pivot_edge = read_face_boundary_entry(face_topology.boundary_span.x).edge;
  let pivot = segments[segment_offset[pivot_edge]].xy;

  for (var i = 0u; i < face_topology.boundary_span.y; i++) {
    let entry = read_face_boundary_entry(face_topology.boundary_span.x + i);
    let offset = segment_offset[entry.edge];
    let vertex_count = segment_offset[entry.edge + 1u] - offset;

    var prev = segments[offset].xy;
    for (var j = 1u; j < vertex_count; j++) {
      let current = segments[offset + j].xy;
      var tri = render_geometry_create_tri(pivot, prev, current, vec4f(0), cell, NONE, vec2u(0));
      tri.flags = RENDER_GEOMETRY_FLAG_STENCIL;
      emit(tri);
      prev = current;
    }
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Face cover
// ---------------------------------------------------------------------------------------------------------------------

fn count_face_cover() -> u32 {
  let face_topology = read_face_topology(cell_index);
  if (face_topology.boundary_span.y == 0u) { return 0u; }
  return 1u;
}

fn generate_face_cover() {
  let face_topology = read_face_topology(cell_index);
  if (face_topology.boundary_span.y == 0u) { return; }

  let parent_index = face_topology.parent;
  let inv_transform = read_frame_inverse_transform(parent_index);

  var world_bbox = BBOX_INV_INF;
  var local_bbox = BBOX_INV_INF;

  for (var i = 0u; i < face_topology.boundary_span.y; i++) {
    let entry = read_face_boundary_entry(face_topology.boundary_span.x + i);
    for (var j = segment_offset[entry.edge]; j < segment_offset[entry.edge + 1u]; j++) {
      let v_world = segments[j].xy;
      let v_local = vec2_transform(inv_transform, v_world);
      world_bbox = bbox_hull_point(world_bbox, v_world);
      local_bbox = bbox_hull_point(local_bbox, v_local);
    }
  }

  emit(render_geometry_create_quad(
    world_bbox.xy, world_bbox.zy, world_bbox.xw, world_bbox.zw,
    local_bbox,
    cell, parent_index, decoration_span
  ));
}
