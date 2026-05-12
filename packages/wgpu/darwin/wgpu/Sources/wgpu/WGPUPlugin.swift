#if canImport(FlutterMacOS)
import FlutterMacOS
import Foundation

@_exported import wgpu_shared

public class WGPUPluginMacOS: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let _ = WGPUPluginMacOS()
    WGPUPluginGlobals.textureRegistry = registrar.textures
  }
}
#endif

#if canImport(Flutter)
import Flutter
import Foundation

@_exported import wgpu_shared

public class WGPUPluginIos: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let _ = WGPUPluginIos()
    WGPUPluginGlobals.textureRegistry = registrar.textures
  }
}
#endif