#import "../bindings.wgsl"

fn read_vertex_style(index: u32) -> VertexStyle {
  let offset = storage_offsets.style_vertex + index * 2u;
  return VertexStyle(
    bitcast<u32>(style[offset + 0u]),
    bitcast<u32>(style[offset + 1u])
  );
}

fn read_edge_style(index: u32) -> EdgeStyle {
  let offset = storage_offsets.style_edge + index * 3u;
  return EdgeStyle(
    bitcast<u32>(style[offset + 0u]),
    bitcast<u32>(style[offset + 1u]),
    bitcast<f32>(style[offset + 2u])
  );
}

fn read_face_style(index: u32) -> FaceStyle {
  let offset = storage_offsets.style_face + index * 2u;
  return FaceStyle(
    bitcast<u32>(style[offset + 0u]),
    bitcast<u32>(style[offset + 1u])
  );
}
