// import CoreGraphics
// import CoreImage
// import CoreVideo
// import Foundation
// import Metal

// #if canImport(FlutterMacOS)
//   import FlutterMacOS
// #else
//   import Flutter
// #endif

// @_cdecl("MTLFlutterTexture_create")
// public func MTLFlutterTexture_create() -> UnsafeRawPointer {
//   let texture = MTLFlutterTexture()
//   return UnsafeRawPointer(Unmanaged.passRetained(texture).toOpaque())
// }

// @_cdecl("MTLFlutterTexture_destroy")
// public func MTLFlutterTexture_destroy(texturePtr: UnsafeRawPointer) {
//   Unmanaged<MTLFlutterTexture>.fromOpaque(texturePtr).release()
// }

// @_cdecl("MTLFlutterTexture_updateBuffer")
// public func MTLFlutterTexture_updateBuffer(texturePtr: UnsafeRawPointer, mtlTexturePtr: UnsafeRawPointer) {
//   let texture = Unmanaged<MTLFlutterTexture>.fromOpaque(texturePtr).takeUnretainedValue()
//   let mtlTexture = Unmanaged<MTLTexture>.fromOpaque(mtlTexturePtr).takeUnretainedValue()
//   texture.updateBuffer(texture: mtlTexture)
// }

// @objc public class MTLFlutterTexture: NSObject, FlutterTexture {
//   private var buffer: CVPixelBuffer?

//   private let mtlDevice: MTLDevice
//   private let commandQueue: MTLCommandQueue
//   private var textureCache: CVMetalTextureCache?

//   private var bufferPool: CVPixelBufferPool?
//   private var bufferPoolWidth: Int = 0
//   private var bufferPoolHeight: Int = 0

//   public override init() {
//     self.mtlDevice = MTLCreateSystemDefaultDevice()!
//     self.commandQueue = mtlDevice.makeCommandQueue()!
//     CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, mtlDevice, nil, &textureCache)

//     super.init()
//   }
  
//   public func updateBuffer(texture: MTLTexture) {
//     let width = texture.width
//     let height = texture.height

//     if bufferPool == nil || bufferPoolWidth != width || bufferPoolHeight != height {
//       rebuildPool(width: width, height: height)
//     }

//     guard let pool = bufferPool, let cache = textureCache else { return }

//     var newBuffer: CVPixelBuffer?
//     let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &newBuffer)
//     guard status == kCVReturnSuccess, let pixelBuffer = newBuffer else {
//       print("MTLFlutterTexture: pool create failed: \(status)")
//       return
//     }

//     var cvTextureOut: CVMetalTexture?
//     CVMetalTextureCacheCreateTextureFromImage(
//       kCFAllocatorDefault,
//       cache,
//       pixelBuffer,
//       nil,
//       .bgra8Unorm,
//       width,
//       height,
//       0,
//       &cvTextureOut
//     );

//     guard let cvTexture = cvTextureOut, let destTexture = CVMetalTextureGetTexture(cvTexture) else {
//       print("MTLFlutterTexture: failed to create CVMetalTexture")
//       return
//     }

//     guard let commandBuffer = commandQueue.makeCommandBuffer(), let blitEncoder = commandBuffer.makeBlitCommandEncoder() else {
//       print("MTLFlutterTexture: failed to create command buffer or blit encoder")
//       return
//     }

//     blitEncoder.copy(
//       from: texture, sourceSlice: 0, sourceLevel: 0, sourceOrigin: MTLOriginMake(0, 0, 0), sourceSize: MTLSizeMake(width, height, 1),
//       to: destTexture, destinationSlice: 0, destinationLevel: 0, destinationOrigin: MTLOriginMake(0, 0, 0)
//     )

//     blitEncoder.endEncoding()
//     commandBuffer.commit()
//     commandBuffer.waitUntilCompleted()

//     self.buffer = pixelBuffer
//   }

//   private func rebuildPool(width: Int, height: Int) {
//     bufferPool = nil

//     let poolAttributes: [String: Any] = [
//       kCVPixelBufferPoolMinimumBufferCountKey as String: 2
//     ]

//     let bufferAttributes: [String: Any] = [
//       kCVPixelBufferWidthKey as String: width,
//       kCVPixelBufferHeightKey as String: height,
//       kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
//       kCVPixelBufferBytesPerRowAlignmentKey as String: 64,
//       kCVPixelBufferMetalCompatibilityKey as String: true,
//       kCVPixelBufferIOSurfacePropertiesKey as String: [:] as [String: Any],
//     ]

