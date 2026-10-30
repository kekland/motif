#define BINDINGS_DEFINED

#import "shared/structs.wgsl"
#import "shared/render_geometry.wgsl"
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

@group(2) @binding(0) var<storage, read> count: array<u32>;
@group(2) @binding(2) var<storage, read_write> render_geometry: array<RenderGeometry>;

var<private> cell: u32;
var<private> decoration_offset: u32;
var<private> render_geometry_offset: u32;
var<private> render_geometry_end: u32;
var<private> render_geometry_count: u32;
var<private> idx: u32;

fn emit(geom: RenderGeometry) {
  if (idx < render_geometry_end) {
    render_geometry[idx] = geom;
  }
  idx++;
}

@compute @workgroup_size(64)
fn main(@builtin(global_invocation_id) global_id: vec3u) {
  let draw_count = storage_offsets.topology_draw_count;
  if (global_id.x >= draw_count) { return; }
  render_geometry_offset = count[global_id.x];
  render_geometry_end = count[global_id.x + 1];
  render_geometry_count = render_geometry_end - render_geometry_offset;
  idx = render_geometry_offset;

  let draw_entry = read_draw_entry(global_id.x);
  cell = draw_entry.cell;
  decoration_offset = draw_entry.decoration_offset;

  let cell_index = cell >> 2;
  let kind = draw_entry.kind;

  switch (kind) {
    case DRAW_ENTRY_KIND_VERTEX: { generate_vertex(cell_index); }
    case DRAW_ENTRY_KIND_EDGE: { generate_edge(cell_index); }
    case DRAW_ENTRY_KIND_FACE_FAN: { generate_face_fan(cell_index); }
    case DRAW_ENTRY_KIND_FACE_COVER: { generate_face_cover(cell_index); }
    default: { }
  }

  // pad remaining render geometry slots
  for (var i = idx; i < render_geometry_end; i++) {
    render_geometry[i] = RENDER_GEOMETRY_EMPTY;
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Vertex
// ---------------------------------------------------------------------------------------------------------------------

fn generate_arc(position: vec2f, radius: f32, a0: f32, span: f32, count: u32, decoration_index: u32, frame_index: u32) {
  var n = count;
  if (n == NONE) {
    n = count_arc_segments(span, radius, world.tolerance);
  }

  for (var i = 0u; i < n; i++) {
    let t0 = a0 + span * f32(i) / f32(n);
    let t1 = a0 + span * f32(i + 1u) / f32(n);
    emit(render_geometry_create_tri(
      position,
      position + radius * vec2f(cos(t0), sin(t0)),
      position + radius * vec2f(cos(t1), sin(t1)),
      cell,
      decoration_index,
      frame_index,
    ));
  }
}

fn generate_vertex(vertex_index: u32) {
  let position = read_vertex_position_world(vertex_index);
  let frame_index = read_vertex_topology(vertex_index).parent;

  var incident: array<VertexIncident, MAX_VERTEX_VALENCE>;
  let valence = get_vertex_incidence(vertex_index, position, &incident);

  if (valence == 0u) { return; }
  let first_edge_style = read_edge_style(incident[0].edge_index);

  if (valence == 1u) {
    let inc = incident[0];
    generate_arc(position, first_edge_style.width / 2.0, inc.angle + PI * 0.5, PI, render_geometry_count, first_edge_style.decoration_start + decoration_offset, frame_index);
    return;
  }

  var join: array<VertexIncident, 2>;
  let join_gap = get_vertex_join(valence, &incident, &join);
  if (join_gap > 0.0) {
    generate_arc(position, first_edge_style.width / 2.0, join[0].angle + PI * 0.5, join_gap - PI, render_geometry_count, first_edge_style.decoration_start + decoration_offset, frame_index);
    return;
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Edge
// ---------------------------------------------------------------------------------------------------------------------

fn generate_edge(edge_index: u32) {
  let world_cubic = read_edge_cubic_world(edge_index);
  let frame_index = read_edge_topology(edge_index).parent;
  let count = render_geometry_count;

  let style = read_edge_style(edge_index);
  let half_width = style.width / 2.0;
  let decoration_index = style.decoration_start + decoration_offset;

  for (var i = 0u; i < count; i++) {
    let t0 = f32(i) / f32(count);
    let t1 = f32(i + 1u) / f32(count);
    let pos_tan0 = cubic2_pos_tan(world_cubic, t0);
    let pos_tan1 = cubic2_pos_tan(world_cubic, t1);
  
    let pos0 = pos_tan0[0];
    let pos1 = pos_tan1[0];
    let tan0 = vec2_safe_tangent(pos_tan0[1], pos1 - pos0);
    let tan1 = vec2_safe_tangent(pos_tan1[1], pos1 - pos0);

    let n0 = normalize(vec2_orthogonal(tan0));
    let n1 = normalize(vec2_orthogonal(tan1));

    emit(render_geometry_create_quad(
      pos0 - n0 * half_width,
      pos0 + n0 * half_width,
      pos1 - n1 * half_width,
      pos1 + n1 * half_width,
      cell,
      decoration_index,
      frame_index
    ));
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Face
// ---------------------------------------------------------------------------------------------------------------------

fn generate_face_fan(face_index: u32) {
  let face_topology = read_face_topology(face_index);
  if (face_topology.boundary_count == 0u) { return; }

  let pivot = read_face_boundary_cubic_world(face_topology.boundary_start).p0;
  for (var i = 0u; i < face_topology.boundary_count; i++) {
    let c = read_face_boundary_cubic_world(face_topology.boundary_start + i);
    let n = get_cubic_segment_count(c);
    var prev = c.p0;
    for (var k = 1u; k <= n; k++) {
      let p = cubic2_pos(c, f32(k) / f32(n));
      emit(render_geometry_create_tri(pivot, prev, p, cell, NONE, 0u));
      prev = p;
    }
  }
}

fn generate_face_cover(face_index: u32) {
  let face_topology = read_face_topology(face_index);
  if (face_topology.boundary_count == 0u) { return; }

  let frame_index = face_topology.parent;

  let style = read_face_style(face_index);
  let decoration_index = style.decoration_start + decoration_offset;

  var lo = vec2f(1e30);
  var hi = vec2f(-1e30);

  for (var i = 0u; i < face_topology.boundary_count; i++) {
    let c = read_face_boundary_cubic_world(face_topology.boundary_start + i);
    let bbox = cubic2_bbox(c);
    lo = min(lo, bbox[0]);
    hi = max(hi, bbox[1]);
  }

  emit(render_geometry_create_quad(
    lo,
    vec2f(hi.x, lo.y),
    vec2f(lo.x, hi.y),
    hi,
    cell,
    decoration_index,
    frame_index,
  ));
}