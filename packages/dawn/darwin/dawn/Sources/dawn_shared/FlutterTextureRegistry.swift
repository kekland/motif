import Foundation

#if canImport(FlutterMacOS)
  import FlutterMacOS
#else
  import Flutter
#endif

@_cdecl("FlutterTextureRegistry_register")
public func FlutterTextureRegistry_register(
  registryPtr: UnsafeRawPointer,
  texturePtr: UnsafeRawPointer
) -> Int64 {
  let registry = Unmanaged<FlutterTextureRegistry>.fromOpaque(registryPtr).takeUnretainedValue()
  let texture = Unmanaged<any FlutterTexture>.fromOpaque(texturePtr).takeUnretainedValue()
  return registry.register(texture)
}

@_cdecl("FlutterTextureRegistry_textureFrameAvailable")
public func FlutterTextureRegistry_textureFrameAvailable(
  registryPtr: UnsafeRawPointer,
  textureId: Int64
) {
  let registry = Unmanaged<FlutterTextureRegistry>.fromOpaque(registryPtr).takeUnretainedValue()
  registry.textureFrameAvailable(textureId: textureId)
}

@_cdecl("FlutterTextureRegistry_unregisterTexture")
public func FlutterTextureRegistry_unregisterTexture(
  registryPtr: UnsafeRawPointer,
  textureId: Int64
) {
  let registry = Unmanaged<FlutterTextureRegistry>.fromOpaque(registryPtr).takeUnretainedValue()
  registry.unregisterTexture(textureId: textureId)
}
