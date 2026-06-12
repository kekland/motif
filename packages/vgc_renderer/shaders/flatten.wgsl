#import "shared/cubic2.wgsl"
#import "shared/hermite.wgsl"
#import "shared/utils.wgsl"
#import "structs.wgsl"
#import "geometry.wgsl"

const MAX_SPLITS: u32 = 32u;

struct DrawIndirectArgs {
  vertex_count: u32,
  instance_count: atomic<u32>,
  first_vertex: u32,
  first_instance: u32,
};

@group(0) @binding(0) var<uniform> u: Uniforms;
@group(0) @binding(1) var<storage, read> in_edge_data: array<EdgeData>;
@group(0) @binding(2) var<storage, read> in_cubic_data: array<CubicData>;
@group(0) @binding(3) var<storage, read> in_edge_weight_samples: array<vec3f>;
@group(0) @binding(5) var<storage, read_write> out_draw_args: DrawIndirectArgs;
@group(0) @binding(6) var<storage, read_write> out_render_geometry: array<RenderGeometry>;

var<private> cubic: Cubic2;
var<private> cubic_start_dist: f32;
var<private> cubic_end_dist: f32;
var<private> edge_weight_span: vec2u;
var<private> edge_width: f32;
var<private> edge_idx: u32;
var<private> edge_z_index: u32;
var<private> color: vec4f;

fn _emit_quad(v0: vec2f, v1: vec2f, v2: vec2f, v3: vec2f) {
  let idx = atomicAdd(&out_draw_args.instance_count, 1u);
  if (idx >= arrayLength(&out_render_geometry)) { return; }

  let _v0 = vec2_transform(v0, u.transform);
  let _v1 = vec2_transform(v1, u.transform);
  let _v2 = vec2_transform(v2, u.transform);
  let _v3 = vec2_transform(v3, u.transform);

  out_render_geometry[idx] = render_geometry_create_quad(_v0, _v1, _v2, _v3, color, edge_z_index);
}

fn _temp_emit_join(pos: vec2f, r: f32) {
  let pivot_pos = pos;
  let scale = length(u.transform[0].xy);
  let screen_r = r * scale;
  let steps = max(16u, u32(ceil(screen_r * 0.25)));
  let da = TWO_PI / f32(steps);

  var prev_outer = pos + vec2f(r, 0.0);
  for (var i = 1u; i <= steps; i++) {
    let angle = f32(i) * da;
    let outer = pos + vec2f(cos(angle), sin(angle)) * r;

    _emit_quad(prev_outer, outer, pivot_pos, pivot_pos);
    prev_outer = outer;
  }
}

fn _emit_join(pos: vec2f, r: f32) {
  // let idx = atomicAdd(&out_draw_args.instance_count, 1u);
  // if (idx >= arrayLength(&out_render_geometry)) { return; }

  // let _pos = vec2_transform(pos, u.transform);
  // out_render_geometry[idx] = render_geometry_create_circle(_pos, r, edge_color, edge_z_index);
  _temp_emit_join(pos, r);
}

fn _emit_cap(pos: vec2f, tan: vec2f, r: f32, dr_da: f32) {
  let scale = length(u.transform[0].xy);
  let screen_r = r * scale;

  let err = min(u.tolerance, screen_r * 0.999);
  let theta = 2.0 * acos(1.0 - err / screen_r);
  let steps = clamp(u32(ceil(PI / theta)), 4u, 128u);

  let normal = vec2f(-tan.y, tan.x);
  let safe_dr = clamp(dr_da, -0.99, 0.99);

  let p0 = pos - normal * r;
  let p3 = pos + normal * r;

  let v0 = normalize(tan - safe_dr * normal);
  let v3 = normalize(tan + safe_dr * normal);

  let handle_len = 1.333333 * r;
  let p1 = p0 + v0 * handle_len;
  let p2 = p3 + v3 * handle_len;

  let cap_bezier = Cubic2(p0, p1, p2, p3);
  let start_idx = atomicAdd(&out_draw_args.instance_count, u32(steps));
  let max_idx = arrayLength(&out_render_geometry);

  var prev_outer = p0;
  for (var i = 1u; i <= steps; i++) {
    let global_idx = start_idx + i - 1u;
    if (global_idx >= max_idx) { break; }

    let t = f32(i) / f32(steps);
    let outer = cubic2_pos(cap_bezier, t);

    let _v0 = vec2_transform(prev_outer, u.transform);
    let _v1 = vec2_transform(outer, u.transform);
    let _p = vec2_transform(pos, u.transform);

    out_render_geometry[global_idx] = render_geometry_create_quad(_v0, _v1, _p, _p, color, edge_z_index);
    prev_outer = outer;
  }
}

