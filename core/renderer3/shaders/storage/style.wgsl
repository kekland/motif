#import "../_bindings.wgsl"

struct VertexStyle {
  decoration_span: vec2u,
}

struct EdgeStyle {
  decoration_span: vec2u,
  width: f32,
}

struct FaceStyle {
  decoration_span: vec2u,
}

fn read_vertex_style(index: u32) -> VertexStyle {
  let offset = storage_offsets.style_vertex + index * 2u;
  return VertexStyle(
    vec2u(
      bitcast<u32>(style[offset + 0u]),
      bitcast<u32>(style[offset + 1u]),
    ),
  );
}

fn read_edge_style(index: u32) -> EdgeStyle {
  let offset = storage_offsets.style_edge + index * 3u;
  return EdgeStyle(
    vec2u(
      bitcast<u32>(style[offset + 0u]),
      bitcast<u32>(style[offset + 1u]),
    ),
    bitcast<f32>(style[offset + 2u]),
  );
}

fn read_face_style(index: u32) -> FaceStyle {
  let offset = storage_offsets.style_face + index * 2u;
  return FaceStyle(
    vec2u(
      bitcast<u32>(style[offset + 0u]),
      bitcast<u32>(style[offset + 1u]),
    ),
  );
}
