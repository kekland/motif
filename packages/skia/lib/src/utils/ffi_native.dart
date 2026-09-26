import 'package:ffi/ffi.dart' as ffi;

import 'dart:ffi' as dffi;

export 'dart:ffi';

export 'package:ffi/ffi.dart' show malloc, using, Utf8, StringUtf8Pointer, Utf8Pointer;

typedef Pointer<T extends dffi.NativeType> = dffi.Pointer<T>;
typedef Arena = ffi.Arena;

Pointer<Pointer<dffi.Char>> writeListString(dffi.Allocator allocator, List<String> strings) {
  final count = strings.length;
  final buffer = allocator<Pointer<dffi.Char>>(count);
  for (var i = 0; i < count; i++) {
    buffer[i] = strings[i].toNativeUtf8(allocator: allocator).cast();
  }

  return buffer;
}
