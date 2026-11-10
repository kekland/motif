#define BINDINGS_DEFINED

#import "math/math.wgsl"
#import "storage/uniforms.wgsl"
#import "storage/geometry.wgsl"
#import "storage/decoration.wgsl"
#import "storage/render_geometry.wgsl"

@group(0) @binding(0) var<uniform> world: World;
@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;
@group(0) @binding(2) var<uniform> storage_counts: StorageCounts;
@group(0) @binding(3) var<uniform> storage_capacity: StorageCapacity;

@group(1) @binding(1) var<storage, read> geometry: array<u32>;
@group(1) @binding(3) var<storage, read> decoration: array<Decoration>;

@group(2) @binding(3) var<storage, read> render_geometry: array<RenderGeometry>;

const WIRE_WIDTH = 2.0;
const WIRE_COLOR_TRI = vec4f(0.2, 1.0, 0.3, 1.0);
const WIRE_COLOR_QUAD = vec4f(0.2, 0.8, 1.0, 1.0);
const WIRE_COLOR_LOOP_BLINN_QUADRATIC = vec4f(1.0, 0.6, 0.1, 1.0);

struct VtxOut {
  @builtin(position) clip_position: vec4f,
  @location(0) barycentric: vec3f,
  @location(1) @interpolate(flat) color: vec4f,
}

fn to_clip(p: vec2f) -> vec4f {
  let ndc = vec2f((p.x / world.viewport.x * 2.0) - 1.0, 1.0 - (p.y / world.viewport.y * 2.0));
  return vec4f(ndc, 0.0, 1.0);
}

@vertex
fn vs_main(@builtin(vertex_index) vertex_index: u32) -> VtxOut {
  let instance_index = vertex_index / 6u;
  let corner = vertex_index % 6u;

  let geom = render_geometry[instance_index];
  let kind = geom.kind;

  var position_world = vec2f(0.0);
  var color = vec4f(1.0, 0.0, 0.0, 1.0);

  if (kind == RENDER_GEOMETRY_KIND_TRI) {
    let tri = render_geometry_read_tri(geom);
    switch(corner) {
      case 0u: { position_world = tri.p0; }
      case 1u: { position_world = tri.p1; }
      case 2u: { position_world = tri.p2; }
      default: { position_world = tri.p0; }
    };
    color = WIRE_COLOR_TRI;
    if ((geom.flags & RENDER_GEOMETRY_FLAG_STENCIL_LOOP_BLINN_QUADRATIC) != 0u) {
      color = WIRE_COLOR_LOOP_BLINN_QUADRATIC;
    }
  }
  else if (kind == RENDER_GEOMETRY_KIND_QUAD) {
    let quad = render_geometry_read_quad(geom);
    switch(corner) {
      case 0u:     { position_world = quad.p0; }
      case 1u, 4u: { position_world = quad.p1; }
      case 2u, 3u: { position_world = quad.p2; }
      case 5u:     { position_world = quad.p3; }
      default: {}
    };
    color = WIRE_COLOR_QUAD;
  }

  var barycentric = vec3f(0.0);
  barycentric[corner % 3u] = 1.0;

  let position_screen = world.world_to_screen * vec4f(position_world, 0.0, 1.0);

  var out = VtxOut();
  out.clip_position = to_clip(position_screen.xy);
  out.barycentric = barycentric;
  out.color = color;
  return out;
}

@fragment
fn fs_main(in: VtxOut) -> @location(0) vec4f {
  let w = fwidth(in.barycentric);
  let e = smoothstep(vec3f(0.0), w * WIRE_WIDTH, in.barycentric);
  let alpha = 1.0 - min(e.x, min(e.y, e.z));
  return in.color * alpha;
}
