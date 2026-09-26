import 'package:skia/src/ffi.dart';

abstract class NativeObject<T extends NativeType> implements Finalizable {
  NativeObject(this._ptr) {
    attachFinalizer(_ptr.cast());
  }

  Pointer<T> _ptr;

  Pointer<T> get ptr {
    if (_ptr == nullptr) throw StateError('Pointer is null');
    return _ptr;
  }

  void attachFinalizer(Pointer<Void> ptr);
  void detachFinalizer();

  void destroy();

  void dispose() {
    detachFinalizer();
    destroy();
    _ptr = nullptr;
  }
}

String readString(Allocator allocator, int Function(Pointer<Char>) fn) {
  final length = fn(nullptr);
  final buffer = allocator<Uint8>(length + 1);
  fn(buffer.cast());
  return buffer.cast<Utf8>().toDartString();
}

List<String> readListString(Allocator allocator, int count, int Function(int index, Pointer<Char> buffer) fn) {
  return List.generate(
    count,
    (i) => readString(allocator, (buffer) => fn(i, buffer)),
  );
}
