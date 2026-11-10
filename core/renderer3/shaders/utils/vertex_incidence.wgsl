#import "../_bindings.wgsl"
#import "../math/math.wgsl"
#import "limits.wgsl"
#import "world_utils.wgsl"

struct VertexIncident {
  tangent: vec2f,
  angle: f32,
  edge_index: u32,
}

fn get_vertex_incidence(index: u32, pos: vec2f, out: ptr<function, array<VertexIncident, MAX_VERTEX_VALENCE>>) -> u32 {
  var n = 0u;
  var current_cv = read_vertex_topology(index).disk_start;
  let start_cv = current_cv;
  loop {
    if (current_cv == NONE || n == MAX_VERTEX_VALENCE) { break; }
    let cv = read_covertex_topology(current_cv);
    let edge = cv.edge;
    let is_start = cv.is_start == 1u;
    var tangent = read_covertex_tangent_world(index, current_cv);
    if (dot(tangent, tangent) < 1e-6) {
      let cubic = read_edge_cubic_world(edge);
      tangent = select(cubic.p2 - cubic.p3, cubic.p1 - cubic.p0, is_start);
      if (dot(tangent, tangent) < 1e-6) { tangent = select(cubic.p1 - cubic.p3, cubic.p2 - cubic.p0, is_start); }
      if (dot(tangent, tangent) < 1e-6) { tangent = select(cubic.p0 - cubic.p3, cubic.p3 - cubic.p0, is_start); }
    }

    tangent = normalize(tangent);
    (*out)[n] = VertexIncident(tangent, atan2(tangent.y, tangent.x), edge);
    n++;
    current_cv = cv.next;
  }

  // sort angles
  for (var i = 1u; i < n; i++) {
    let k = (*out)[i];
    var j = i;
    while (j > 0u && (*out)[j - 1u].angle > k.angle) {
      (*out)[j] = (*out)[j - 1u];
      j--;
    }

    (*out)[j] = k;
  }

  return n;
}

fn get_vertex_join(valence: u32, incident: ptr<function, array<VertexIncident, MAX_VERTEX_VALENCE>>, out: ptr<function, array<VertexIncident, 2>>) -> f32 {
  for (var i = 0u; i < valence; i++) {
    let inc0 = (*incident)[i];
    let inc1 = (*incident)[(i + 1) % valence];
    var gap = inc1.angle - inc0.angle;
    if (gap <= 0.0) { gap += 2 * PI; }
    if (gap <= PI) { continue; }

    (*out)[0] = inc0;
    (*out)[1] = inc1;
    return gap;
  }

  return -1.0;
}