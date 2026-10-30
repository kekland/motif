#import "../geometry/cubic.wgsl"
#import "../geometry/vector.wgsl"
#import "../shared/utils.wgsl"
#import "../bindings.wgsl"

fn get_cubic_segment_count(cubic: Cubic2) -> u32 {
  return min(u32(ceil(cubic2_wang(cubic, world.tolerance))), MAX_EDGE_SEGMENTS);
}