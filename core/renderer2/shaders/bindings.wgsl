#ifndef BINDINGS_DEFINED

#import "shared/structs.wgsl"
#import "shared/uniforms.wgsl"
#import "shared/constants.wgsl"
#import "shared/render_geometry.wgsl"
#import "storage/geometry.wgsl"
#import "storage/topology.wgsl"
#import "storage/style.wgsl"
#import "geometry/cubic.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;

@group(1) @binding(0) var<storage, read> geometry: array<u32>;
@group(1) @binding(1) var<storage, read> topology: array<u32>;
@group(1) @binding(2) var<storage, read> style: array<u32>;

@group(2) @binding(0) var<storage, read_write> count: array<u32>;
@group(2) @binding(1) var<storage, read_write> indirect_args: array<DrawIndirectArgs>;
@group(2) @binding(2) var<storage, read> render_geometry: array<RenderGeometry>;

@group(3) @binding(0) var<storage, read> decorations: array<DecorationEntry>;

#endif