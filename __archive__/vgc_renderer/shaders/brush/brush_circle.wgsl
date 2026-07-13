fn brush_circle(uv: vec2f) -> f32 {
  let dist = length(uv - vec2f(0.5, 0.5));
  return smoothstep(0.5, 0.45, dist);
}

fn brush_chisel(uv: vec2f) -> f32 {
  // 1. Remap UVs from [0.0, 1.0] to [-1.0, 1.0] with center at 0,0
  let p = (uv - vec2f(0.5, 0.5)) * 2.0;

  // 2. Rotate the coordinates by 45 degrees
  let c = 0.707106; // cos(45)
  let s = 0.707106; // sin(45)
  let rotated_p = vec2f(p.x * c - p.y * s, p.x * s + p.y * c);

  // 3. Mathematical Box SDF
  let half_size = vec2f(0.8, 0.15); // Wide and thin
  let corner_radius = 0.05;
  
  let d = abs(rotated_p) - half_size + vec2f(corner_radius);
  let box_sdf = length(max(d, vec2f(0.0))) + min(max(d.x, d.y), 0.0) - corner_radius;

  // 4. Convert to your fragment shader's format (0.5 is edge)
  return 0.5 - box_sdf;
}

fn hash21(p: vec2f) -> f32 {
  return fract(sin(dot(p, vec2f(12.9898, 78.233))) * 43758.5453123);
}

