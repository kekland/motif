#include "darwin.h"

#include <dlfcn.h>
#include <stdio.h>

template <typename T>
static T resolve(const char* name) {
  void* p = dlsym(RTLD_DEFAULT, name);
  T method = reinterpret_cast<T>(p);
  if (!method) {
    fprintf(stderr, "FFI stub: dlsym failed to resolve symbol: %s\n", name);
    return nullptr;
  }

  return method;
}

#define FFI_BIND(name, swift_name, ret, ...)         \
  using swift_name##_Fn = ret (*)(__VA_ARGS__);      \
  static swift_name##_Fn swift_name##_ptr = nullptr; \
  ret name(__VA_ARGS__)

#define FFI_RESOLVE(name) name##_ptr = resolve<name##_Fn>(#name)

FFI_BIND(flutter_texture_registry_get, DawnPluginGlobals_getTextureRegistry, flutter_texture_registry_t) {
  return DawnPluginGlobals_getTextureRegistry_ptr();
}

FFI_BIND(flutter_texture_registry_register, FlutterTextureRegistry_register, int64_t,
         flutter_texture_registry_t registry, flutter_texture_t texture) {
  return FlutterTextureRegistry_register_ptr(registry, texture);
}

FFI_BIND(flutter_texture_registry_texture_frame_available, FlutterTextureRegistry_textureFrameAvailable, void,
         flutter_texture_registry_t registry, int64_t textureId) {
  FlutterTextureRegistry_textureFrameAvailable_ptr(registry, textureId);
}

FFI_BIND(flutter_texture_registry_unregister_texture, FlutterTextureRegistry_unregisterTexture, void,
         flutter_texture_registry_t registry, int64_t textureId) {
  FlutterTextureRegistry_unregisterTexture_ptr(registry, textureId);
}

FFI_BIND(mtl_flutter_texture_create, MTLFlutterTexture_create, mtl_flutter_texture_t) {
  return MTLFlutterTexture_create_ptr();
}

FFI_BIND(mtl_flutter_texture_destroy, MTLFlutterTexture_destroy, void, mtl_flutter_texture_t texture) {
  MTLFlutterTexture_destroy_ptr(texture);
}

FFI_BIND(mtl_flutter_texture_update_buffer, MTLFlutterTexture_updateBuffer, void, mtl_flutter_texture_t texture,
         mtl_texture_t mtl_texture) {
  MTLFlutterTexture_updateBuffer_ptr(texture, mtl_texture);
}

void darwin_ffi_init() {
  FFI_RESOLVE(DawnPluginGlobals_getTextureRegistry);
  FFI_RESOLVE(FlutterTextureRegistry_register);
  FFI_RESOLVE(FlutterTextureRegistry_textureFrameAvailable);
  FFI_RESOLVE(FlutterTextureRegistry_unregisterTexture);
  FFI_RESOLVE(MTLFlutterTexture_create);
  FFI_RESOLVE(MTLFlutterTexture_destroy);
  FFI_RESOLVE(MTLFlutterTexture_updateBuffer);
}
