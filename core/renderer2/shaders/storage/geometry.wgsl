#import "../bindings.wgsl"

fn read_frame_transform(index: u32) -> mat4x4f {
  let offset = storage_offsets.geometry_frame + index * 16u;
  return mat4x4f(
    bitcast<f32>(geometry[offset + 0u]),
    bitcast<f32>(geometry[offset + 1u]),
    bitcast<f32>(geometry[offset + 2u]),
    bitcast<f32>(geometry[offset + 3u]),
    bitcast<f32>(geometry[offset + 4u]),
    bitcast<f32>(geometry[offset + 5u]),
    bitcast<f32>(geometry[offset + 6u]),
    bitcast<f32>(geometry[offset + 7u]),
    bitcast<f32>(geometry[offset + 8u]),
    bitcast<f32>(geometry[offset + 9u]),
    bitcast<f32>(geometry[offset + 10u]),
    bitcast<f32>(geometry[offset + 11u]),
    bitcast<f32>(geometry[offset + 12u]),
    bitcast<f32>(geometry[offset + 13u]),
    bitcast<f32>(geometry[offset + 14u]),
    bitcast<f32>(geometry[offset + 15u])
  );
}

fn read_frame_inverse_transform(index: u32) -> mat4x4f {
  let offset = storage_offsets.geometry_frame_inverse + index * 16u;
  return mat4x4f(
    bitcast<f32>(geometry[offset + 0u]),
    bitcast<f32>(geometry[offset + 1u]),
    bitcast<f32>(geometry[offset + 2u]),
    bitcast<f32>(geometry[offset + 3u]),
    bitcast<f32>(geometry[offset + 4u]),
    bitcast<f32>(geometry[offset + 5u]),
    bitcast<f32>(geometry[offset + 6u]),
    bitcast<f32>(geometry[offset + 7u]),
    bitcast<f32>(geometry[offset + 8u]),
    bitcast<f32>(geometry[offset + 9u]),
    bitcast<f32>(geometry[offset + 10u]),
    bitcast<f32>(geometry[offset + 11u]),
    bitcast<f32>(geometry[offset + 12u]),
    bitcast<f32>(geometry[offset + 13u]),
    bitcast<f32>(geometry[offset + 14u]),
    bitcast<f32>(geometry[offset + 15u])
  );
}

fn read_vertex_position(index: u32) -> vec2f {
  let offset = storage_offsets.geometry_vertex + index * 2u;
  return vec2f(
    bitcast<f32>(geometry[offset + 0u]),
    bitcast<f32>(geometry[offset + 1u])
  );
}

fn read_covertex_tangent(index: u32) -> vec2f {
  let offset = storage_offsets.geometry_covertex + index * 2u;
  return vec2f(
    bitcast<f32>(geometry[offset + 0u]),
    bitcast<f32>(geometry[offset + 1u])
  );
}

fn read_edge_cubic(index: u32) -> Cubic2 {
  let offset = storage_offsets.geometry_edge + index * 8u;
  return Cubic2(
    vec2f(bitcast<f32>(geometry[offset + 0u]), bitcast<f32>(geometry[offset + 1u])),
    vec2f(bitcast<f32>(geometry[offset + 2u]), bitcast<f32>(geometry[offset + 3u])),
    vec2f(bitcast<f32>(geometry[offset + 4u]), bitcast<f32>(geometry[offset + 5u])),
    vec2f(bitcast<f32>(geometry[offset + 6u]), bitcast<f32>(geometry[offset + 7u]))
  );
}
