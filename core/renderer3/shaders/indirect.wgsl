#define BINDINGS_DEFINED

#import "storage/uniforms.wgsl"
#import "storage/render_geometry.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;
@group(0) @binding(2) var<uniform> storage_counts: StorageCounts;
@group(0) @binding(3) var<uniform> storage_capacity: StorageCapacity;

@group(2) @binding(2) var<storage, read_write> render_geometry_offset: array<u32>;
@group(2) @binding(4) var<storage, read_write> render_indirect: array<DrawIndirectArgs>;

@compute @workgroup_size(64)
fn indirect(@builtin(global_invocation_id) global_id: vec3u) {
  let index = global_id.x;
  if (index >= storage_counts.draw) { return; }

  let offset = render_geometry_offset[index];
  let count = render_geometry_offset[index + 1] - offset;

  render_indirect[index] = DrawIndirectArgs(count * 6u, 1u, offset * 6u, 0u);
}
