import 'package:webgpu/webgpu.dart';

/// A utility class that represents a view into a [Buffer].
extension type BufferView._((Buffer buffer, int offset, int size) _) {
  BufferView(Buffer buffer, {int offset = 0, int? size}) : this._((buffer, offset, size ?? buffer.size));

  Buffer get buffer => _.$1;
  int get offset => _.$2;
  int get size => _.$3;
}