//     CVPixelBufferPoolCreate(
//       kCFAllocatorDefault,
//       poolAttributes as CFDictionary,
//       bufferAttributes as CFDictionary,
//       &bufferPool
//     )

//     bufferPoolWidth = width
//     bufferPoolHeight = height
//   }

//   public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
//     guard let buffer = buffer else { return nil }
//     return Unmanaged.passRetained(buffer)
//   }
// }

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
  let texture = Unmanaged<MTLFlutterTexture>.fromOpaque(texturePtr).takeUnretainedValue()
  let mtlTexture = Unmanaged<MTLTexture>.fromOpaque(mtlTexturePtr).takeUnretainedValue()
  texture.updateBuffer(texture: mtlTexture)
}

@objc public class MTLFlutterTexture: NSObject, FlutterTexture {
  private var buffer: CVPixelBuffer?

  private let mtlDevice: MTLDevice
  private let commandQueue: MTLCommandQueue
  private var textureCache: CVMetalTextureCache?

  private var bufferPool: CVPixelBufferPool?
  private var bufferPoolWidth: Int = 0
  private var bufferPoolHeight: Int = 0
  private var _texture: MTLTexture?

  public override init() {
    self.mtlDevice = MTLCreateSystemDefaultDevice()!
    self.commandQueue = mtlDevice.makeCommandQueue()!
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, mtlDevice, nil, &textureCache)

    super.init()
  }
  
  public func updateBuffer(texture: MTLTexture) {
    self._texture = texture
  }

  private func rebuildPool(width: Int, height: Int) {
    bufferPool = nil

    let poolAttributes: [String: Any] = [
      kCVPixelBufferPoolMinimumBufferCountKey as String: 2
    ]

    let bufferAttributes: [String: Any] = [
      kCVPixelBufferWidthKey as String: width,
      kCVPixelBufferHeightKey as String: height,
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
      kCVPixelBufferBytesPerRowAlignmentKey as String: 64,
      kCVPixelBufferMetalCompatibilityKey as String: true,
      kCVPixelBufferIOSurfacePropertiesKey as String: [:] as [String: Any],
    ]

    CVPixelBufferPoolCreate(
      kCFAllocatorDefault,
      poolAttributes as CFDictionary,
      bufferAttributes as CFDictionary,
      &bufferPool
    )

    bufferPoolWidth = width
    bufferPoolHeight = height
  }

  public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    guard let texture = self._texture else { 
      print("MTLFlutterTexture: no texture set")
      return nil 
    }
  
    let width = texture.width
    let height = texture.height

    if bufferPool == nil || bufferPoolWidth != width || bufferPoolHeight != height {
      rebuildPool(width: width, height: height)
    }

    guard let pool = bufferPool, let cache = textureCache else { return nil }

    var newBuffer: CVPixelBuffer?
    let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &newBuffer)
    guard status == kCVReturnSuccess, let pixelBuffer = newBuffer else {
      print("MTLFlutterTexture: pool create failed: \(status)")
      return nil
    }

    var cvTextureOut: CVMetalTexture?
    CVMetalTextureCacheCreateTextureFromImage(
      kCFAllocatorDefault,
      cache,
      pixelBuffer,
      nil,
      .bgra8Unorm,
      width,
      height,
      0,
      &cvTextureOut
    );

    guard let cvTexture = cvTextureOut, let destTexture = CVMetalTextureGetTexture(cvTexture) else {
      print("MTLFlutterTexture: failed to create CVMetalTexture")
      return nil
    }

    guard let commandBuffer = commandQueue.makeCommandBuffer(), let blitEncoder = commandBuffer.makeBlitCommandEncoder() else {
      print("MTLFlutterTexture: failed to create command buffer or blit encoder")
      return nil
    }

    blitEncoder.copy(
      from: texture, sourceSlice: 0, sourceLevel: 0, sourceOrigin: MTLOriginMake(0, 0, 0), sourceSize: MTLSizeMake(width, height, 1),
      to: destTexture, destinationSlice: 0, destinationLevel: 0, destinationOrigin: MTLOriginMake(0, 0, 0)
    )

    blitEncoder.endEncoding()
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()

    self.buffer = pixelBuffer
    return Unmanaged.passRetained(pixelBuffer)
  }
}
