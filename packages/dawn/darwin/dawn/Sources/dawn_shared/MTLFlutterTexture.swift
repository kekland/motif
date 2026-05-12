import CoreGraphics
import CoreImage
import CoreVideo
import Foundation
import Metal

#if canImport(FlutterMacOS)
  import FlutterMacOS
#else
  import Flutter
#endif

@_cdecl("MTLFlutterTexture_create")
public func MTLFlutterTexture_create() -> UnsafeRawPointer {
  let texture = MTLFlutterTexture()
  return UnsafeRawPointer(Unmanaged.passRetained(texture).toOpaque())
}

@_cdecl("MTLFlutterTexture_destroy")
public func MTLFlutterTexture_destroy(texturePtr: UnsafeRawPointer) {
  Unmanaged<MTLFlutterTexture>.fromOpaque(texturePtr).release()
}

@_cdecl("MTLFlutterTexture_updateBuffer")
public func MTLFlutterTexture_updateBuffer(texturePtr: UnsafeRawPointer, mtlTexturePtr: UnsafeRawPointer) {
  let texture = Unmanaged<DawnFlutterTexture>.fromOpaque(texturePtr).takeUnretainedValue()
  let mtlTexture = Unmanaged<MTLTexture>.fromOpaque(mtlTexturePtr).takeUnretainedValue()
  texture.updateBuffer(texture: mtlTexture)
}

@objc public class MTLFlutterTexture: NSObject, FlutterTexture {
  private var buffer: CVPixelBuffer?
  private let ciContext: CIContext
  private var bufferPool: CVPixelBufferPool?
  private var bufferPoolWidth: Int = 0
  private var bufferPoolHeight: Int = 0

  public override init() {
    let options: [CIContextOption: Any] = [
      .outputColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    ]

    self.ciContext = CIContext(
      mtlDevice: MTLCreateSystemDefaultDevice()!,
      options: options
    )

    super.init()
  }

  public func updateBuffer(texture: MTLTexture) {
    let width = texture.width
    let height = texture.height

    if bufferPool == nil || bufferPoolWidth != width || bufferPoolHeight != height {
      rebuildPool(width: width, height: height)
    }

    guard let pool = bufferPool else { return }

    var newBuffer = CVPixelBuffer?
    let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &newBuffer)
    guard status == kCVReturnSuccess, let buffer = newBuffer else {
      print("MTLFlutterTexture: pool create failed: \(status)")
    }

    CVPixelBufferLockBaseAddress(buffer, [])
    defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

    let ciImageOptions: [CIImageOption: Any] = [
      .colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!
    ]

    guard let ciImage = CIImage(mtlTexture: texture, options: ciImageOptions) else {
      print("MTLFlutterTexture: failed to create CIImage from MTLTexture")
      return
    }

    ciContext.render(ciImage, to: buffer)
    self.buffer = buffer
  }

  private func rebuildPool(width: Int, height: Int) {
    bufferPool = nil

    let poolAttributes: [String: Any] = [
      kCVPixelBufferPoolMinimumBufferCountKey as String: 1
    ]

    let bufferAttributes: [String: Any] = [
      kCVPixelBufferWidthKey as String: width,
      kCVPixelBufferHeightKey as String: height,
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
      kCVPixelBufferBytesPerRowAlignmentKey as String: 4,
      kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
      kCVPixelBufferCGImageCompatibilityKey as String: true,
      kCVPixelBufferMetalCompatibilityKey as String: true,
      kCVPixelBufferOpenGLCompatibilityKey as String: true,
      kCVImageBufferCGColorSpaceKey as String: CGColorSpace(name: CGColorSpace.sRGB)!,
    ]

    let status = CVPixelBufferPoolCreate(
      kCFAllocatorDefault,
      poolAttributes as CFDictionary,
      bufferAttributes as CFDictionary,
      &bufferPool
    )

    if status != kCVReturnSuccess {
      print("DawnFlutterTexture: pool rebuild failed: \(status)")
      return
    }

    bufferPoolWidth = width
    bufferPoolHeight = height
  }

  public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    guard let buffer = buffer else { return nil }
    return Unmanaged.passRetained(buffer)
  }
}
