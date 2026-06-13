#import "shared/cubic2.wgsl"
#import "shared/utils.wgsl"
#import "structs.wgsl"
#import "geometry.wgsl"

@group(0) @binding(0) var<uniform> u: Uniforms;
@group(0) @binding(1) var<storage, read> in_render_geometry: array<RenderGeometry>;
@group(0) @binding(2) var<storage, read> in_brush_data: array<BrushData>;
@group(0) @binding(3) var brush_textures: texture_2d_array<f32>;
@group(0) @binding(4) var brush_sampler: sampler;

struct VtxOut {
  @builtin(position) pos: vec4f,
  @location(0) frag_pos: vec2f,
  @location(1) uv: vec2f, // arc distance, y
  @location(2) @interpolate(flat) instance_idx: u32,
}

@vertex
fn vs_main(
  @builtin(vertex_index) vtx_idx: u32,
  @builtin(instance_index) instance_idx: u32,
) -> VtxOut {
  let geom = in_render_geometry[instance_idx];

  var pos_screen = vec2f(0.0);
  var uv = vec2f(0.0);

  if (geom.kind == RENDER_GEOMETRY_KIND_QUAD) {
    switch(vtx_idx) {
      case 0u, 3u: { pos_screen = geom.v0; uv = vec2f(geom.arc_distance.x, 0.0); }
      case 1u: { pos_screen = geom.v1; uv = vec2f(geom.arc_distance.y, 0.0); }
      case 2u, 4u: { pos_screen = geom.v2; uv = vec2f(geom.arc_distance.y, 1.0); }
      case 5u: { pos_screen = geom.v3; uv = vec2f(geom.arc_distance.x, 1.0); }
      default: {}
    };
  }

  let clip_x = (pos_screen.x / u.screen_size.x) * 2.0 - 1.0;
  let clip_y = 1.0 - (pos_screen.y / u.screen_size.y) * 2.0;

  var out: VtxOut;
  out.pos = vec4f(clip_x, clip_y, 0.0, 1.0);
  out.frag_pos = pos_screen;
  out.uv = uv;
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

  let u_dist = in.uv.x;
  let v_dist = in.uv.y;

  let brush = in_brush_data[geom.brush_idx];
  let brush_length = max(brush.length, 1.0f);
  let brush_spacing = max(brush.spacing, 1.0f);
  let brush_texture_idx = brush.texture_idx;

  let base_uv_dx = dpdx(in.uv);
  let base_uv_dy = dpdy(in.uv);

  let grad_x = base_uv_dx * vec2f(1.0 / brush_length, 1.0);
  let grad_y = base_uv_dy * vec2f(1.0 / brush_length, 1.0);

  let pixel_aa = length(grad_x) + length(grad_y);

  let center_stamp_idx = floor(u_dist / brush_spacing);
  let overlap_radius = i32(min(ceil((brush_length * 0.5) / brush_spacing), 16.0));

  var accum_alpha = 0.0;
  for (var i = -overlap_radius; i <= overlap_radius; i++) {
    let stamp_idx = center_stamp_idx + f32(i);
    let stamp_center_u = stamp_idx * brush_spacing;

    let dist_from_center = u_dist - stamp_center_u;
    if (abs(dist_from_center) > brush_length * 0.5) { continue; }

    let local_u = (dist_from_center / brush_length) + 0.5;
    let local_v = v_dist;
    let sample_uv = vec2f(local_u, local_v);

    let sdf_dist = textureSampleGrad(brush_textures, brush_sampler, sample_uv, brush_texture_idx, grad_x, grad_y).r;

    let alpha = smoothstep(0.5 - pixel_aa, 0.5 + pixel_aa, sdf_dist);
    accum_alpha = accum_alpha + alpha - (accum_alpha * alpha);
  }

  if (accum_alpha < 0.005) { discard; }

  let color = geom.color;
  return vec4f(color.rgb, color.a * accum_alpha);
}
