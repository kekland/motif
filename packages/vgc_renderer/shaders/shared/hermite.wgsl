// Interpolate between two values using the hermite basis functions.
//
// Input points are of form (x, y, dy/dx), return value is (y, dy/dx).
fn hermite_interpolate(p0: vec3f, p1: vec3f, t: f32) -> vec2f {
  let h = p1.x - p0.x;
  if (h < 1.0e-6) { return vec2f(p0.yz); }

  let u = (t - p0.x) / h;
  let u2 = u * u;
  let one_minus_u = 1.0 - u;
  let one_minus_u2 = one_minus_u * one_minus_u;

  let h00 = (1.0 + 2.0 * u) * one_minus_u2;
  let h10 = u * one_minus_u2;
  let h01 = u2 * (3.0 - 2.0 * u);
  let h11 = u2 * (u - 1.0);
  
  let v = h00 * p0.y + h10 * h * p0.z + h01 * p1.y + h11 * h * p1.z;

  let dh00 = 6.0 * u * (u - 1.0);
  let dh10 = (1.0 - u) * (1.0 - 3.0 * u);
  let dh01 = -dh00;
  let dh11 = u * (3.0 * u - 2.0);

  let dv_du = dh00 * p0.y + dh10 * h * p0.z + dh01 * p1.y + dh11 * h * p1.z;
  let dv_dt = dv_du / h;

  return vec2f(v, dv_dt);
}
