// ignore: implementation_imports
import 'package:ffigen_js/ffigen_js.dart' as jsgen;
import 'wasm_sizes.dart' as wasm_sizes;

typedef Pointer<T extends jsgen.NativeType> = jsgen.Pointer<T>;

abstract class _Allocator {
  jsgen.Pointer<T> call<T extends jsgen.NativeType>([int? count]);
}

class Arena extends _Allocator {
  final _managedPtrs = <jsgen.Pointer<jsgen.NativeType>>[];

  @override
  jsgen.Pointer<T> call<T extends jsgen.NativeType>([int? count]) {
    final ptr = jsgen.malloc<T>(wasm_sizes.sizeOf<T>() * (count ?? 1));
    _managedPtrs.add(ptr);
    return ptr;
  }

  void releaseAll() {
    for (final ptr in _managedPtrs) jsgen.free(ptr);
    _managedPtrs.clear();
  }
}

R using<R>(R Function(Arena arena) fn) {
  final arena = Arena();
  try {
    return fn(arena);
  } finally {
    arena.releaseAll();
  }
}

class _MallocAllocator extends _Allocator {
  @override
  jsgen.Pointer<T> call<T extends jsgen.NativeType>([int? count]) {
    return jsgen.malloc<T>(wasm_sizes.sizeOf<T>() * (count ?? 1));
  }
}

final malloc = _MallocAllocator();

typedef Double = jsgen.Double;
extension DoublePointerExt on jsgen.Pointer<Double> {
  double operator [](int index) => Pointer<Double>(address + index * 8).getValue();
  void operator []=(int index, double value) => Pointer<Double>(address + index * 8).setValue(value);
}
