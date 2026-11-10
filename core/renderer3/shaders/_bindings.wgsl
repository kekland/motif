#ifndef BINDINGS_DEFINED

#import "_storage.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;
@group(0) @binding(2) var<uniform> storage_counts: StorageCounts;
@group(0) @binding(3) var<uniform> storage_capacity: StorageCapacity;

@group(1) @binding(0) var<storage, read> topology: array<u32>;
@group(1) @binding(1) var<storage, read> geometry: array<u32>;
@group(1) @binding(2) var<storage, read> style: array<u32>;
@group(1) @binding(3) var<storage, read> decoration: array<Decoration>;
@group(1) @binding(4) var<storage, read> draw: array<u32>;
@group(1) @binding(5) var<storage, read> glyph_instances: array<GlyphInstance>;
@group(1) @binding(6) var<storage, read> glyph_geometry: array<u32>;
@group(1) @binding(7) var<storage, read> text_style: array<TextStyle>;

@group(2) @binding(0) var<storage, read_write> segment_offset: array<u32>;
@group(2) @binding(1) var<storage, read_write> segments: array<vec4f>;
@group(2) @binding(2) var<storage, read_write> render_geometry_offset: array<u32>;
@group(2) @binding(3) var<storage, read_write> render_geometry: array<RenderGeometry>;
@group(2) @binding(4) var<storage, read_write> render_indirect: array<DrawIndirectArgs>;

#endif