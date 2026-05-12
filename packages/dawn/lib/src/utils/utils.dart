part of '../src.dart';

mixin _NativeOwned<T extends NativeType> implements Finalizable {
  Pointer<T> __ptr = nullptr;

  Pointer<T> get _ptr {
    if (__ptr.address == 0) throw StateError('Pointer is null');
    return __ptr;
  }

  void _attach(Pointer<T> ptr, NativeFinalizer finalizer) {
    __ptr = ptr;
    finalizer.attach(this, ptr.cast(), detach: this);
  }

  void _borrow(Pointer<T> ptr) {
    __ptr = ptr;
  }

  void _dispose(void Function(Pointer<T>) deleter, NativeFinalizer finalizer) {
    if (__ptr.address != 0) {
      finalizer.detach(this);
      deleter(__ptr);
      __ptr = nullptr;
    }
  }

  void dispose();
}