// fn _emit_cusp_bridge(_t0: f32, _t1: f32, _a0: f32, _a1: f32) {
//   // let snapped_bounds = _snap_to_weight_samples(edge_weight_span, _a0, _a1);
//   let _a_mid = (_a0 + _a1) * 0.5;

//   let _pt0 = cubic2_pos_tan(cubic, _t0);
//   let _pt1 = cubic2_pos_tan(cubic, _t1);
//   let _speed0 = length(_pt0.zw);
//   let _speed1 = length(_pt1.zw);
//   let _tan0 = normalize(_pt0.zw);
//   let _tan1 = normalize(_pt1.zw);
//   let _local_w = _eval_weight(edge_weight_span, _a_mid).x;
//   let _r = _local_w * edge_width * 0.5;
//   let bridge_radius = _r * 0.2;
//   let cos_theta = clamp(dot(-_tan0, _tan1), -0.999, 0.999);
//   let tan_half_angle = sqrt((1.0 - cos_theta) / (1.0 + cos_theta));
//   var rollback = bridge_radius * tan_half_angle;

//   let available_arc_before = cubic_start_dist + cubic2_distance_at_t(cubic, _t0);
//   let available_arc_after = cubic_end_dist - (cubic_start_dist + cubic2_distance_at_t(cubic, _t1));
//   let max_safe_rollback = min(available_arc_before, available_arc_after);
//   rollback = min(rollback, max_safe_rollback);

//   let dt0 = rollback / max(_speed0, 1.0e-5);
//   let dt1 = rollback / max(_speed1, 1.0e-5);
//   let t0 = max(0.0, _t0 - dt0);
//   let t1 = min(1.0, _t1 + dt1);
//   let dt = t1 - t0;

//   let a0 = cubic_start_dist + cubic2_distance_at_t(cubic, t0);
//   let a1 = cubic_start_dist + cubic2_distance_at_t(cubic, t1);

//   let local_a0 = a0 - cubic_start_dist;
//   let local_a1 = a1 - cubic_start_dist;

//   let pos_tan0 = cubic2_pos_tan(cubic, t0);
//   let pos_tan1 = cubic2_pos_tan(cubic, t1);
//   let p0 = pos_tan0.xy;
//   let p1 = pos_tan1.xy;

//   let raw_tan0 = pos_tan0.zw;
//   let raw_tan1 = pos_tan1.zw;
//   let speed0 = length(raw_tan0);
//   let speed1 = length(raw_tan1);

//   let tan0 = normalize(raw_tan0);
//   let tan1 = normalize(raw_tan1);

//   let n0 = vec2f(-tan0.y, tan0.x);
//   let n1 = vec2f(-tan1.y, tan1.x);

//   let k0 = cubic2_signed_curvature(cubic, t0);
//   let k1 = cubic2_signed_curvature(cubic, t1);

//   let w0 = _eval_weight(edge_weight_span, a0);
//   let w1 = _eval_weight(edge_weight_span, a1);

//   let r0 = w0.x * edge_width * 0.5;
//   let r1 = w1.x * edge_width * 0.5;

//   let dr_dt0 = w0.y * edge_width * 0.5 * speed0;
//   let dr_dt1 = w1.y * edge_width * 0.5 * speed1;

//   let side = sign(k0);
//   let inner_n0 = n0 * side;
//   let inner_n1 = n1 * side;

