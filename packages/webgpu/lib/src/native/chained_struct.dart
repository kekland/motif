// ignore_for_file: non_constant_identifier_names

import 'dart:ffi' as ffi;

import 'package:webgpu/webgpu.dart' as webgpu;

import 'wgpu.g.dart' show WGPU_ChainedStructFromNative, WGPU_ChainedStructToNative;
import 'wgpu_native.g.dart' show WGPUNative_ChainedStructFromNative, WGPUNative_ChainedStructToNative;

webgpu.ChainedStruct? ChainedStruct$fromNative(ffi.Pointer<ffi.NativeType> ptr) {
  final webgpuStruct = WGPU_ChainedStructFromNative(ptr.cast());
  if (webgpuStruct != null) return webgpuStruct;

  final wgpuNativeStruct = WGPUNative_ChainedStructFromNative(ptr.cast());
  if (wgpuNativeStruct != null) return wgpuNativeStruct;

  return null;
}

ffi.Pointer ChainedStruct$toNative(ffi.Allocator allocator, webgpu.ChainedStruct? value) {
  if (value == null) return ffi.nullptr;

  final webgpuPtr = WGPU_ChainedStructToNative(allocator, value);
  if (webgpuPtr != null) return webgpuPtr;

  final wgpuNativePtr = WGPUNative_ChainedStructToNative(allocator, value);
  if (wgpuNativePtr != null) return wgpuNativePtr;

  return ffi.nullptr;
}
