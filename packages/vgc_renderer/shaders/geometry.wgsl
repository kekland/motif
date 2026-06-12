// A quad.
// - v0-v3: four vertices
const RENDER_GEOMETRY_KIND_QUAD = 0u;

// // An ellipse.
// // - v0: center
// // - v1: radii
// const RENDER_GEOMETRY_KIND_ELLIPSE = 1u;

struct RenderGeometry {
  v0: vec2f,
  v1: vec2f,
  v2: vec2f,
  v3: vec2f,
  color: vec4f,
  z_index: u32,
  kind: u32,
}

fn render_geometry_create_quad(v0: vec2f, v1: vec2f, v2: vec2f, v3: vec2f, color: vec4f, z_index: u32) -> RenderGeometry {
  return RenderGeometry(v0, v1, v2, v3, color, z_index, RENDER_GEOMETRY_KIND_QUAD);
}

// fn render_geometry_create_ellipse(c: vec2f, r: vec2f, color: vec4f, z_index: u32) -> RenderGeometry {
//   return RenderGeometry(c, r, vec2f(0.0), vec2f(0.0), color, z_index, RENDER_GEOMETRY_KIND_ELLIPSE);
// }

// fn render_geometry_create_circle(c: vec2f, r: f32, color: vec4f, z_index: u32) -> RenderGeometry {
//   return render_geometry_create_ellipse(c, vec2f(r), color, z_index);
// }
