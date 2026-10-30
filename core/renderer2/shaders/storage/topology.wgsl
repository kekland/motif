#import "../bindings.wgsl"

fn read_vertex_topology(index: u32) -> VertexTopology {
  let offset = storage_offsets.topology_vertex + index * 2u;
  return VertexTopology(
    bitcast<u32>(topology[offset + 0u]),
    bitcast<u32>(topology[offset + 1u])
  );
}

fn read_edge_topology(index: u32) -> EdgeTopology {
  let offset = storage_offsets.topology_edge + index * 3u;
  return EdgeTopology(
    bitcast<u32>(topology[offset + 0u]),
    bitcast<u32>(topology[offset + 1u]),
    bitcast<u32>(topology[offset + 2u])
  );
}

fn read_face_topology(index: u32) -> FaceTopology {
  let offset = storage_offsets.topology_face + index * 3u;
  return FaceTopology(
    bitcast<u32>(topology[offset + 0u]),
    bitcast<u32>(topology[offset + 1u]),
    bitcast<u32>(topology[offset + 2u])
  );
}

fn read_covertex_topology(index: u32) -> CovertexTopology {
  let offset = storage_offsets.topology_covertex + index * 3u;
  return CovertexTopology(
    bitcast<u32>(topology[offset + 0u]),
    bitcast<u32>(topology[offset + 1u]),
    bitcast<u32>(topology[offset + 2u])
  );
}

fn read_face_boundary_entry(index: u32) -> FaceBoundaryEntry {
  let offset = storage_offsets.topology_face_boundary + index * 2u;
  return FaceBoundaryEntry(
    bitcast<u32>(topology[offset + 0u]),
    bitcast<u32>(topology[offset + 1u])
  );
}

fn read_draw_entry(index: u32) -> DrawEntry {
  let offset = storage_offsets.topology_draw + index * 3u;
  return DrawEntry(
    bitcast<u32>(topology[offset + 0u]),
    bitcast<u32>(topology[offset + 1u]),
    bitcast<u32>(topology[offset + 2u])
  );
}