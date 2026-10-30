struct Cubic2 {
  p0: vec2f,
  p1: vec2f,
  p2: vec2f,
  p3: vec2f,
}

struct VertexStyle {
  decoration_start: u32,
  decoration_count: u32,
}

struct EdgeStyle {
  decoration_start: u32,
  decoration_count: u32,
  width: f32,
}

struct FaceStyle {
  decoration_start: u32,
  decoration_count: u32,
}

struct VertexTopology {
  disk_start: u32,
  parent: u32,
}

struct EdgeTopology {
  vertex_start: u32,
  vertex_end: u32,
  parent: u32,
}

struct FaceTopology {
  boundary_start: u32,
  boundary_count: u32,
  parent: u32,
}

struct CovertexTopology {
  edge: u32,
  is_start: u32,
  next: u32,
}

struct FaceBoundaryEntry {
  edge: u32,
  is_forward: u32,
}

struct DrawEntry {
  cell: u32,
  kind: u32,
  decoration_offset: u32,
}

struct DrawIndirectArgs {
  vertex_count: u32,
  instance_count: u32,
  first_vertex: u32,
  first_instance: u32,
}

struct DecorationEntry {
  kind: u32,
  v0: f32,
  v1: f32,
  v2: f32,
  v3: f32,
}

const DECORATION_NONE = DecorationEntry(
  DECORATION_KIND_NONE,
  0.0, 0.0, 0.0, 0.0
);

const DECORATION_KIND_NONE = 0;
const DECORATION_KIND_COLOR = 1;
const DECORATION_KIND_FRAGMENT_SHADER = 2;