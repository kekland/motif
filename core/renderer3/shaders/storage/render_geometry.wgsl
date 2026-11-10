struct DrawIndirectArgs {
  vertex_count: u32,
  instance_count: u32,
  first_vertex: u32,
  first_instance: u32,
}

struct RenderGeometry {
  a: vec2f,
  b: vec2f,
  c: vec2f,
  d: vec2f,
  x: f32,
  y: f32,
  local_bbox: vec4f,
  cell: u32,
  parent_index: u32,
  decoration_span: vec2u,
  kind: u32,
  flags: u32,
}

const RENDER_GEOMETRY_KIND_NONE = 0u;
const RENDER_GEOMETRY_KIND_TRI = 1u;
const RENDER_GEOMETRY_KIND_QUAD = 2u;

const RENDER_GEOMETRY_FLAG_STENCIL = 1u;
const RENDER_GEOMETRY_FLAG_STENCIL_LOOP_BLINN_QUADRATIC = 2u;

const RENDER_GEOMETRY_NONE: RenderGeometry = RenderGeometry(
  vec2f(0.0), vec2f(0.0), vec2f(0.0), vec2f(0.0),
  0.0, 0.0,
  vec4f(0.0),
  0u, 0u,
  vec2u(0u),
  RENDER_GEOMETRY_KIND_NONE,
  0u,
);

// ---------------------------------------------------------------------------------------------------------------------
// Triangles
// ---------------------------------------------------------------------------------------------------------------------

struct RenderGeometryTri {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
  local_bbox: vec4f,
  cell: u32,
  parent_index: u32,
  decoration_span: vec2u,
}

fn render_geometry_create_tri(p0: vec2f, p1: vec2f, p2: vec2f, local_bbox: vec4f, cell: u32, parent_index: u32, decoration_span: vec2u) -> RenderGeometry {
  return RenderGeometry(
    p0, p1, p2, vec2f(0.0),
    0.0, 0.0,
    local_bbox,
    cell, parent_index,
    decoration_span,
    RENDER_GEOMETRY_KIND_TRI,
    0u,
  );
}

fn render_geometry_read_tri(geometry: RenderGeometry) -> RenderGeometryTri {
  return RenderGeometryTri(
    geometry.a, geometry.b, geometry.c,
    geometry.local_bbox,
    geometry.cell, geometry.parent_index,
    geometry.decoration_span
  );
}

// ---------------------------------------------------------------------------------------------------------------------
// Quads
// ---------------------------------------------------------------------------------------------------------------------

struct RenderGeometryQuad {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
  p3: vec2f,
  local_bbox: vec4f,
  cell: u32,
  parent_index: u32,
  decoration_span: vec2u,
}

fn render_geometry_create_quad(p0: vec2f, p1: vec2f, p2: vec2f, p3: vec2f, local_bbox: vec4f, cell: u32, parent_index: u32, decoration_span: vec2u) -> RenderGeometry {
  return RenderGeometry(
    p0, p1, p2, p3,
    0.0, 0.0,
    local_bbox,
    cell, parent_index,
    decoration_span,
    RENDER_GEOMETRY_KIND_QUAD,
    0u,
  );
}

fn render_geometry_read_quad(geometry: RenderGeometry) -> RenderGeometryQuad {
  return RenderGeometryQuad(
    geometry.a, geometry.b, geometry.c, geometry.d,
    geometry.local_bbox,
    geometry.cell, geometry.parent_index,
    geometry.decoration_span
  );
}