//   let env_vel0 = speed0 * (1.0 - r0 * abs(k0)) * tan0 + dr_dt0 * inner_n0;
//   let env_vel1 = speed1 * (1.0 - r1 * abs(k1)) * tan1 + dr_dt1 * inner_n1;

//   let inner_v0 = p0 + inner_n0 * r0;
//   let inner_v3 = p1 + inner_n1 * r1;

//   let dist = dt / 3.0;
//   let h0 = env_vel0 * dist;
//   let h1 = env_vel1 * dist;

//   let gap_dist = length(inner_v3 - inner_v0);
//   let max_handle = gap_dist / 3.0;

//   let scale0 = min(1.0, max_handle / max(length(h0), 1.0e-5));
//   let scale1 = min(1.0, max_handle / max(length(h1), 1.0e-5));

//   let inner_v1 = inner_v0 + h0 * scale0;
//   let inner_v2 = inner_v3 - h1 * scale1;

//   // {
//   //   _emit_join(inner_v0, 10.0);
//   //   _emit_join(inner_v3, 10.0);
//   //   _emit_join(inner_v1, 5.0);
//   //   _emit_join(inner_v2, 5.0);
//   // }

//   let outer_piece = cubic2_piece_at(cubic, t0, t1);
//   let outer_screen = cubic2_transform(outer_piece, u.transform);

//   let inner_bridge = Cubic2(inner_v0, inner_v1, inner_v2, inner_v3);
//   let inner_screen = cubic2_transform(inner_bridge, u.transform);

//   let outer_steps = cubic2_wang(outer_screen, u.tolerance);
//   let inner_steps = cubic2_wang(inner_screen, u.tolerance);

//   let steps_f = max(outer_steps, inner_steps);
//   let iterations = clamp(u32(ceil(steps_f)), 2u, 64u);

//   var prev_p: vec2f;
//   var prev_inner_v: vec2f;

//   for (var j = 0u; j <= iterations; j++) {
//     let f = f32(j) / f32(iterations);
//     let t = mix(t0, t1, f);
//     let p = cubic2_pos(cubic, t);
//     let inner_v = cubic2_pos(inner_bridge, f);

//     if (j > 0u) {
//       let v0 = prev_p;
//       let v1 = prev_inner_v;
//       let v2 = inner_v;
//       let v3 = p;

//       _emit_quad(v0, v1, v2, v3, vec4f(1.0, 1.0, 0.0, 0.5));
//     }

//     prev_p = p;
//     prev_inner_v = inner_v;
//   }
// }

fn _eval_weight(span: vec2u, t: f32) -> vec2f {
  let offset = span.x; 
  let count = span.y;

  if (count == 0u) { return vec2f(1.0, 0.0); }
  if (count == 1u) { return vec2f(in_edge_weight_samples[offset].y, in_edge_weight_samples[offset].z); }

  let first_sample = in_edge_weight_samples[offset];
  if (t <= first_sample.x) { return vec2f(first_sample.y, first_sample.z); }

  let last_sample = in_edge_weight_samples[offset + count - 1u];
  if (t >= last_sample.x) { return vec2f(last_sample.y, last_sample.z); }

  var l = 0u;
  var r = count - 1u;
  while (l < r) {
    let m = (l + r) / 2u;
    let sample = in_edge_weight_samples[offset + m];
    if (t <= sample.x) { r = m; }
    else { l = m + 1u; }
  }

  let s0 = in_edge_weight_samples[offset + l - 1u];
  let s1 = in_edge_weight_samples[offset + l];
  // return vec2f(
  //   mix(s0.y, s1.y, (t - s0.x) / (s1.x - s0.x)),
  //   mix(s0.z, s1.z, (t - s0.x) / (s1.x - s0.x)),
  // );
  return hermite_interpolate(s0, s1, t);
}