fn value_noise(p: vec2f) -> f32 {
  let i = floor(p);
  let f = fract(p);

  // Smooth Hermite interpolation
  let u = f * f * (3.0 - 2.0 * f);

  let a = hash21(i + vec2f(0.0, 0.0));
  let b = hash21(i + vec2f(1.0, 0.0));
  let c = hash21(i + vec2f(0.0, 1.0));
  let d = hash21(i + vec2f(1.0, 1.0));

  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

fn brush_charcoal(local_uv: vec2f, stroke_uv: vec2f) -> f32 {
  let circle_sdf = length(local_uv) - 0.8;

  let smudge_scale = 0.9;
  let n = value_noise(stroke_uv * smudge_scale);

  let grain = (n - 0.5) * 0.6;

  let streak_scale = 0.66;
  let streaks = sin(stroke_uv.x * streak_scale) * 0.05;

  let noisy_sdf = circle_sdf + grain + streaks;

  return 0.5 - noisy_sdf;
}

fn brush_stiff_acrylic(uv: vec2f) -> f32 {
  let p = (uv - vec2f(0.5, 0.5)) * 2.0;

  // 1. Base flat brush shape
  let half_size = vec2f(0.25, 0.85);
  let d = abs(p) - half_size;
  let box_dist = length(max(d, vec2f(0.0))) + min(max(d.x, d.y), 0.0);

  // 2. Bristle Grooves
  // We use high-frequency sine waves along the Y-axis.
  // Because they are purely Y-based, they will drag seamlessly along the X-axis!
  let bristles = sin(p.y * 35.0) * 0.04 + sin(p.y * 80.0) * 0.02;

  // 3. Add some macro-clumping so the edges aren't perfectly straight
  let clumping = sin(p.y * 5.0) * 0.05;

  return 0.5 - (box_dist + bristles + clumping);
}

fn brush_crisp_inker(uv: vec2f, weight: f32) -> f32 {
  // 1. Remap UVs to a centered [-1.0, 1.0] coordinate space
  let p = uv * 2.0 - 1.0;

  // 2. Map the pressure (weight) to a physical radius
  let w = clamp(weight, 0.0, 1.0);
  
  // At lowest pressure, radius is 0.02 (hairline).
  // At highest pressure, radius is 0.45 (massive overlap).
  let r = mix(0.02, 0.45, w);

  // 3. Stretch the shape slightly along the X-axis (tangent)
  // This turns our dots into overlapping ovals, ensuring the stroke 
  // doesn't look dotted if your spacing parameter is slightly wide.
  let p_stretched = vec2f(p.x * 0.5, p.y);

  // 4. Construct the Brush via SDF Union ( min() )
  var d = 100.0;

  // Center hair (Thickest)
  d = min(d, length(p_stretched - vec2f(0.0, 0.0)) - r);

  // Inner hairs (Slightly smaller to give the brush a rounded profile)
  d = min(d, length(p_stretched - vec2f(0.0, -0.3)) - (r * 0.85));
  d = min(d, length(p_stretched - vec2f(0.0, 0.3)) - (r * 0.85));

  // Outer hairs (Thinnest)
  d = min(d, length(p_stretched - vec2f(0.0, -0.6)) - (r * 0.55));
  d = min(d, length(p_stretched - vec2f(0.0, 0.6)) - (r * 0.55));

  // 5. Convert to your fragment shader's threshold format (0.5 is the edge)
  return 0.5 - d;
}

fn brush_wet_acrylic(uv: vec2f, weight: f32) -> f32 {
  // Remap to [-1, 1].
  // Because of our tangent rotation: 
  // +X is forward (leading edge), -X is backward (trailing edge).
  let p = uv * 2.0 - 1.0;
  let w = clamp(weight, 0.01, 1.0);

  // 1. The Paint Drop (Leading Edge)
  // A smooth circle shifted slightly forward to act as the heavy bead of wet paint.
  let drop_dist = length(p - vec2f(0.2, 0.0));

  // 2. The Clumped Bristles (Trailing Edge)
  // Wet hairs stick together. We use low-frequency sine waves to create 
  // thick, smooth groups of bristles rather than high-frequency noise.
  let clumps = sin(p.y * 12.0) * 0.1 + sin(p.y * 28.0) * 0.05;
  
  // A V-shape that flares out and fades toward the back of the brush
  let trail_dist = abs(p.y) - (p.x * 0.5) + clumps;

  // 3. Directional Blending
  // If we are at the front of the stamp, it's a smooth drop. 
  // If we are at the back, it breaks into streaky trails.
  let front_mask = smoothstep(-0.3, 0.3, p.x);
  let shape_sdf = mix(trail_dist, drop_dist, front_mask);

  // 4. Pressure Dynamics
  // Pressing hard gives a massive solid radius, pressing light leaves thin streaks
  let radius = mix(0.15, 0.7, w);

  // 5. Convert to your Fragment Shader threshold (0.5 is the exact edge)
  return 0.5 - (shape_sdf - radius);
}

fn brush_impressionist(local_uv: vec2f, stroke_uv: vec2f, pressure: f32) -> f32 {
  // 1. Organic Shape Wobble (Destroys the perfect circle outline)
  // We generate a slow, low-frequency noise purely to alter the brush's footprint.
  let wobble_scale = vec2f(0.015, 0.015);
  let shape_wobble = value_noise(stroke_uv * wobble_scale);
  
  // This smoothly expands and contracts the base radius by +/- 0.25 units
  let radius_offset = (shape_wobble - 0.5) * 0.5; 
  
  let width_squish = mix(1.2, 0.9, pressure);
  let p = vec2f(local_uv.x, local_uv.y * width_squish);
  
  // The base SDF now has an undulating, liquid boundary instead of a perfect curve.
  let base_sdf = length(p) - (1.0 + radius_offset);

  // 2. Domain Warping
  let warp_scale = vec2f(0.02, 0.05);
  let warp = value_noise(stroke_uv * warp_scale);
  let warp_offset = (warp - 0.5) * 15.0; 
  let warped_uv = vec2f(stroke_uv.x, stroke_uv.y + warp_offset);

  // 3. Rounded Ribbon Bristles
  // Lowered the Y-scale slightly to make the globs even wider/chunkier
  let bristle_scale = vec2f(0.002, 1.0);
  let raw_bristle = value_noise(warped_uv * bristle_scale);
  
  // THE SINE WAVE TRICK:
  // Instead of using smoothstep (which creates flat plateaus and sharp drop-offs),
  // we map the noise through a sine wave. This converts the linear noise into 
  // perfectly rounded overlapping tubes (like macaroni or thick paint globs).
  let paint_tubes = sin(raw_bristle * 3.1415); 
  
  // Invert it so the peaks of the tubes carve smooth, U-shaped valleys into the SDF
  let soft_carve = 1.0 - paint_tubes;

  // 4. Pressure Dampening
  let pressure_curve = pow(pressure, 3.0); 
  
  // Lowered max depth to 0.8 so the U-shaped valleys don't slice too deep.
  // We removed the sharp `max()` cutoff, so the transition is perfectly smooth.
  let bristle_depth = (1.0 - pressure_curve) * 0.8; 
  let dynamic_bristles = soft_carve * bristle_depth;

  // 5. Combine
  let noisy_sdf = base_sdf + dynamic_bristles;

  return 0.5 - noisy_sdf;
}

fn brush_standard(local_uv: vec2f, stroke_uv: vec2f, pressure: f32) -> f32 {
  // 1. Base Shape
  let base_sdf = length(local_uv) - 1.75;

  // 2. Domain Warping
  // X is Length, Y is Width. We want slow variation along both.
  let warp_scale = vec2f(0.02, 0.05);
  let warp = value_noise(stroke_uv * warp_scale);
  
  // This pushes the bristles left and right across the WIDTH of the brush
  let warp_offset = (warp - 0.5) * 10.0;
  
  // Apply warp to the Y coordinate (Width)
  let warped_uv = vec2f(stroke_uv.x, stroke_uv.y + warp_offset);

  // 3. Bristle Generation (Swapped Axes)
  // X (Length) gets the extremely low scale to create continuous unbroken lines.
  // Y (Width) gets the high scale to create dense, tight bristles.
  let bristle_scale = vec2f(0.02, 0.4); 
  var raw_bristle = value_noise(warped_uv * bristle_scale);
  raw_bristle = pow(raw_bristle, 1.5);
  
  let ridge = 1.0 - abs((raw_bristle * 2.0) - 1.0);
  let sharp_bristles = ridge * 1.5; 

  // 4. Pressure Mechanic
  let pressure_curve = pow(pressure, 2.0); 
  let bristle_depth = (1.0 - pressure_curve) * 0.6; 
  let dynamic_bristles = sharp_bristles * bristle_depth;

  // 5. Combine
  let noisy_sdf = base_sdf + dynamic_bristles;

  return 0.5 - noisy_sdf;
}

fn brush_cartoony(local_uv: vec2f, stroke_uv: vec2f, pressure: f32) -> f32 {
  // 1. The Wobbly Base
  // Changes slowly along the arc length (stroke_uv.x) to make the brush pulse.
  let outline_wobble = sin(stroke_uv.x * 0.02) * 0.1;
  let base_sdf = length(local_uv) - (0.8 + outline_wobble);

  // 2. The Ribbons
  // Weave them slightly side-to-side as the stroke travels.
  let weave = sin(stroke_uv.x * 0.1) * 0.5;
  
  // Evaluated STRICTLY on the width axis (local_uv.y). 
  // Overlapping stamps share the exact same Y-axis, so the stripes merge perfectly.
  let bands = cos((local_uv.y + weave) * 32.0); 
  
  // Slice the wave into thick ribbons (solid) and U-shaped gaps
  let gaps = 1.0 - smoothstep(0.5, 0.9, bands);

  // 3. Pressure Dampening
  let pressure_curve = pow(pressure, 2.0);
  
  // Max carve is 0.8 so the gaps never slice completely through the core of the paint
  let carve_amount = gaps;

  // 4. Combine (NO EDGE MASK)
  // We simply add the carve directly to the SDF. The gaps will cut clean through 
  // the stamp, perfectly connecting to the stamp next to it.
  let final_sdf = carve_amount;

  return 0.5 - final_sdf;
}