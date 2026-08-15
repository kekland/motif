#if os(macOS)

import Foundation
import FlutterMacOS

@objc(NativePluginMacos)
public class NativePluginMacos: NSObject, FlutterPlugin {
  @objc public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = NativePluginMacos()
  }
}

#endif