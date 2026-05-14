import 'package:wgpu/wgpu.dart';

/// A utility class that represents a view into a [Buffer].
extension type const BufferView._((Buffer buffer, int offset, int size) _) {
  const BufferView(Buffer buffer, {int offset = 0, int size = WHOLE_SIZE}) : this._((buffer, offset, size));

  Buffer get buffer => _.$1;
  int get offset => _.$2;
  int get size => _.$3;
}
