#define BINDINGS_DEFINED

#import "shared/uniforms.wgsl"
#import "shared/structs.wgsl"

@group(0) @binding(1) var<uniform> storage_offsets: StorageOffsets;

@group(2) @binding(0) var<storage, read_write> count: array<u32>;
@group(2) @binding(1) var<storage, read_write> indirect_args: array<DrawIndirectArgs>;

const SCAN_THREADS = 256u;
var<workgroup> partials: array<u32, SCAN_THREADS>;

@compute @workgroup_size(256)
fn main(@builtin(local_invocation_id) local_id: vec3u) {
  let n = storage_offsets.topology_draw_count;
  let tid = local_id.x;

  let chunk = (n + SCAN_THREADS - 1u) / SCAN_THREADS;
  let start = min(tid * chunk, n);
  let end = min(start + chunk, n);

  var sum = 0u;
  for (var i = start; i < end; i++) {
    sum += count[i];
  }
  partials[tid] = sum;
  workgroupBarrier();

  for (var stride = 1u; stride < SCAN_THREADS; stride *= 2u) {
    var v = 0u;
    if (tid >= stride) {
      v = partials[tid - stride];
    }
    workgroupBarrier();
    partials[tid] += v;
    workgroupBarrier();
  }

  let total = partials[SCAN_THREADS - 1u];
  var offset = partials[tid] - sum;

  for (var i = start; i < end; i++) {
    let c = count[i];
    count[i] = offset;
    offset += c;
  }

  if (tid == SCAN_THREADS - 1u) {
    count[n] = total;
  }

  storageBarrier();

  let capacity = storage_offsets.render_geometry_capacity;
  for (var c = tid; c < n; c += SCAN_THREADS) {
    let start = min(count[c], capacity);
    let end = min(count[c + 1], capacity);
    indirect_args[c] = DrawIndirectArgs((end - start) * 6u, 1u, start * 6u, 0u);
  }
}