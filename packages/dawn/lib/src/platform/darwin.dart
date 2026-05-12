import 'dart:ffi';

import 'gen/darwin_bindings.dart' as bindings;

class FlutterTextureRegistry {
  FlutterTextureRegistry._(this._ptr);

  static bool _initialized = false;
  static FlutterTextureRegistry? _instance;
  static FlutterTextureRegistry get instance {
    if (!_initialized) {
      bindings.darwin_ffi_init();
      _initialized = true;
    }

    return _instance ??= ._(bindings.flutter_texture_registry_get());
  }

  final bindings.flutter_texture_registry_t _ptr;

  int register(FlutterTexture texture) {
    final id = bindings.flutter_texture_registry_register(_ptr, texture._ptr.cast());
    texture._textureId = id;
    return id;
  }

  void textureFrameAvailable(int textureId) {
    bindings.flutter_texture_registry_texture_frame_available(_ptr, textureId);
  }

  void unregister(int textureId) {
    bindings.flutter_texture_registry_unregister_texture(_ptr, textureId);
  }
}

abstract class FlutterTexture {
  FlutterTexture._(this._ptr);

  final Pointer _ptr;
  int? _textureId;

  int? get textureId => _textureId;
  bool get isRegistered => _textureId != null;

  int register() {
    assert(_textureId == null);
    return FlutterTextureRegistry.instance.register(this);
  }

  void frameAvailable() {
    assert(_textureId != null);
    FlutterTextureRegistry.instance.textureFrameAvailable(_textureId!);
  }

  void unregister() {
    assert(_textureId != null);
    FlutterTextureRegistry.instance.unregister(_textureId!);
  }
}

class MTLFlutterTexture extends FlutterTexture {
  MTLFlutterTexture._(super._ptr) : super._() {
    _finalizer.attach(this, (_ptr.cast(), null), detach: this);
  }

  factory MTLFlutterTexture.create() {
    final ptr = bindings.mtl_flutter_texture_create();
    return ._(ptr);
  }

  static final _finalizer = Finalizer<(bindings.mtl_flutter_texture_t, int?)>((data) {
    final (ptr, id) = data;
    _dispose(ptr, id);
  });

  static void _dispose(bindings.mtl_flutter_texture_t ptr, int? textureId) {
    if (textureId != null) {
      final registry = bindings.flutter_texture_registry_get();
      bindings.flutter_texture_registry_unregister_texture(registry, textureId);
    }

    bindings.mtl_flutter_texture_destroy(ptr);
  }

  void _refreshFinalizer() {
    _finalizer.detach(this);
    _finalizer.attach(this, (_ptr.cast(), _textureId), detach: this);
  }

  @override
  int register() {
    final id = super.register();
    _refreshFinalizer();
    return id;
  }

  void updateBuffer(Pointer<Void> mtlTexture) {
    bindings.mtl_flutter_texture_update_buffer(_ptr.cast(), mtlTexture.cast());
  }

  @override
  void unregister() {
    super.unregister();
    _refreshFinalizer();
  }

  void dispose() {
    _finalizer.detach(this);
    _dispose(_ptr.cast(), _textureId);
  }
}
