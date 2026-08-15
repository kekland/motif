import 'dart:ffi' as ffi;

import '../webgpu/webgpu.g.dart' show WGPU_ChainedStructFromNative;
import '../wgpu_native/wgpu_native.dart' show WGPUNative_ChainedStructFromNative;

abstract class ChainedStruct {
  const ChainedStruct({this.next});
  static ChainedStruct? fromNative(ffi.Pointer<ffi.NativeType> ptr) {
    final webgpuStruct = WGPU_ChainedStructFromNative(ptr.cast());
    if (webgpuStruct != null) return webgpuStruct;

    final wgpuNativeStruct = WGPUNative_ChainedStructFromNative(ptr.cast());
    if (wgpuNativeStruct != null) return wgpuNativeStruct;

    return null;
  }

  final ChainedStruct? next;

  int get sType;

  ffi.Pointer toNative(ffi.Allocator allocator);
}
