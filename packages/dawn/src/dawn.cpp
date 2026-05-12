#include "dawn.h"
#include <dawn/dawn_proc.h>
#include <dawn/native/DawnNative.h>

void dawn_init() {
  dawnProcSetProcs(&dawn::native::GetProcs());
}
