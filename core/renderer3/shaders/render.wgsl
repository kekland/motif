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

@group(3) @binding(0) var decoration_image_sampler: sampler;
@group(3) @binding(1) var decoration_image_texture: texture_2d<f32>;

struct VtxOut {
  @builtin(position) clip_position: vec4f,
  @location(0) world_position: vec2f,
  @location(1) local_position: vec2f,
  @location(2) local_bbox: vec4f,
  @location(3) uv: vec2f,
  @location(4) @interpolate(flat) cell: u32,
  @location(5) @interpolate(flat) flags: u32,
  @location(6) @interpolate(flat) decoration_span: vec2u,
}

fn to_clip(p: vec2f) -> vec4f {
  let ndc = vec2f((p.x / world.viewport.x * 2.0) - 1.0, 1.0 - (p.y / world.viewport.y * 2.0));
  return vec4f(ndc, 0.0, 1.0);
}

@vertex
fn vs_main(@builtin(vertex_index) vertex_index: u32) -> VtxOut {
  let instance_index = vertex_index / 6u;
  let geom = render_geometry[instance_index];
  let kind = geom.kind;
  let flags = geom.flags;
  let parent_index = geom.parent_index;
  let inverse_world_transform = read_frame_inverse_transform(parent_index);

  var position_world = vec2f(0.0);
  var uv = vec2f(0.0);

  if (kind == RENDER_GEOMETRY_KIND_TRI) {
    let tri = render_geometry_read_tri(geom);
    switch(vertex_index % 6u) {
      case 0u: { position_world = tri.p0; }
      case 1u: { position_world = tri.p1; }
      case 2u: { position_world = tri.p2; }
      default: { position_world = tri.p0; }
    };

    if ((flags & RENDER_GEOMETRY_FLAG_STENCIL_LOOP_BLINN_QUADRATIC) != 0u) {
      switch(vertex_index % 6u) {
        case 0u: { uv = vec2f(0.0, 0.0); }
        case 1u: { uv = vec2f(0.5, 0.0); }
        case 2u: { uv = vec2f(1.0, 1.0); }
        default: { uv = vec2f(0.0, 0.0); }
      }
    }
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
  out.clip_position = to_clip(position_screen.xy);
  out.world_position = position_world;
  out.local_position = position_local;
  out.local_bbox = geom.local_bbox;
  out.uv = uv;
  out.cell = geom.cell;
  out.flags = flags;
  out.decoration_span = geom.decoration_span;
  return out;
}

// %MARK% USER FRAGMENT SHADER FUNCTION SLOT

@fragment
fn fs_main(in: VtxOut) -> @location(0) vec4f {
  var acc = vec4f(0.0, 0.0, 0.0, 1.0);

  let decoration_start = in.decoration_span.x;
  let decoration_end = decoration_start + in.decoration_span.y;

  for (var offset = 0u; offset < in.decoration_span.y; offset++) {
    let i = (decoration_end - 1u) - offset;
    let dec = decoration[i];

    var color = vec4f(0.0);
    if (dec.kind == DECORATION_KIND_COLOR) {
      color = vec4f(dec.v0, dec.v1, dec.v2, dec.v3);
    }
    else if (dec.kind == DECORATION_KIND_IMAGE) {
      let texture_size = vec2f(textureDimensions(decoration_image_texture, 0));
      let bbox_position = in.local_position - in.local_bbox.xy;
      let bbox_size = bbox_size(in.local_bbox);
      let uv = bbox_position / bbox_size;
      let sample = textureSampleLevel(decoration_image_texture, decoration_image_sampler, uv, 0.0);
      color = sample;
    }
    else if (dec.kind == DECORATION_KIND_FRAGMENT_SHADER) {
      let index = bitcast<u32>(dec.v0);
      switch(index) {
        // %MARK% USER FRAGMENT SHADER SWITCH SLOT
        default: { color = vec4f(1.0, 0.0, 0.0, 1.0); }
      }
    }
    else {
      color = vec4f(1.0, 0.0, 1.0, 1.0);
    }

    let premul = color.rgb * color.a;
    acc += vec4f(premul * acc.a, 0.0);
    acc.a *= 1.0 - color.a;

    if (acc.a < (1.0 / 255.0)) {
      acc.a = 0.0;
      break;
    }
  }

  acc.a = 1.0 - acc.a;
  return acc;
}

const MSAA_OFFSETS = array<vec2f, 4>(
  vec2f(-0.125, -0.375),
  vec2f( 0.375, -0.125),
  vec2f(-0.375,  0.125),
  vec2f( 0.125,  0.375),
);

struct StencilOut {
  @builtin(sample_mask) mask: u32,
  @location(0) color: vec4f,
}

@fragment
fn fs_stencil_main(in: VtxOut) -> StencilOut {
  let dx = dpdx(in.uv);
  let dy = dpdy(in.uv);

  var mask = 0xFu;
  if ((in.flags & RENDER_GEOMETRY_FLAG_STENCIL_LOOP_BLINN_QUADRATIC) != 0u) {
    mask = 0u;
    for (var s = 0u; s < 4u; s++) {
      let offset = MSAA_OFFSETS[s];
      let uv = in.uv + dx * offset.x + dy * offset.y;
      if (uv.x * uv.x - uv.y <= 0.0) {
        mask |= 1u << s;
      }
    }
  }

  return StencilOut(mask, vec4f(1.0));
}
