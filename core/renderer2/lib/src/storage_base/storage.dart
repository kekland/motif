import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:geometry/geometry.dart';

part 'composite_storage.dart';
part 'unit_storage.dart';
part 'unit_storages.dart';
part 'span_storage.dart';

const _defaultLength = 16;

typedef OffsetData = (int, TypedData);

extension type GpuByteData._(ByteData data) implements ByteData {
  GpuByteData(int length) : this._(ByteData(length));

  @pragma('vm:prefer-inline')
  double getF32(int offset) => data.getFloat32(offset, .little);

  @pragma('vm:prefer-inline')
  void setF32(int offset, double value) => data.setFloat32(offset, value, .little);

  @pragma('vm:prefer-inline')
  int getI32(int offset) => data.getInt32(offset, .little);

  @pragma('vm:prefer-inline')
  void setI32(int offset, int value) => data.setInt32(offset, value, .little);

  @pragma('vm:prefer-inline')
  int getU32(int offset) => data.getUint32(offset, .little);

  @pragma('vm:prefer-inline')
  void setU32(int offset, int value) => data.setUint32(offset, value, .little);
}

abstract class Storage {
  int get lengthInBytes;
  void Function()? onReallocate;

  Iterable<OffsetData> get buffers;
  Iterable<OffsetData> computeDirtyData();
  void clearDirtyData();
}
