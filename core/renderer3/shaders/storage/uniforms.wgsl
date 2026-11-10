const NONE = 0xffffffffu;

struct World {
  world_to_screen: mat4x4f,
  viewport: vec2f,
  tolerance: f32,
}

struct StorageCounts {
  draw: u32,
  draw_edge: u32,
}

struct StorageOffsets {
  geometry_frame: u32,
  geometry_frame_inverse: u32,
  geometry_vertex: u32,
  geometry_covertex: u32,
  geometry_edge: u32,
  
  topology_vertex: u32,
  topology_edge: u32,
  topology_face: u32,
  topology_covertex: u32,
  topology_face_boundary: u32,

  style_vertex: u32,
  style_edge: u32,
  style_face: u32,

  glyph_data: u32,
  glyph_boundary: u32,
  glyph_geometry: u32,

  draw_entry: u32,
  draw_edge: u32,
  draw_order: u32,
}

struct StorageCapacity {
  segments: u32,
}
