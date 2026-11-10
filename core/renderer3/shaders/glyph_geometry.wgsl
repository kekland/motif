#define BINDINGS_DEFINED

#import "math/math.wgsl"
#import "storage/uniforms.wgsl"
#import "storage/geometry.wgsl"
#import "storage/glyph.wgsl"
#import "storage/draw.wgsl"
#import "storage/render_geometry.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;
@group(0) @binding(2) var<uniform> storage_counts: StorageCounts;
@group(0) @binding(3) var<uniform> storage_capacity: StorageCapacity;

@group(1) @binding(1) var<storage, read> geometry: array<u32>;
@group(1) @binding(4) var<storage, read> draw: array<u32>;
@group(1) @binding(5) var<storage, read> glyph_instance: array<GlyphInstance>;
@group(1) @binding(6) var<storage, read> glyph_geometry: array<u32>;

@group(2) @binding(2) var<storage, read_write> render_geometry_offset: array<u32>;
@group(2) @binding(3) var<storage, read_write> render_geometry: array<RenderGeometry>;

var<private> instance_index: u32;
var<private> draw_kind: u32;
var<private> decoration_span: vec2u;

fn prepare_draw_entry(invocation_index: u32) -> u32 {
  if (invocation_index >= storage_counts.draw) { return 0u; }

  let entry_index = read_draw_order(invocation_index);
  let entry = read_draw_entry(entry_index);

  if (entry.kind < DRAW_ENTRY_KIND_GLYPH_EDGE) { return 0u; }

  instance_index = entry.cell;
  draw_kind = entry.kind;
  decoration_span = entry.decoration_span;
  return 1u;
}

@compute @workgroup_size(64)
fn count(@builtin(global_invocation_id) global_id: vec3u) {
  if (prepare_draw_entry(global_id.x) == 0) { return; }

  var out_count = 0u;
  switch (draw_kind) {
    case DRAW_ENTRY_KIND_GLYPH_EDGE: { out_count = count_glyph_edge(); }
    case DRAW_ENTRY_KIND_GLYPH_FACE_FAN: { out_count = count_glyph_face_fan(); }
    case DRAW_ENTRY_KIND_GLYPH_FACE_COVER: { out_count = count_glyph_face_cover(); }
    default: { }
  }

  render_geometry_offset[global_id.x] = out_count;
}

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
    case DRAW_ENTRY_KIND_GLYPH_EDGE: { generate_glyph_edge(); }
    case DRAW_ENTRY_KIND_GLYPH_FACE_FAN: { generate_glyph_face_fan(); }
    case DRAW_ENTRY_KIND_GLYPH_FACE_COVER: { generate_glyph_face_cover(); }
    default: { }
  }

  for (var i = out_geometry_idx; i < out_geometry_end; i++) {
    render_geometry[i] = RENDER_GEOMETRY_NONE;
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Edge
// ---------------------------------------------------------------------------------------------------------------------

fn count_glyph_edge() -> u32 {
  return 0u;

  var count = 0u;
  let instance = glyph_instance[instance_index];
  let glyph_data = read_glyph_data(instance.glyph_index);
  for (var bi = 0u; bi < glyph_data.boundary_span.y; bi++) {
    let boundary = read_glyph_boundary(glyph_data.boundary_span.x + bi);
    
    for (var i = 0u; i < boundary.geometry_span.y; i++) {
      let quadratic = read_glyph_geometry(boundary.geometry_span.x + i);
      count += 1u;
    }
  }

  return count;
}

fn generate_glyph_edge() {

}

// ---------------------------------------------------------------------------------------------------------------------
// Face
// ---------------------------------------------------------------------------------------------------------------------

fn count_glyph_face_fan() -> u32 {
  var count = 0u;
  let instance = glyph_instance[instance_index];
  let glyph_data = read_glyph_data(instance.glyph_index);
  for (var bi = 0u; bi < glyph_data.boundary_span.y; bi++) {
    let boundary = read_glyph_boundary(glyph_data.boundary_span.x + bi);

    for (var i = 0u; i < boundary.geometry_span.y; i++) {
      let quadratic = read_glyph_geometry(boundary.geometry_span.x + i);
      count += 2u;
    }
  }

  return count;
}

fn generate_glyph_face_fan() {
  let instance = glyph_instance[instance_index];
  let glyph_data = read_glyph_data(instance.glyph_index);

  let glyph_local_transform = mat4_translate2_scale2(instance.offset, vec2f(instance.scale));
  let frame_transform = read_frame_transform(instance.parent_index);
  let world_transform = frame_transform * glyph_local_transform;

  let pivot = read_glyph_geometry(read_glyph_boundary(glyph_data.boundary_span.x).geometry_span.x).p0;
  let pivot_world = vec2_transform(world_transform, pivot);

  for (var bi = 0u; bi < glyph_data.boundary_span.y; bi++) {
    let boundary = read_glyph_boundary(glyph_data.boundary_span.x + bi);

    for (var i = 0u; i < boundary.geometry_span.y; i++) {
      let quadratic = read_glyph_geometry(boundary.geometry_span.x + i);
      let world_quadratic = quadratic2_transform(quadratic, world_transform);

      var tri1 = render_geometry_create_tri(
        pivot_world, world_quadratic.p0, world_quadratic.p2,
        vec4f(0), instance_index, NONE, vec2u(0)
      );
      tri1.flags |= RENDER_GEOMETRY_FLAG_STENCIL;

      var tri2 = render_geometry_create_tri(
        world_quadratic.p0, world_quadratic.p1, world_quadratic.p2,
        vec4f(0), instance_index, NONE, vec2u(0)
      );
      tri2.flags |= RENDER_GEOMETRY_FLAG_STENCIL;
      tri2.flags |= RENDER_GEOMETRY_FLAG_STENCIL_LOOP_BLINN_QUADRATIC;

      emit(tri1);
      emit(tri2);
    }
  }
}

fn count_glyph_face_cover() -> u32 {
  let instance = glyph_instance[instance_index];
  let glyph_data = read_glyph_data(instance.glyph_index);
  if (glyph_data.boundary_span.y == 0u) { return 0u; }
  return 1u;
}

fn generate_glyph_face_cover() {
  let instance = glyph_instance[instance_index];
  let glyph_data = read_glyph_data(instance.glyph_index);
  if (glyph_data.boundary_span.y == 0u) { return; }
  let glyph_local_transform = mat4_translate2_scale2(instance.offset, vec2f(instance.scale));
  let frame_transform = read_frame_transform(instance.parent_index);

  var world_bbox = BBOX_INV_INF;
  var local_bbox = BBOX_INV_INF;

  for (var bi = 0u; bi < glyph_data.boundary_span.y; bi++) {
    let boundary = read_glyph_boundary(glyph_data.boundary_span.x + bi);

    for (var i = 0u; i < boundary.geometry_span.y; i++) {
      let quadratic = quadratic2_transform(read_glyph_geometry(boundary.geometry_span.x + i), glyph_local_transform);
      let quadratic_world = quadratic2_transform(quadratic, frame_transform);

      world_bbox = bbox_hull_bbox(world_bbox, quadratic2_bbox(quadratic_world));
      local_bbox = bbox_hull_bbox(local_bbox, quadratic2_bbox(quadratic));
    }
  }

  emit(render_geometry_create_quad(
    world_bbox.xy, world_bbox.zy, world_bbox.xw, world_bbox.zw,
    local_bbox,
    instance_index, instance.parent_index, decoration_span
  ));
}
