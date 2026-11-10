#ifndef PREFIX_SUM_BUFFER_NAME
#define PREFIX_SUM_BUFFER_NAME buffer
#define PREFIX_SUM_COUNT 0u

@group(0) @binding(0) var<storage, read_write> PREFIX_SUM_BUFFER_NAME: array<u32>;

#endif

const SCAN_THREADS = 256u;
var<workgroup> partials: array<u32, SCAN_THREADS>;

@compute @workgroup_size(SCAN_THREADS)
fn PREFIX_SUM_FN_NAME(@builtin(local_invocation_id) local_id: vec3u) {
  let n = PREFIX_SUM_COUNT;
  let tid = local_id.x;

  let chunk = (n + SCAN_THREADS - 1u) / SCAN_THREADS;
  let start = min(tid * chunk, n);
  let end = min(start + chunk, n);

  var sum = 0u;
  for (var i = start; i < end; i++) { sum += PREFIX_SUM_BUFFER_NAME[i]; }
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
    let c = PREFIX_SUM_BUFFER_NAME[i];
    PREFIX_SUM_BUFFER_NAME[i] = offset;
    offset += c;
  }

  if (tid == SCAN_THREADS - 1u) {
    PREFIX_SUM_BUFFER_NAME[n] = total;
  }
}