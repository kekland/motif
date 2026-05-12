part of '../src.dart';

abstract class ChainedStruct {
  const ChainedStruct({this.next});
  static ChainedStruct? fromNative(Pointer<bindings.WGPUChainedStruct> ptr) => _chainedStructFromNative(ptr);

  final ChainedStruct? next;

  SType get sType;

  Pointer toNative(Allocator allocator);
}
