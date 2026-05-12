import Flutter
import Foundation

import dawn_shared

public class DawnPluginIos: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = DawnPluginIos()
    DawnDarwinPluginGlobals.textureRegistry = DarwinFlutterTextureRegistry(textures: registrar.textures)
  }
}
