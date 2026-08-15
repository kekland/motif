import Foundation

#if canImport(FlutterMacOS)
  import FlutterMacOS
#else
  import Flutter
#endif

@_cdecl("WGPUPluginGlobals_getTextureRegistry")
public func WGPUPluginGlobals_getTextureRegistry() -> UnsafeRawPointer? {
  guard let registry = WGPUPluginGlobals.textureRegistry else { return nil }
  return UnsafeRawPointer(Unmanaged.passUnretained(registry).toOpaque())
}

@objc public class WGPUPluginGlobals: NSObject {
  @objc public static var textureRegistry: FlutterTextureRegistry?
}
