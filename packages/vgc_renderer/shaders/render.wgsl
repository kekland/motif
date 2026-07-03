#import "shared/cubic2.wgsl"
#import "shared/utils.wgsl"
#import "structs.wgsl"
#import "geometry.wgsl"
#import "brush/brush_circle.wgsl"

@group(0) @binding(0) var<uniform> u: Uniforms;
@group(0) @binding(1) var<storage, read> in_render_geometry: array<RenderGeometry>;
@group(0) @binding(2) var<storage, read> in_brush_data: array<BrushData>;
@group(0) @binding(3) var brush_textures: texture_2d_array<f32>;
@group(0) @binding(4) var brush_sampler: sampler;

struct VtxOut {
  @builtin(position) pos: vec4f,
  @location(0) frag_pos: vec2f,
  @location(1) stroke_uv: vec2f,
  @location(2) local_uv: vec2f,
  @location(3) weight: f32,
  @location(4) @interpolate(flat) instance_idx: u32,
}

@vertex
fn vs_main(
  @builtin(vertex_index) vtx_idx: u32,
  @builtin(instance_index) instance_idx: u32,
) -> VtxOut {
  let geom = in_render_geometry[instance_idx];

  var pos_screen = vec2f(0.0);
  var stroke_uv = vec2f(0.0);
  var uv = vec2f(0.0);

  if (geom.kind == RENDER_GEOMETRY_KIND_QUAD) {
    switch(vtx_idx) {
      case 0u, 3u: { pos_screen = geom.v0; uv = vec2f(0.0, 0.0); stroke_uv = vec2f(geom.arc_length.x, 0.0); }
      case 1u:     { pos_screen = geom.v1; uv = vec2f(1.0, 0.0); stroke_uv = vec2f(geom.arc_length.y, 0.0); }
      case 2u, 4u: { pos_screen = geom.v2; uv = vec2f(1.0, 1.0); stroke_uv = vec2f(geom.arc_length.y, 1.0); }
      case 5u:     { pos_screen = geom.v3; uv = vec2f(0.0, 1.0); stroke_uv = vec2f(geom.arc_length.x, 1.0); }
      default: {}
    };
  }
  else if (geom.kind == RENDER_GEOMETRY_KIND_STAMP) {
    let size = geom.arc_length.y - geom.arc_length.x;
    let u = STAMP_PADDING;
    let v = STAMP_PADDING;

    switch(vtx_idx) {
      case 0u, 3u: { pos_screen = geom.v0; uv = vec2f(-u, -v); stroke_uv = vec2f(geom.arc_length.x, 0.0); }
      case 1u:     { pos_screen = geom.v1; uv = vec2f(u, -v); stroke_uv = vec2f(geom.arc_length.y, 0.0); }
      case 2u, 4u: { pos_screen = geom.v2; uv = vec2f(u, v); stroke_uv = vec2f(geom.arc_length.y, size); }
      case 5u:     { pos_screen = geom.v3; uv = vec2f(-u, v); stroke_uv = vec2f(geom.arc_length.x, size); }
      default: {}
    };
  }

  let clip_x = (pos_screen.x / u.screen_size.x) * 2.0 - 1.0;
  let clip_y = 1.0 - (pos_screen.y / u.screen_size.y) * 2.0;

  var out: VtxOut;
  out.pos = vec4f(clip_x, clip_y, 0.0, 1.0);
  out.frag_pos = pos_screen;
  out.stroke_uv = stroke_uv;
  out.local_uv = uv;
  out.instance_idx = instance_idx;
  return out;
}

const FS_DEBUG_WIREFRAME = false;

@fragment
fn fs_main(in: VtxOut) -> @location(0) vec4f {
  let geom = in_render_geometry[in.instance_idx];

  if (FS_DEBUG_WIREFRAME) {
    let p = in.frag_pos;

    let e0 = geom.v1 - geom.v0; let w0 = p - geom.v0;
    let e1 = geom.v2 - geom.v1; let w1 = p - geom.v1;
    let e2 = geom.v3 - geom.v2; let w2 = p - geom.v2;
    let e3 = geom.v0 - geom.v3; let w3 = p - geom.v3;

    let pq0 = w0 - e0 * clamp(dot(w0, e0) / max(dot(e0, e0), 1.0e-8), 0.0, 1.0);
    let pq1 = w1 - e1 * clamp(dot(w1, e1) / max(dot(e1, e1), 1.0e-8), 0.0, 1.0);
    let pq2 = w2 - e2 * clamp(dot(w2, e2) / max(dot(e2, e2), 1.0e-8), 0.0, 1.0);
    let pq3 = w3 - e3 * clamp(dot(w3, e3) / max(dot(e3, e3), 1.0e-8), 0.0, 1.0);

    let d2 = min(min(dot(pq0, pq0), dot(pq1, pq1)), min(dot(pq2, pq2), dot(pq3, pq3)));
    let dist_to_edge = sqrt(d2);

    // --- DEBUG: Wireframe ---
    // Paint a 1-pixel red border around the quad edges
    if (dist_to_edge < 1.0) {
      return vec4f(1.0, 0.0, 0.0, 1.0); // Solid Red
    }

    // Paint a 1-pixel line at centerpoint
    let c0 = (geom.v0 + geom.v3) * 0.5;
    let c1 = (geom.v1 + geom.v2) * 0.5;
    let ec = c1 - c0;
    let wc = p - c0;
    let pqc = wc - ec * clamp(dot(wc, ec) / max(dot(ec, ec), 1.0e-8), 0.0, 1.0);
    let dist_to_center = length(pqc);

    if (dist_to_center < 1.0) {
      return vec4f(0.0, 1.0, 0.0, 1.0);  // solid green centerline
    }

    // Normal stub: perpendicular to the centerline, drawn from its midpoint.
    let center_mid = (c0 + c1) * 0.5;
    let tan = normalize(ec);
    let normal = vec2f(-tan.y, tan.x);
    let stub_len = 60.0;  // pixels
    let stub_end = center_mid + normal * stub_len;

    // Distance from p to the stub segment.
    let es = stub_end - center_mid;
    let ws = p - center_mid;
    let pqs = ws - es * clamp(dot(ws, es) / max(dot(es, es), 1.0e-8), 0.0, 1.0);
    let dist_to_stub = length(pqs);

    if (dist_to_stub < 1.0) {
      return vec4f(0.0, 0.5, 1.0, 1.0);
    }
  }

  if (geom.kind == RENDER_GEOMETRY_KIND_QUAD) {
    return vec4f(geom.color.rgb, geom.color.a);
  }
  else {
    // return vec4f(1.0);
    // let dist = brush_charcoal(in.local_uv, in.stroke_uv);
    // let dist = brush_cartoony(in.local_uv, in.stroke_uv, in.weight);
    // let dist = brush_standard(in.local_uv, in.stroke_uv, in.weight);
    let dist = brush_circle(in.local_uv);
    let pixel_aa = fwidth(dist);

    let alpha = smoothstep(0.5 - pixel_aa, 0.5 + pixel_aa, dist);
    if (alpha < 0.005) { discard; }

    return vec4f(geom.color.rgb, geom.color.a * alpha);
  }
}
