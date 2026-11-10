#define BINDINGS_DEFINED

#import "math/math.wgsl"
#import "storage/uniforms.wgsl"
#import "storage/geometry.wgsl"
#import "storage/glyph.wgsl"
#import "storage/draw.wgsl"
#import "storage/render_geometry.wgsl"
#import "utils/limits.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;
@group(0) @binding(2) var<uniform> storage_counts: StorageCounts;
@group(0) @binding(3) var<uniform> storage_capacity: StorageCapacity;

@group(1) @binding(1) var<storage, read> geometry: array<u32>;
@group(1) @binding(4) var<storage, read> draw: array<u32>;
@group(1) @binding(5) var<storage, read> glyph_instance: array<GlyphInstance>;
@group(1) @binding(6) var<storage, read> glyph_geometry: array<u32>;
@group(1) @binding(7) var<storage, read> text_style: array<TextStyle>;

@group(2) @binding(2) var<storage, read_write> render_geometry_offset: array<u32>;
@group(2) @binding(3) var<storage, read_write> render_geometry: array<RenderGeometry>;

var<private> instance_index: u32;
var<private> local_bbox: vec4f;
var<private> draw_kind: u32;
var<private> decoration_span: vec2u;

fn prepare_draw_entry(invocation_index: u32) -> u32 {
  if (invocation_index >= storage_counts.draw) { return 0u; }

  let entry_index = read_draw_order(invocation_index);
  let entry = read_draw_entry(entry_index);

  if (entry.kind < DRAW_ENTRY_KIND_GLYPH_EDGE) { return 0u; }

  instance_index = entry.cell;
  draw_kind = entry.kind;
  local_bbox = entry.local_bbox;
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

fn get_glyph_edge_join_arc(a: Quadratic2, b: Quadratic2) -> vec2f {
  var dir_a = a.p1 - a.p2;
  if (dot(dir_a, dir_a) < 1e-12) { dir_a = a.p0 - a.p2; }

  var dir_b = b.p1 - b.p0;
  if (dot(dir_b, dir_b) < 1e-12) { dir_b = b.p2 - b.p0; }
  if (dot(dir_a, dir_a) < 1e-12 || dot(dir_b, dir_b) < 1e-12) { return vec2f(0.0); }
  
  let angle_a = atan2(dir_a.y, dir_a.x);
  let angle_b = atan2(dir_b.y, dir_b.x);
  var gap = angle_b - angle_a;
  if (gap <= 0.0) { gap += 2.0 * PI; }

  var start = angle_a;
  if (gap < PI) {
    start = angle_b;
    gap = 2.0 * PI - gap;
  }

  let span = gap - PI;
  if (span < 0.01) { return vec2f(0.0); }
  return vec2f(start + PI * 0.5, span);
}

fn count_glyph_edge_join_segments(span: f32, radius: f32) -> u32 {
  if (span == 0.0 || radius <= 0.0) { return 0u; }
  return count_arc_segments(abs(span), radius, world.tolerance, MAX_ARC_SEGMENTS);
}

fn count_glyph_edge() -> u32 {
  var count = 0u;
  let instance = glyph_instance[instance_index];
  let glyph_data = read_glyph_data(instance.glyph_index);

  let style = text_style[instance.style_index];
  let half_width = style.edge_width / 2.0;

  let glyph_local_transform = mat4_translate2_scale2(instance.offset, vec2f(instance.scale));
  let frame_transform = read_frame_transform(instance.parent_index);
  let world_transform = frame_transform * glyph_local_transform;

  for (var bi = 0u; bi < glyph_data.boundary_span.y; bi++) {
    let boundary = read_glyph_boundary(glyph_data.boundary_span.x + bi);
    let quadratic_count = boundary.geometry_span.y;
    if (quadratic_count == 0u) { continue; }

    var prev = quadratic2_transform(read_glyph_geometry(boundary.geometry_span.x + quadratic_count - 1u), world_transform);
    
    for (var i = 0u; i < quadratic_count; i++) {
      let quadratic = quadratic2_transform(read_glyph_geometry(boundary.geometry_span.x + i), world_transform);
      let segment_count = min(u32(ceil(quadratic2_wang(quadratic, world.tolerance))), MAX_QUADRATIC_SEGMENT_COUNT);
      count += segment_count;

      let join_arc = get_glyph_edge_join_arc(prev, quadratic);
      count += count_glyph_edge_join_segments(join_arc.y, half_width);

      prev = quadratic;
    }
  }

  return count;
}

fn generate_arc(position: vec2f, r0: f32, r1: f32, a0: f32, span: f32, count: u32, decoration_span: vec2u, parent_index: u32) {
  for (var i = 0u; i < count; i++) {
    let t0 = a0 + span * f32(i) / f32(count);
    let t1 = a0 + span * f32(i + 1u) / f32(count);
    emit(render_geometry_create_tri(
      position,
      position + r0 * vec2f(cos(t0), sin(t0)),
      position + r1 * vec2f(cos(t1), sin(t1)),
      local_bbox,
      instance_index,
      parent_index,
      decoration_span,
    ));
  }
}

fn generate_glyph_edge() {
  let instance = glyph_instance[instance_index];
  let glyph_data = read_glyph_data(instance.glyph_index);

  let style = text_style[instance.style_index];
  let half_width = style.edge_width / 2.0;

  let glyph_local_transform = mat4_translate2_scale2(instance.offset, vec2f(instance.scale));
  let frame_transform = read_frame_transform(instance.parent_index);
  let world_transform = frame_transform * glyph_local_transform;

  for (var bi = 0u; bi < glyph_data.boundary_span.y; bi++) {
    let boundary = read_glyph_boundary(glyph_data.boundary_span.x + bi);
    let quadratic_count = boundary.geometry_span.y;
    if (quadratic_count == 0u) { continue; }

    var prev = quadratic2_transform(read_glyph_geometry(boundary.geometry_span.x + quadratic_count - 1u), world_transform);
    
    for (var i = 0u; i < quadratic_count; i++) {
      let quadratic = quadratic2_transform(read_glyph_geometry(boundary.geometry_span.x + i), world_transform);
      let segment_count = min(u32(ceil(quadratic2_wang(quadratic, world.tolerance))), MAX_QUADRATIC_SEGMENT_COUNT);

      let join_arc = get_glyph_edge_join_arc(prev, quadratic);
      let join_count = count_glyph_edge_join_segments(join_arc.y, half_width);
      generate_arc(
        quadratic.p0, half_width, half_width, join_arc.x, join_arc.y,
        join_count, decoration_span, instance.parent_index
      );

      var last = quadratic2_pos_tan(quadratic, 0.0);
      let inv_count = 1.0 / f32(segment_count);
      for (var si = 1u; si <= segment_count; si++) {
        let p0 = last.xy;
        let tan0 = last.zw;

        let t = f32(si) * inv_count;
        let current = quadratic2_pos_tan(quadratic, t);
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
          instance_index, instance.parent_index, decoration_span
        ));

        last = current;
      }

      prev = quadratic;
    }
  }
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
  let frame_transform = read_frame_transform(instance.parent_index);

  let world_bbox = bbox_transform(local_bbox, frame_transform);
  emit(render_geometry_create_quad(
    world_bbox.xy, world_bbox.zy, world_bbox.xw, world_bbox.zw,
    local_bbox,
    instance_index, instance.parent_index, decoration_span
  ));
}
