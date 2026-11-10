#import "../_bindings.wgsl"
#import "../math/quadratic.wgsl"

struct TextStyle {
  edge_decoration_span: vec2u,
  face_decoration_span: vec2u,
  edge_width: f32,
}

struct GlyphData {
  boundary_span: vec2u,
}

struct GlyphBoundary {
  geometry_span: vec2u,
}

struct GlyphInstance {
  offset: vec2f,
  parent_index: u32,
  glyph_index: u32,
  style_index: u32,
  scale: f32,
}

fn read_glyph_data(index: u32) -> GlyphData {
  let offset = storage_offsets.glyph_data + index * 2u;
  return GlyphData(
    vec2u(
      bitcast<u32>(glyph_geometry[offset]),
      bitcast<u32>(glyph_geometry[offset + 1u])
    ),
  );
}

fn read_glyph_boundary(index: u32) -> GlyphBoundary {
  let offset = storage_offsets.glyph_boundary + index * 2u;
  return GlyphBoundary(
    vec2u(
      bitcast<u32>(glyph_geometry[offset]),
      bitcast<u32>(glyph_geometry[offset + 1u])
    ),
  );
}

fn read_glyph_geometry(index: u32) -> Quadratic2 {
  let offset = storage_offsets.glyph_geometry + index * 6u;
  return Quadratic2(
    vec2f(
      bitcast<f32>(glyph_geometry[offset]),
      bitcast<f32>(glyph_geometry[offset + 1u])
    ),
    vec2f(
      bitcast<f32>(glyph_geometry[offset + 2u]),
      bitcast<f32>(glyph_geometry[offset + 3u])
    ),
    vec2f(
      bitcast<f32>(glyph_geometry[offset + 4u]),
      bitcast<f32>(glyph_geometry[offset + 5u])
    ),
  );
}
