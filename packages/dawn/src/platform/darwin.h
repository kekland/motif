#ifndef DARWIN_H
#define DARWIN_H

#include "exports.h"
#include "stdint.h"

typedef struct flutter_texture_registry* flutter_texture_registry_t;
typedef struct flutter_texture* flutter_texture_t;
typedef struct mtl_flutter_texture* mtl_flutter_texture_t;
typedef struct mtl_texture* mtl_texture_t;

FFI void darwin_ffi_init();

FFI flutter_texture_registry_t flutter_texture_registry_get();

FFI int64_t flutter_texture_registry_register(flutter_texture_registry_t registry, flutter_texture_t texture);
FFI void flutter_texture_registry_texture_frame_available(flutter_texture_registry_t registry, int64_t texture_id);
FFI void flutter_texture_registry_unregister_texture(flutter_texture_registry_t registry, int64_t texture_id);

FFI mtl_flutter_texture_t mtl_flutter_texture_create();
FFI void mtl_flutter_texture_destroy(mtl_flutter_texture_t texture);
FFI void mtl_flutter_texture_update_buffer(mtl_flutter_texture_t texture, mtl_texture_t mtl_texture);

#endif  // DARWIN_H