fn _compute_point_radii(segment: Cubic2, t: f32, weight_sample: vec2f) -> array<vec2f, 4> {
  let pos_tan = cubic2_pos_tan(segment, t);
  let pos = pos_tan.xy;
  let base_tan = normalize(pos_tan.zw);
  let normal = vec2f(-base_tan.y, base_tan.x);

  let target_r = weight_sample.x * edge_width * 0.5;
  let k = cubic2_signed_curvature(segment, t);
  let inner_side = sign(k);

  let max_safe_r = 1.0 / max(abs(k), 1.0e-5);
  let safe_r = min(target_r, max_safe_r);

  let r_left = select(target_r, safe_r, inner_side > 0.0);
  let r_right = select(target_r, safe_r, inner_side < 0.0);

  let v_left = pos + r_left * normal;
  let v_right = pos - r_right * normal;

  return array<vec2f, 4>(pos, v_left, v_right, vec2f(0.0));
}

struct StackEntry {
  t_span: vec2f,
  arc_span: vec2f,
  weight_span: vec4f,
}

@compute @workgroup_size(64)
fn main(@builtin(global_invocation_id) global_idx: vec3u) {
  let idx = global_idx.x;
  if (idx >= u.cubic_count) { return; }

  let scale = length(u.transform[0].xy);

  // Fill in the global variables
  let cubic_data = in_cubic_data[idx];
  cubic = cubic_data.cubic;

  let edge_data = in_edge_data[cubic_data.edge_idx];
  edge_weight_span = edge_data.weight_span;
  edge_width = edge_data.width;
  edge_idx = cubic_data.edge_idx;
  edge_z_index = cubic_data.edge_idx;
  color = vec4f(edge_data.color.rgb, edge_data.color.a * cubic_data.opacity);

  // Compute split points
  var splits: array<f32, MAX_SPLITS>;
  var splits_start_dist: array<f32, MAX_SPLITS>;
  var n_splits = 0u;
  splits[0] = 0.0; splits_start_dist[0] = 0.0; n_splits = 1u;

  // Split at inflections and extrema.
  // key_distances will hold the arc length for each split piece.
  var key_distances: array<f32, 7>;
  var key_distance_count = 0u;
  {
    let key_points = cubic2_key_points(cubic);
    
    var prev_t = 0.0;
    var prev_dist = 0.0;

    for (var i = 0u; i < key_points.count; i++) {
      let t = key_points.t[i];
      splits[n_splits] = t;

      let c = cubic2_piece_at(cubic, prev_t, t);
      let dist = prev_dist + cubic2_arc_length_approximate(c);
      key_distances[i] = dist;
      splits_start_dist[n_splits] = dist;
      prev_dist = dist;
      prev_t = t;

      n_splits++;
      key_distance_count++;
    }
    
    if (1.0 - prev_t > 1.0e-4) {
      let c = cubic2_piece_at(cubic, prev_t, 1.0);
      key_distances[key_points.count] = prev_dist + cubic2_arc_length_approximate(c);
      key_distance_count++;
    }
  }

  cubic_start_dist = cubic_data.edge_start_arc_length;
  cubic_end_dist = cubic_start_dist + key_distances[key_distance_count - 1];

  // Split at weight anchors
  var max_weight = max(
    _eval_weight(edge_weight_span, cubic_start_dist).x,
    _eval_weight(edge_weight_span, cubic_end_dist).x
  );

  {
    let edge_weight_offset = edge_weight_span.x;
    let edge_weight_count = edge_weight_span.y;

    var current_key_idx = 0u;
    var current_key_start_dist = cubic_start_dist;
    var current_key_end_dist = cubic_start_dist + key_distances[0];

    for (var i = 0u; i < edge_weight_count && n_splits < MAX_SPLITS - 1u; i++) {
      let sample = in_edge_weight_samples[edge_weight_offset + i];

      // Check if we're within our cubic's arc length range
      if (sample.x > cubic_start_dist + 1.0e-4 && sample.x < cubic_end_dist - 1.0e-4) {
        max_weight = max(max_weight, sample.y);

        // Iterate our key points until we find the right segment for this weight sample
        while (sample.x > current_key_end_dist && current_key_idx + 1u < key_distance_count) {
          current_key_idx++;
          current_key_start_dist = current_key_end_dist;
          current_key_end_dist = cubic_start_dist + key_distances[current_key_idx];
        }
        
        if (current_key_idx >= key_distance_count) { break; }

        let local_t = cubic2_distance_to_t(cubic, sample.x - cubic_start_dist);
        if (local_t > 1.0e-4 && local_t < 1.0 - 1.0e-4) {
          splits[n_splits] = local_t;
          splits_start_dist[n_splits] = sample.x - cubic_start_dist;
          n_splits++;
        }
      }
    }
  }

  splits[n_splits] = 1.0; splits_start_dist[n_splits] = cubic_end_dist - cubic_start_dist; n_splits++;

  // Cull if off-screen
  let transformed_cubic = cubic2_transform(cubic, u.transform);
  let transformed_padded_bbox = bbox_pad(cubic2_bbox(transformed_cubic), edge_width * scale * 0.5 * max_weight);
  let screen_bbox = vec4f(0.0, 0.0, f32(u.screen_size.x), f32(u.screen_size.y));
  if (!bbox_intersects(transformed_padded_bbox, screen_bbox)) { return; }

  // Sort splits
  {
    for (var i = 1u; i < n_splits; i++) {
      let k = splits[i];
      let k_start_dist = splits_start_dist[i];
      var j = i;
      while (j > 0u && splits[j - 1u] > k) {
        splits[j] = splits[j - 1u];
        splits_start_dist[j] = splits_start_dist[j - 1u];
        j--;
      }
      splits[j] = k;
      splits_start_dist[j] = k_start_dist;
    }
  }

  // var in_cusp = false;
  // var cusp_start_t = 0.0;
  // var cusp_start_arc = 0.0;
  // var cusp_prev_left = vec2f(0.0);
  // var cusp_prev_right = vec2f(0.0);

  let initial_w = _eval_weight(edge_weight_span, cubic_start_dist);
  let first_point = _compute_point_radii(cubic, 0.0, initial_w);
  var prev_pos = first_point[0];
  var prev_left = first_point[1];
  var prev_right = first_point[2];

  // Emit geometry for each split segment
  let dynamic_tolerance = u.tolerance / clamp(max(1.0, max_weight * edge_width * 0.05), 1.0, 3.0);
  for (var s = 0u; s < n_splits - 1u; s++) {
    let segment_t0 = splits[s];
    let segment_t1 = splits[s + 1u];
    if (segment_t1 - segment_t0 < 1.0e-5) { continue; }

    let segment_arc_len_start = cubic_start_dist + splits_start_dist[s];
    let segment_arc_len_end = cubic_start_dist + splits_start_dist[s + 1u];

    let segment_w_start = _eval_weight(edge_weight_span, segment_arc_len_start);
    let segment_w_end = _eval_weight(edge_weight_span, segment_arc_len_end);

    var stack: array<StackEntry, 32>;
    var stack_cursor = 0u;

    stack[stack_cursor] = StackEntry(
      vec2f(segment_t0, segment_t1),
      vec2f(segment_arc_len_start, segment_arc_len_end),
      vec4f(segment_w_start, segment_w_end),
    );
    stack_cursor++;

    while (stack_cursor > 0u) {
      stack_cursor--;
      let state = stack[stack_cursor];
      let t0 = state.t_span.x;
      let t1 = state.t_span.y;
      let t_mid = (t0 + t1) * 0.5;

      let arc_start = state.arc_span.x;
      let arc_end = state.arc_span.y;
      let arc_mid = arc_start + cubic2_arc_length_approximate(cubic2_piece_at(cubic, t0, t_mid));

      let w_start = state.weight_span.xy;
      let w_end = state.weight_span.zw;
      let w_mid = _eval_weight(edge_weight_span, arc_mid);

      let sub_segment = cubic2_piece_at(cubic, t0, t1);
      let transformed_sub_segment = cubic2_transform(sub_segment, u.transform);
      let is_geom_flat = cubic2_wang(transformed_sub_segment, dynamic_tolerance) <= 1.0;

      var is_width_flat = true;
      if (is_geom_flat) {
        let arc_span = max(arc_end - arc_start, 1.0e-5);
        let arc_ratio = (arc_mid - arc_start) / arc_span;
        let expected_w_mid = mix(w_start.x, w_end.x, arc_ratio);
        let deviation = abs(w_mid.x - expected_w_mid) * edge_width * scale * 0.5;
        is_width_flat = deviation < u.tolerance;
      }

      if ((is_geom_flat && is_width_flat) || stack_cursor >= 30u) {
        // Emit quad for this segment
        let end_pos = cubic2_pos(cubic, t1);
        let point = _compute_point_radii(cubic, t1, w_end);

        let pos = point[0];
        let left = point[1];
        let right = point[2];

        // let base_tan = normalize(cubic2_tan(cubic, t1));
        // let left_edge_vel = left - prev_left;
        // let right_edge_vel = right - prev_right;

        // let is_left_cusp = dot(base_tan, left_edge_vel) < 0.0;
        // let is_right_cusp = dot(base_tan, right_edge_vel) < 0.0;
        // let is_cusp = is_left_cusp || is_right_cusp;

        // if (is_cusp) {
        //   if (!in_cusp) {
        //     in_cusp = true;
        //     cusp_start_t = t0;
        //     cusp_start_arc = arc_start;
        //     cusp_prev_left = prev_left;
        //     cusp_prev_right = prev_right;
        //   }
        // }
        // else {
        //   if (in_cusp) {
        //     // _emit_cusp_bridge(cusp_start_t, t0, cusp_start_arc, arc_start);
        //     in_cusp = false;
        //   }
        // }
        
        var color = vec4f(0.0, 1.0, 0.0, arc_end / cubic_end_dist);

        _emit_quad(prev_left, left, right, prev_right);
        prev_pos = pos;
        prev_left = left;
        prev_right = right;
      }
      else {
        stack[stack_cursor] = StackEntry(
          vec2f(t_mid, t1),
          vec2f(arc_mid, arc_end),
          vec4f(w_mid, w_end)
        );
        stack_cursor++;

        stack[stack_cursor] = StackEntry(
          vec2f(t0, t_mid),
          vec2f(arc_start, arc_mid),
          vec4f(w_start, w_mid)
        );
        stack_cursor++;
      }
    }
  }

  let edge_segment_idx = cubic_data.edge_segment_idx;
  let edge_segment_count = cubic_data.edge_segment_count;
  
  let is_first_segment = edge_segment_idx == 0u;
  let is_last_segment = edge_segment_idx == edge_segment_count - 1u;
  
  // Start cap
  if (is_first_segment) {
    let pos_tan = cubic2_pos_tan(cubic, 0.0);
    let pos = pos_tan.xy;
    let tan = normalize(pos_tan.zw);

    let w = _eval_weight(edge_weight_span, cubic_start_dist) * edge_width * 0.5;
    _emit_cap(pos, -tan, w.x, w.y);
  }

  // End cap
  if (is_last_segment) {
    let pos_tan = cubic2_pos_tan(cubic, 1.0);
    let pos = pos_tan.xy;
    let tan = normalize(pos_tan.zw);
    let w = _eval_weight(edge_weight_span, cubic_end_dist) * edge_width * 0.5;
    _emit_cap(pos, tan, w.x, w.y);
  }

  // Joins
  if (!is_last_segment) {
    let next_cubic = in_cubic_data[idx + 1u].cubic;

    let pos = cubic2_pos(cubic, 1.0);
    let tan_in = normalize(cubic2_tan(cubic, 1.0));
    let tan_out = normalize(cubic2_tan(next_cubic, 0.0));

    if (dot(tan_in, tan_out) < 0.99999) {
      let r = _eval_weight(edge_weight_span, cubic_end_dist).x * edge_width * 0.5;
      _emit_join(pos, r);
    }
  }
}