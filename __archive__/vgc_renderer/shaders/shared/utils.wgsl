// Pads the bounding box by [pad] pixels in all directions.
fn bbox_pad(bbox: vec4f, pad: f32) -> vec4f {
  return vec4f(bbox.xy - vec2f(pad), bbox.zw + vec2f(pad));
}

// Returns true if the two bounding boxes intersect.
fn bbox_intersects(b1: vec4f, b2: vec4f) -> bool {
  return b1.x <= b2.z && b1.z >= b2.x && b1.y <= b2.w && b1.w >= b2.y;
}

// Returns true if the point [p] is inside the bounding box [bbox].
fn bbox_contains(bbox: vec4f, p: vec2f) -> bool {
  return p.x >= bbox.x && p.x <= bbox.z && p.y >= bbox.y && p.y <= bbox.w;
}

const PI = 3.14159265358979323;
const TWO_PI = 6.28318530717958646;

fn vec2_transform(v: vec2f, m: mat4x4f) -> vec2f {
  let res = m * vec4f(v, 0.0, 1.0);
  return res.xy;
}
