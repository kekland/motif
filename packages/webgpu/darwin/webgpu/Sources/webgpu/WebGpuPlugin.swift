#if os(macOS)
import FlutterMacOS
import Foundation

@_exported import webgpu_shared

@objc(WebGpuPluginMacOS)
public class WebGpuPluginMacOS: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let _ = WebGpuPluginMacOS()
    WebGpuPluginGlobals.textureRegistry = registrar.textures
  }
}
#endif

#if os(iOS)
import Flutter
import Foundation

@_exported import webgpu_shared

@objc(WebGpuPluginIos)
public class WebGpuPluginIos: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let _ = WebGpuPluginIos()
    WebGpuPluginGlobals.textureRegistry = registrar.textures()
  }
}
#endif