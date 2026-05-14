import 'dart:typed_data';
import 'package:vector_math/vector_math.dart' as vm32;
import 'package:vector_math/vector_math_64.dart' as vm64;

part 'types.g.dart';
part 'meta.dart';

// TODO: Implement this at some point?
extension HalfPrecisionByteDataExt on ByteData {
  double getFloat16(int offset, [Endian endian = .big]) => throw UnimplementedError();
  void setFloat16(int offset, double value, [Endian endian = .big]) => throw UnimplementedError();
}
