#define BINDINGS_DEFINED

#import "shared/structs.wgsl"
#import "shared/uniforms.wgsl"
#import "shared/constants.wgsl"
#import "shared/render_geometry.wgsl"
#import "storage/geometry.wgsl"
#import "geometry/cubic.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;

@group(1) @binding(0) var<storage, read> geometry: array<u32>;
@group(2) @binding(2) var<storage, read> render_geometry: array<RenderGeometry>;
@group(3) @binding(0) var<storage, read> decorations: array<DecorationEntry>;

struct VtxOut {
  @builtin(position) clip_pos: vec4f,
  @location(0) world_position: vec2f,
  @location(1) local_position: vec2f,
  @location(2) @interpolate(flat) cell: u32,
  @location(3) @interpolate(flat) decoration_kind: u32,
  @location(4) @interpolate(flat) decoration_v0: f32,
  @location(5) @interpolate(flat) decoration_v1: f32,
  @location(6) @interpolate(flat) decoration_v2: f32,
  @location(7) @interpolate(flat) decoration_v3: f32,
}

fn to_clip(p: vec2f) -> vec4f {
  let ndc = vec2f((p.x / world.viewport.x * 2.0) - 1.0, 1.0 - (p.y / world.viewport.y * 2.0));
  return vec4f(ndc, 0.0, 1.0);
}

@vertex
fn vs_main(@builtin(vertex_index) vertex_index: u32) -> VtxOut {
  let geom = render_geometry[vertex_index / 6u];
  let kind = geom.flags;
  let frame_index = geom.frame_index;
  let inverse_world_transform = read_frame_inverse_transform(frame_index);

  var decoration: DecorationEntry;
  if (geom.decoration_index == NONE) {
    decoration = DECORATION_NONE;
  }
  else {
    decoration = decorations[geom.decoration_index];
  }

  var position_world = vec2f(0.0);

  if (kind == RENDER_GEOMETRY_KIND_TRI) {
    let tri = render_geometry_read_tri(geom);

    switch(vertex_index % 6u) {
      case 0u: { position_world = tri.p0; }
      case 1u: { position_world = tri.p1; }
      case 2u: { position_world = tri.p2; }
      default: { position_world = tri.p0; }
    };
  }
  else if (kind == RENDER_GEOMETRY_KIND_QUAD) {
    let quad = render_geometry_read_quad(geom);

    switch(vertex_index % 6u) {
      case 0u:     { position_world = quad.p0; }
      case 1u, 4u: { position_world = quad.p1; }
      case 2u, 3u: { position_world = quad.p2; }
      case 5u:     { position_world = quad.p3; }
      default: {}
    };
  }

  let position_local = (inverse_world_transform * vec4f(position_world, 0.0, 1.0)).xy;
  let position_screen = world.world_to_screen * vec4f(position_world, 0.0, 1.0);
  var out = VtxOut();
  out.clip_pos = to_clip(position_screen.xy);
  out.world_position = position_world;
  out.local_position = position_local;
  out.cell = geom.cell;
  out.decoration_kind = decoration.kind;
  out.decoration_v0 = decoration.v0;
  out.decoration_v1 = decoration.v1;
  out.decoration_v2 = decoration.v2;
  out.decoration_v3 = decoration.v3;
  return out;
}

// %MARK% USER FRAGMENT SHADER SLOT


@fragment
fn fs_main(in: VtxOut) -> @location(0) vec4f {
  let decoration_kind = in.decoration_kind;
  
  if (decoration_kind == DECORATION_KIND_COLOR) {
    let color = vec4f(in.decoration_v0, in.decoration_v1, in.decoration_v2, in.decoration_v3);
    return color;
  }
  else if (decoration_kind == DECORATION_KIND_FRAGMENT_SHADER) {
    let index = bitcast<u32>(in.decoration_v0);
    var color = vec4f(0.0);
    switch(index) {
      // % MARK% USER FRAGMENT SHADER SELECTOR SLOT
      default: { }
    }

    return color;
  }

  return vec4f(0.0, 0.0, 0.0, 1.0);
}
