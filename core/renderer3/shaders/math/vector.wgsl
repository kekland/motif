fn vec2_cross(a: vec2f, b: vec2f) -> f32 {
  return a.x * b.y - a.y * b.x;
}

fn vec2_orthogonal(v: vec2f) -> vec2f {
  return vec2f(-v.y, v.x);
}

fn vec2_safe_tangent(tan: vec2f, fallback: vec2f) -> vec2f {
  return select(normalize(tan), normalize(fallback), dot(tan, tan) < 1e-9);
}

fn vec2_transform(m: mat4x4f, v: vec2f) -> vec2f {
  return (m * vec4f(v, 0.0, 1.0)).xy;
}

const BBOX_INV_INF = vec4f(1e30, 1e30, -1e30, -1e30);

fn bbox_hull_point(bbox: vec4f, p: vec2f) -> vec4f {
  return vec4f(
    min(bbox.xy, p),
    max(bbox.zw, p)
  );
}

fn bbox_hull_bbox(bbox: vec4f, other: vec4f) -> vec4f {
  return vec4f(
    min(bbox.xy, other.xy),
    max(bbox.zw, other.zw)
  );
}

fn bbox_inflate(bbox: vec4f, dx: f32, dy: f32) -> vec4f {
  return vec4f(
    bbox.x - dx,
    bbox.y - dy,
    bbox.z + dx,
    bbox.w + dy
  );
}

fn bbox_size(bbox: vec4f) -> vec2f {
  return bbox.zw - bbox.xy;
}