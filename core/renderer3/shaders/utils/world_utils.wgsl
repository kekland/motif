#import "../_bindings.wgsl"

fn read_vertex_position_world(index: u32) -> vec2f {
  let local_position = read_vertex_position(index);
  let parent = read_vertex_topology(index).parent;
  let transform = read_frame_transform(parent);
  return (transform * vec4f(local_position, 0.0, 1.0)).xy;
}

fn read_covertex_tangent_world(vertex_index: u32, covertex_index: u32) -> vec2f {
  let local_tangent = read_covertex_tangent(covertex_index);
  let parent = read_vertex_topology(vertex_index).parent;
  let transform = read_frame_transform(parent);
  return (transform * vec4f(local_tangent, 0.0, 0.0)).xy;
}

fn read_edge_cubic_world(index: u32) -> Cubic2 {
  let local_cubic = read_edge_cubic(index);
  let parent = read_edge_topology(index).parent;
  let transform = read_frame_transform(parent);
  return cubic2_transform(local_cubic, transform);
}

// fn read_face_boundary_cubic_world(index: u32) -> Cubic2 {
//   let entry = read_face_boundary_entry(index);
//   let cubic = read_edge_cubic_world(entry.edge);
//   let is_forward = entry.is_forward == 1;

//   return Cubic2(
//     select(cubic.p3, cubic.p0, is_forward),
//     select(cubic.p2, cubic.p1, is_forward),
//     select(cubic.p1, cubic.p2, is_forward),
//     select(cubic.p0, cubic.p3, is_forward),
//   );
// }