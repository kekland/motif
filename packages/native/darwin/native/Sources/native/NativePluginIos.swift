#if os(iOS)

import Foundation
import Flutter

@objc(NativePluginIos)
public class NativePluginIos: NSObject, FlutterPlugin {
  @objc public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = NativePluginIos()
  }
}

#endif