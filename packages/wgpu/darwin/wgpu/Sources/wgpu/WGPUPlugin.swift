#if os(macOS)
import FlutterMacOS
import Foundation

@_exported import wgpu_shared

@objc(WGPUPluginMacOS)
public class WGPUPluginMacOS: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let _ = WGPUPluginMacOS()
    WGPUPluginGlobals.textureRegistry = registrar.textures
  }
}
#endif

#if os(iOS)
import Flutter
import Foundation

@_exported import wgpu_shared

@objc(WGPUPluginIos)
public class WGPUPluginIos: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let _ = WGPUPluginIos()
    WGPUPluginGlobals.textureRegistry = registrar.textures()
  }
}
#endif