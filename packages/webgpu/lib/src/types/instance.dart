part of 'types.dart';

abstract class Instance {
  static bool _initialized = false;
  static void ensureInitialized() {
    if (_initialized) return;
    initializeWebGpu();
    _initialized = true;
  }

  static Instance get defaultInstance {
    ensureInitialized();
    return createDefaultInstance();
  }

  Future<Adapter> requestAdapter([RequestAdapterOptions? options]);
}
