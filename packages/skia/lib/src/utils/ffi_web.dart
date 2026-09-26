// ignore: implementation_imports
import 'dart:convert';

import 'package:ffigen_js/ffigen_js.dart' as jsgen hide StringUtils;

export 'package:ffigen_js/ffigen_js.dart' hide StringUtils;

typedef Pointer<T extends jsgen.NativeType> = jsgen.Pointer<T>;

abstract class Allocator {
  const Allocator();

  jsgen.Pointer<T> call<T extends jsgen.NativeType>([int? count, int? size]);
}

class Arena extends Allocator {
  final _managedPtrs = <jsgen.Pointer<jsgen.NativeType>>[];

  @override
  jsgen.Pointer<T> call<T extends jsgen.NativeType>([int? count, int? size]) {
    final _size = (size ?? jsgen.sizeOf<T>());
    final ptr = jsgen.malloc<T>(_size * (count ?? 1));
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

class MallocAllocator extends Allocator {
  const MallocAllocator();

  @override
  jsgen.Pointer<T> call<T extends jsgen.NativeType>([int? count, int? size]) {
    final _size = (size ?? jsgen.sizeOf<T>());
    return jsgen.malloc<T>(_size * (count ?? 1));
  }
}

const malloc = MallocAllocator();

typedef Double = jsgen.Double;

extension DoublePointerExt on jsgen.Pointer<Double> {
  double operator [](int index) => Pointer<Double>(address + index * 8).getValue();
  void operator []=(int index, double value) => Pointer<Double>(address + index * 8).setValue(value);
}

typedef Uint8 = jsgen.Uint8;

jsgen.NativeLibrary get lib => jsgen.NativeLibrary.instance;

extension Uint8PointerExt on jsgen.Pointer<Uint8> {}

extension StringToNativeExt on String {
  jsgen.Pointer<jsgen.Uint8> toNativeUtf8({Allocator allocator = malloc}) {
    final units = utf8.encode(this);
    final ptr = allocator<Uint8>(units.length + 1);
    final nativeString = ptr.asTypedList(units.length + 1);
    nativeString.setAll(0, units);
    nativeString[units.length] = 0;
    return ptr;
  }
}

extension NativeFinalizerFunctionCast<T extends jsgen.NativeType> on NativeFinalizerFunction {
  NativeFinalizerFunction cast<U extends jsgen.NativeType>() => this;
}

typedef NativeFinalizerFunction = void Function(Pointer ptr);

mixin Finalizable {}

final class NativeFinalizer {
  NativeFinalizer(this.callback) : _finalizer = Finalizer<Pointer>(callback);
  final void Function(Pointer) callback;

  final Finalizer<Pointer> _finalizer;

  void attach(Finalizable finalizable, Pointer ptr, {Finalizable? detach}) {
    _finalizer.attach(finalizable, ptr, detach: detach);
  }

  void detach(Finalizable finalizable) {
    _finalizer.detach(finalizable);
  }
}

jsgen.Pointer<jsgen.PointerClass<jsgen.Char>> writeListString(Allocator allocator, List<String> strings) {
  final count = strings.length;
  final buffer = allocator<jsgen.PointerClass<jsgen.Char>>(count, 4);
  for (var i = 0; i < count; i++) {
    buffer[i] = strings[i].toNativeUtf8(allocator: allocator).cast();
  }

  return buffer;
}
