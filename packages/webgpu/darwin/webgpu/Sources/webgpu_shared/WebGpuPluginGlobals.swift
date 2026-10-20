import Foundation

#if canImport(FlutterMacOS)
  import FlutterMacOS
#else
  import Flutter
#endif

@_cdecl("WebGpuPluginGlobals_getTextureRegistry")
public func WebGpuPluginGlobals_getTextureRegistry() -> UnsafeRawPointer? {
  guard let registry = WebGpuPluginGlobals.textureRegistry else { return nil }
  return UnsafeRawPointer(Unmanaged.passUnretained(registry).toOpaque())
}

@objc public class WebGpuPluginGlobals: NSObject {
  @objc public static var textureRegistry: FlutterTextureRegistry?
}
