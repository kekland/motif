import 'dart:math' as math;
import 'dart:typed_data';

Uint8List fullBrush(int width, int height) {
  final r8Bytes = Uint8List(width * height);

  for (var i = 0; i < r8Bytes.length; i++) {
    r8Bytes[i] = 255;
  }

  return r8Bytes;
}

Uint8List halftoneSdfBrush(int width, int height) {
  final r8Bytes = Uint8List(width * height);

  const double frequency = 0.6;

  final centerX = width / 2;
  final centerY = height / 2;
  final maxRadius = (width / 2.0);

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final dx = x - centerX;
      final dy = y - centerY;
      final dist = math.sqrt(dx * dx + dy * dy);

      final normDist = (dist / maxRadius).clamp(0.0, 1.0);
      final brushMask = math.pow(1.0 - normDist, 1.0).toDouble();

      final dotPattern = (math.sin(x * frequency) * math.sin(y * frequency) + 1) / 2;
      final intensity = (dotPattern * brushMask).clamp(0.0, 1.0);

      r8Bytes[y * width + x] = (intensity * 255).toInt();
    }
  }

  return r8Bytes;
}
/// Generates a seamless procedural bristle brush texture.
/// Designed to be stretched along a ribbon (U wraps seamlessly, V spans the width).
Uint8List physicalBristleBrush(int width, int height) {
  final r8Bytes = Uint8List(width * height);
  
  // Use a fixed seed so the brush looks the same every time you run the app
  final random = math.Random(42);

  // 1. Generate the base "Bristle Profile" along the Y-axis
  final yProfile = List<double>.filled(height, 0.0);
  for (int y = 0; y < height; y++) {
    // Normalize Y to [-1.0, 1.0]
    final ny = (y / (height - 1)) * 2.0 - 1.0;
    
    // Parabolic edge mask to make the outer bristles softer/transparent
    final edgeMask = math.max(0.0, 1.0 - (ny * ny));
    
    // Random noise for individual bristle thickness
    final bristleDensity = random.nextDouble() * 0.7 + 0.3; 
    
    // Macro clusters: makes the brush look like it has thick tufts of hair
    final cluster = (math.sin(ny * 25.0) + math.sin(ny * 50.0 + 1.5) + 2.0) / 4.0;
    
    yProfile[y] = edgeMask * bristleDensity * cluster;
  }

  // 2. Fill the texture with seamless dry-brush breakups along the X-axis
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      // Map x to [0, 2PI] to ensure the math wraps seamlessly at the edges
      final nx = (x / width) * math.pi * 2.0;

      // Create "dry brush" breaks using harmonic sine waves
      // We offset the phase using 'y' so the bristles break up independently
      final breakUp1 = math.sin(nx * 2.0 + y * 0.1);
      final breakUp2 = math.sin(nx * 5.0 - y * 0.5 + 2.0);
      final breakUp3 = math.sin(nx * 13.0 + y * 1.2);
      
      // Combine the sine waves and map them roughly to [0.0, 1.0]
      final seamlessNoise = (breakUp1 * 0.5 + breakUp2 * 0.25 + breakUp3 * 0.125 + 0.875) / 1.75;
      
      // Mix the baseline Y profile with the X noise
      double intensity = yProfile[y] * seamlessNoise;
      
      // Push the contrast to make the bristle streaks sharper and more distinct
      intensity = math.pow(intensity, 1.4).toDouble();
      
      // Amplify the core so it puts down solid ink, then clamp to valid bounds
      intensity = (intensity * 3.0).clamp(0.0, 1.0);

      r8Bytes[y * width + x] = (intensity * 255).toInt();
    }
  }

  return r8Bytes;
}
/// Generates an SDF texture for a heavily loaded wet bristle brush.
Uint8List heavyWetBristleBrush(int width, int height) {
  final bytes = Uint8List(width * height);
  final random = math.Random(88); // Fixed seed for consistent bristles

  // 1. Pre-calculate the Bristle Profile along the Y-axis.
  // This ensures the bristle tracks align perfectly when stamped.
  final bristleProfile = List<double>.filled(height, 0.0);
  
  for (int y = 0; y < height; y++) {
    // Normalize Y to [-1.0, 1.0]
    double ny = (y / (height - 1)) * 2.0 - 1.0; 
    
    // Base paint thickness (Parabolic curve)
    // The center is 1.0 (thick paint), falling off towards 0.0 at the edges.
    double paintThickness = 1.0 - (ny * ny); 
    
    // Generate organic bristle clumping using overlapping sine waves
    double bristleTufts = math.sin(ny * 30.0) * 0.15 
                        + math.sin(ny * 75.0) * 0.1 
                        + (random.nextDouble() * 0.08 - 0.04); // slight randomness
                 
    // Add the bristle grooves to the paint thickness
    bristleProfile[y] = paintThickness + bristleTufts; 
  }

  // 2. Fill the 2D texture
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
       // We add a tiny, low-frequency wobble along the X-axis.
       // This prevents the bristles from looking completely computer-generated 
       // and gives the illusion of the paint shifting slightly as it drags.
       double nx = (x / width) * math.pi * 2.0;
       double paintWobble = math.sin(nx + y * 0.1) * 0.04;
       
       // Combine, and ensure we stay in the 0.0 -> 1.0 bounds
       double finalSdf = (bristleProfile[y] + paintWobble).clamp(0.0, 1.0);
       
       bytes[y * width + x] = (finalSdf * 255).toInt();
    }
  }
  return bytes;
}