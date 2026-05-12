import Foundation

#if canImport(FlutterMacOS)
  import FlutterMacOS
#else
  import Flutter
#endif

@_cdecl("DawnPluginGlobals_getTextureRegistry")
public func DawnPluginGlobals_getTextureRegistry() -> UnsafeRawPointer? {
  guard let registry = DawnPluginGlobals.textureRegistry else { return nil }
  return UnsafeRawPointer(Unmanaged.passUnretained(registry).toOpaque())
}

@objc public class DawnPluginGlobals: NSObject {
  @objc public static var textureRegistry: FlutterTextureRegistry?
}
