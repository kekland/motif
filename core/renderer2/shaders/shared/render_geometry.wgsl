const RENDER_GEOMETRY_KIND_TRI = 0u;
const RENDER_GEOMETRY_KIND_QUAD = 1u;

struct RenderGeometry {
  a: vec2f,
  b: vec2f,
  c: vec2f,
  d: vec2f,
  x: f32,
  y: f32,
  cell: u32,
  decoration_index: u32,
  frame_index: u32,
  flags: u32,
}

const RENDER_GEOMETRY_EMPTY: RenderGeometry = RenderGeometry(
  vec2f(0.0),
  vec2f(0.0),
  vec2f(0.0),
  vec2f(0.0),
  0.0,
  0.0,
  0u,
  0u,
  0u,
  0u
);

// ---------------------------------------------------------------------------------------------------------------------
// Triangles
// ---------------------------------------------------------------------------------------------------------------------

struct RenderGeometryTri {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
  cell: u32,
  decoration_index: u32,
  frame_index: u32,
}

fn render_geometry_create_tri(p0: vec2f, p1: vec2f, p2: vec2f, cell: u32, decoration_index: u32, frame_index: u32) -> RenderGeometry {
  return RenderGeometry(
    p0,
    p1,
    p2,
    vec2f(0.0),
    0.0,
    0.0,
    cell,
    decoration_index,
    frame_index,
    RENDER_GEOMETRY_KIND_TRI
  );
}

fn render_geometry_read_tri(geometry: RenderGeometry) -> RenderGeometryTri {
  return RenderGeometryTri(
    geometry.a,
    geometry.b,
    geometry.c,
    geometry.cell,
    geometry.decoration_index,
    geometry.frame_index
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
  cell: u32,
  decoration_index: u32,
  frame_index: u32,
}

fn render_geometry_create_quad(p0: vec2f, p1: vec2f, p2: vec2f, p3: vec2f, cell: u32, decoration_index: u32, frame_index: u32) -> RenderGeometry {
  return RenderGeometry(
    p0,
    p1,
    p2,
    p3,
    0.0,
    0.0,
    cell,
    decoration_index,
    frame_index,
    RENDER_GEOMETRY_KIND_QUAD
  );
}

fn render_geometry_read_quad(geometry: RenderGeometry) -> RenderGeometryQuad {
  return RenderGeometryQuad(
    geometry.a,
    geometry.b,
    geometry.c,
    geometry.d,
    geometry.cell,
    geometry.decoration_index,
    geometry.frame_index
  );
}
