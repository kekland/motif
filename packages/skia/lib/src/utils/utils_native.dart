import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi' as dffi;

export 'dart:ffi';
export 'package:ffi/ffi.dart' show malloc, using;

typedef Pointer<T extends dffi.NativeType> = dffi.Pointer<T>;
typedef Arena = ffi.Arena;
