import 'dart:typed_data';
import 'package:vector_math/vector_math.dart' as vm32;
import 'package:vector_math/vector_math_64.dart' as vm64;
import 'package:webgpu/webgpu.dart' as webgpu;

part 'types.g.dart';

extension HalfPrecisionByteDataExt on ByteData {
  double getFloat16(int offset, [Endian endian = .big]) => throw UnimplementedError();
  void setFloat16(int offset, double value, [Endian endian = .big]) => throw UnimplementedError();
}

abstract class _HostBuffer<T> {
  _HostBuffer(this._buffer);

  final webgpu.Buffer _buffer;
  webgpu.Buffer get buffer => _buffer;
  webgpu.BufferView get bufferView => webgpu.BufferView(_buffer);
  void writeToQueue(webgpu.Queue queue);
}

abstract class UniformBuffer<T> extends _HostBuffer<T> {
  UniformBuffer(super._buffer);
}

abstract class StorageBuffer<T> extends _HostBuffer<T> {
  StorageBuffer(super._buffer);
}

abstract class ArrayStorageBuffer<T> extends _HostBuffer<T> {
  ArrayStorageBuffer(this.length, super._buffer);

  final int length;
}

abstract class VertexBuffer<T> extends _HostBuffer<T> {
  VertexBuffer(this.vertexCount, super._buffer);

  final int vertexCount;
}
