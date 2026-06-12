struct Uniforms {
  cubic_count: u32,
  weight_anchor_count: u32,
  tolerance: f32,
  screen_size: vec2f,
  transform: mat4x4f,
}

struct VertexData {
  pos: vec2f,
  incident_edges_span: vec2u,
}

struct EdgeData {
  start_vertex_idx: u32,
  end_vertex_idx: u32,
  cubics_span: vec2u,
  weight_span: vec2u,
  width: f32,
  arc_length: f32,
  color: vec4f,
}

struct CubicData {
  cubic: Cubic2,
  edge_idx: u32,
  edge_segment_idx: u32,
  edge_segment_count: u32,
  edge_start_arc_length: f32,
  opacity: f32,
}
