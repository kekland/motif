import FlutterMacOS
import Foundation

import dawn_shared

public class DawnPluginMacOS: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = DawnPluginMacOS()
    DawnDarwinPluginGlobals.textureRegistry = DarwinFlutterTextureRegistry(textures: registrar.textures)
  }
}
