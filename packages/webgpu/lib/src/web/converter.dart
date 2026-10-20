// ignore_for_file: sdk_version_since

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'webgpu.g.dart' as web;
import 'web.dart';

import 'package:webgpu/webgpu.dart' as webgpu;

@pragma('vm:prefer-inline')
T _convert<T>(T Function() create, void Function(T) cv) {
  final result = create();
  cv(result);
  return result;
}

extension RequestAdapterOptionsToJS on webgpu.RequestAdapterOptions {
  web.GPURequestAdapterOptions get toJS => _convert(
    () => .new(),
    (v) {
      if (featureLevel != .undefined) v.featureLevel = featureLevel.name!;
      if (powerPreference != .undefined) v.powerPreference = powerPreference.name!;
      v.forceFallbackAdapter = forceFallbackAdapter;
    },
  );
}

extension DeviceDescriptorToJS on webgpu.DeviceDescriptor {
  web.GPUDeviceDescriptor get toJS => _convert(
    () => .new(),
    (v) {
      v.label = label;
      v.defaultQueue = defaultQueue.toJS;
      v.requiredFeatures = requiredFeatures.map((f) => f.name!).toList().toJS;

      final limits = requiredLimits;
      if (limits == null) return;
      final limitsDict = {
        'maxTextureDimension1D': ?limits.maxTextureDimension1D,
        'maxTextureDimension2D': ?limits.maxTextureDimension2D,
        'maxTextureDimension3D': ?limits.maxTextureDimension3D,
        'maxTextureArrayLayers': ?limits.maxTextureArrayLayers,
        'maxBindGroups': ?limits.maxBindGroups,
        'maxBindGroupsPlusVertexBuffers': ?limits.maxBindGroupsPlusVertexBuffers,
        'maxBindingsPerBindGroup': ?limits.maxBindingsPerBindGroup,
        'maxDynamicUniformBuffersPerPipelineLayout': ?limits.maxDynamicUniformBuffersPerPipelineLayout,
        'maxDynamicStorageBuffersPerPipelineLayout': ?limits.maxDynamicStorageBuffersPerPipelineLayout,
        'maxSampledTexturesPerShaderStage': ?limits.maxSampledTexturesPerShaderStage,
        'maxSamplersPerShaderStage': ?limits.maxSamplersPerShaderStage,
        'maxStorageBuffersPerShaderStage': ?limits.maxStorageBuffersPerShaderStage,
        'maxStorageTexturesPerShaderStage': ?limits.maxStorageTexturesPerShaderStage,
        'maxUniformBuffersPerShaderStage': ?limits.maxUniformBuffersPerShaderStage,
        'maxUniformBufferBindingSize': ?limits.maxUniformBufferBindingSize,
        'maxStorageBufferBindingSize': ?limits.maxStorageBufferBindingSize,
        'minUniformBufferOffsetAlignment': ?limits.minUniformBufferOffsetAlignment,
        'minStorageBufferOffsetAlignment': ?limits.minStorageBufferOffsetAlignment,
        'maxVertexBuffers': ?limits.maxVertexBuffers,
        'maxBufferSize': ?limits.maxBufferSize,
        'maxVertexAttributes': ?limits.maxVertexAttributes,
        'maxVertexBufferArrayStride': ?limits.maxVertexBufferArrayStride,
        'maxInterStageShaderVariables': ?limits.maxInterStageShaderVariables,
        'maxColorAttachments': ?limits.maxColorAttachments,
        'maxColorAttachmentBytesPerSample': ?limits.maxColorAttachmentBytesPerSample,
        'maxComputeWorkgroupStorageSize': ?limits.maxComputeWorkgroupStorageSize,
        'maxComputeInvocationsPerWorkgroup': ?limits.maxComputeInvocationsPerWorkgroup,
        'maxComputeWorkgroupSizeX': ?limits.maxComputeWorkgroupSizeX,
        'maxComputeWorkgroupSizeY': ?limits.maxComputeWorkgroupSizeY,
        'maxComputeWorkgroupSizeZ': ?limits.maxComputeWorkgroupSizeZ,
        'maxComputeWorkgroupsPerDimension': ?limits.maxComputeWorkgroupsPerDimension,
        'maxImmediateSize': ?limits.maxImmediateSize,
      };

      final jsDict = JSObject();
      for (final entry in limitsDict.entries) {
        jsDict.setProperty(entry.key.toJS, entry.value.toJS);
      }

      v.requiredLimits = jsDict;
    },
  );
}

extension QueueDescriptorToJS on webgpu.QueueDescriptor {
  web.GPUQueueDescriptor get toJS => _convert(
    () => .new(),
    (v) {
      v.label = label;
    },
  );
}

extension BufferDescriptorToJS on webgpu.BufferDescriptor {
  web.GPUBufferDescriptor get toJS => _convert(
    () => .new(size: size, usage: usage.value),
    (v) {
      v.label = label;
      v.mappedAtCreation = mappedAtCreation;
    },
  );
}

extension TextureDescriptorToJS on webgpu.TextureDescriptor {
  web.GPUTextureDescriptor get toJS => _convert(
    () => .new(size: size.toJS, format: format.name!, usage: usage.value),
    (v) {
      v.label = label;
      if (dimension != .undefined) v.dimension = dimension.name!;
      if (format != .undefined) v.format = format.name!;
      v.mipLevelCount = mipLevelCount;
      v.sampleCount = sampleCount;
      v.viewFormats = viewFormats.map((f) => f.name!).toList().toJS;
    },
  );
}

extension CommandEncoderDescriptorToJS on webgpu.CommandEncoderDescriptor {
  web.GPUCommandEncoderDescriptor get toJS => _convert(
    () => .new(),
    (v) {
      v.label = label;
    },
  );
}

extension RenderPipelineDescriptorToJS on webgpu.RenderPipelineDescriptor {
  web.GPURenderPipelineDescriptor get toJS => _convert(
    () => .new(layout: layout?.toJS ?? 'auto'.toJS, vertex: vertex.toJS),
    (v) {
      v.primitive = primitive.toJS;
      v.multisample = multisample.toJS;
      if (fragment != null) v.fragment = fragment!.toJS;
      if (depthStencil != null) v.depthStencil = depthStencil!.toJS;
    },
  );
}

extension VertexStateToJS on webgpu.VertexState {
  web.GPUVertexState get toJS => _convert(
    () => .new(module: module!.toJS),
    (v) {
      v.buffers = buffers.map((v) => v.toJS).toList().toJS;
      v.constants = constants.toJS;
      if (entryPoint != null) v.entryPoint = entryPoint!;
    },
  );
}

extension VertexBufferLayoutToJS on webgpu.VertexBufferLayout {
  web.GPUVertexBufferLayout get toJS => _convert(
    () => .new(arrayStride: arrayStride, attributes: attributes.map((v) => v.toJS).toList().toJS),
    (v) {
      if (stepMode != .undefined) v.stepMode = stepMode.name!;
    },
  );
}

extension ConstantEntryListToJS on List<webgpu.ConstantEntry> {
  JSObject get toJS => _convert(
    () => .new(),
    (v) {
      for (final e in this) v.setProperty(e.key.toJS, e.value.toJS);
    },
  );
}

extension VertexAttributeToJS on webgpu.VertexAttribute {
  web.GPUVertexAttribute get toJS => _convert(
    () => .new(format: format.name!, offset: offset, shaderLocation: shaderLocation),
    (v) {},
  );
}

extension FragmentStateToJS on webgpu.FragmentState {
  web.GPUFragmentState get toJS => _convert(
    () => .new(module: module!.toJS, targets: targets.map((t) => t.toJS).toList().toJS),
    (v) {
      v.constants = constants.toJS;
      if (entryPoint != null) v.entryPoint = entryPoint!;
    },
  );
}

extension ColorTargetStateToJS on webgpu.ColorTargetState {
  web.GPUColorTargetState get toJS => _convert(
    () => .new(format: format.name!),
    (v) {
      if (writeMask != .none) v.writeMask = writeMask.value;
      if (blend != null) v.blend = blend!.toJS;
    },
  );
}

extension BlendStateToJS on webgpu.BlendState {
  web.GPUBlendState get toJS => _convert(
    () => .new(color: color.toJS, alpha: alpha.toJS),
    (v) {},
  );
}

extension BlendComponentToJS on webgpu.BlendComponent {
  web.GPUBlendComponent get toJS => _convert(
    () => .new(),
    (v) {
      if (operation != .undefined) v.operation = operation.name!;
      if (srcFactor != .undefined) v.srcFactor = srcFactor.name!;
      if (dstFactor != .undefined) v.dstFactor = dstFactor.name!;
    },
  );
}

extension PrimitiveStateToJS on webgpu.PrimitiveState {
  web.GPUPrimitiveState get toJS => _convert(
    () => .new(),
    (v) {
      if (topology != .undefined) v.topology = topology.name!;
      if (stripIndexFormat != .undefined) v.stripIndexFormat = stripIndexFormat.name!;
      if (frontFace != .undefined) v.frontFace = frontFace.name!;
      if (cullMode != .undefined) v.cullMode = cullMode.name!;
      v.unclippedDepth = unclippedDepth;
    },
  );
}

extension DepthStencilStateToJS on webgpu.DepthStencilState {
  web.GPUDepthStencilState get toJS => _convert(
    () => .new(format: format.name!),
    (v) {
      v.depthBias = depthBias;
      v.depthBiasClamp = depthBiasClamp;
      v.depthBiasSlopeScale = depthBiasSlopeScale;
      if (depthCompare != .undefined) v.depthCompare = depthCompare.name!;
      if (depthWriteEnabled != .undefined) v.depthWriteEnabled = depthWriteEnabled.asBoolean!;
      v.stencilBack = stencilBack.toJS;
      v.stencilFront = stencilFront.toJS;
      v.stencilReadMask = stencilReadMask;
      v.stencilWriteMask = stencilWriteMask;
    },
  );
}

extension StencilFaceStateToJS on webgpu.StencilFaceState {
  web.GPUStencilFaceState get toJS => _convert(
    () => .new(),
    (v) {
      if (compare != .undefined) v.compare = compare.name!;
      if (failOp != .undefined) v.failOp = failOp.name!;
      if (depthFailOp != .undefined) v.depthFailOp = depthFailOp.name!;
      if (passOp != .undefined) v.passOp = passOp.name!;
    },
  );
}

extension MultisampleStateToJS on webgpu.MultisampleState {
  web.GPUMultisampleState get toJS => _convert(
    () => .new(),
    (v) {
      v.count = count;
      v.mask = mask;
      v.alphaToCoverageEnabled = alphaToCoverageEnabled;
    },
  );
}

extension ShaderModuleDescriptorToJS on webgpu.ShaderModuleDescriptor {
  web.GPUShaderModuleDescriptor get toJS => _convert(
    () => .new(
      code: switch (next) {
        webgpu.ShaderSourceWGSL wgsl => wgsl.code,
        _ => throw ArgumentError(),
      },
    ),
    (v) {
      v.label = label;
    },
  );
}

extension TextureViewDescriptorToJS on webgpu.TextureViewDescriptor {
  web.GPUTextureViewDescriptor get toJS => _convert(
    () => .new(),
    (v) {
      v.label = label;
      if (usage != .none) v.usage = usage.value;
      if (format != .undefined) v.format = format.name!;
      if (dimension != .undefined) v.dimension = dimension.name!;
      if (aspect != .undefined) v.aspect = aspect.name!;
      v.baseMipLevel = baseMipLevel;
      v.baseArrayLayer = baseArrayLayer;
      if (mipLevelCount != null) v.mipLevelCount = mipLevelCount!;
      if (arrayLayerCount != null) v.arrayLayerCount = arrayLayerCount!;
    },
  );
}

extension RenderPassDescriptorToJS on webgpu.RenderPassDescriptor {
  web.GPURenderPassDescriptor get toJS => _convert(
    () => .new(colorAttachments: colorAttachments.map((e) => e.toJS).toList().toJS),
    (v) {
      v.label = label;
      if (depthStencilAttachment != null) v.depthStencilAttachment = depthStencilAttachment!.toJS;
      if (occlusionQuerySet != null) v.occlusionQuerySet = occlusionQuerySet!.toJS;
      if (timestampWrites != null) v.timestampWrites = timestampWrites!.toRenderPassTimestampWritesJS;
    },
  );
}

extension RenderPassDepthStencilAttachmentToJS on webgpu.RenderPassDepthStencilAttachment {
  web.GPURenderPassDepthStencilAttachment get toJS => _convert(
    () => .new(view: view!.toJS),
    (v) {
      if (depthClearValue != null) v.depthClearValue = depthClearValue!;
      if (depthLoadOp != .undefined) v.depthLoadOp = depthLoadOp.name!;
      if (depthStoreOp != .undefined) v.depthStoreOp = depthStoreOp.name!;
      v.depthReadOnly = depthReadOnly;
      v.stencilClearValue = stencilClearValue;
      if (stencilLoadOp != .undefined) v.stencilLoadOp = stencilLoadOp.name!;
      if (stencilStoreOp != .undefined) v.stencilStoreOp = stencilStoreOp.name!;
      v.stencilReadOnly = stencilReadOnly;
    },
  );
}

extension PassTimestampWritesToJS on webgpu.PassTimestampWrites {
  web.GPURenderPassTimestampWrites get toRenderPassTimestampWritesJS => _convert(
    () => .new(querySet: querySet!.toJS),
    (v) {
      if (beginningOfPassWriteIndex != null) v.beginningOfPassWriteIndex = beginningOfPassWriteIndex!;
      if (endOfPassWriteIndex != null) v.endOfPassWriteIndex = endOfPassWriteIndex!;
    },
  );

  web.GPUComputePassTimestampWrites get toComputePassTimestampWritesJS => _convert(
    () => .new(querySet: querySet!.toJS),
    (v) {
      if (beginningOfPassWriteIndex != null) v.beginningOfPassWriteIndex = beginningOfPassWriteIndex!;
      if (endOfPassWriteIndex != null) v.endOfPassWriteIndex = endOfPassWriteIndex!;
    },
  );
}

extension RenderPassColorAttachmentToJS on webgpu.RenderPassColorAttachment {
  web.GPURenderPassColorAttachment get toJS => _convert(
    () => .new(view: view!.toJS, loadOp: loadOp.name!, storeOp: storeOp.name!),
    (v) {
      v.clearValue = clearValue.toJS;
      if (depthSlice != null) v.depthSlice = depthSlice!;
      if (resolveTarget != null) v.resolveTarget = resolveTarget!.toJS;
    },
  );
}

extension ColorToJS on webgpu.Color {
  web.GPUColor get toJS => [r, g, b, a].toJS;
}

extension TexelCopyTextureInfoToJS on webgpu.TexelCopyTextureInfo {
  web.GPUTexelCopyTextureInfo get toJS => _convert(
    () => .new(texture: texture!.toJS),
    (v) {
      if (aspect != .undefined) v.aspect = aspect.name!;
      v.mipLevel = mipLevel;
      v.origin = origin.toJS;
    },
  );
}

extension TexelCopyBufferInfoToJS on webgpu.TexelCopyBufferInfo {
  web.GPUTexelCopyBufferInfo get toJS => _convert(
    () => .new(buffer: buffer!.toJS),
    (v) {
      v.offset = layout.offset;
      if (layout.bytesPerRow != null) v.bytesPerRow = layout.bytesPerRow!;
      if (layout.rowsPerImage != null) v.rowsPerImage = layout.rowsPerImage!;
    },
  );
}

extension Origin3DToJS on webgpu.Origin3D {
  web.GPUOrigin3D get toJS => [x, y, z].toJS;
}

extension Extent3DToJS on webgpu.Extent3D {
  web.GPUExtent3D get toJS => [width, height, depthOrArrayLayers].toJS;
}

extension BindGroupLayoutDescriptorToJS on webgpu.BindGroupLayoutDescriptor {
  web.GPUBindGroupLayoutDescriptor get toJS => _convert(
    () => .new(entries: entries.map((e) => e.toJS).toList().toJS),
    (v) {
      v.label = label;
    },
  );
}

extension BindGroupLayoutEntryToJS on webgpu.BindGroupLayoutEntry {
  web.GPUBindGroupLayoutEntry get toJS => _convert(
    () => .new(binding: binding, visibility: visibility.value),
    (v) {
      if (buffer != null) v.buffer = buffer!.toJS;
      if (sampler != null) v.sampler = sampler!.toJS;
      if (texture != null) v.texture = texture!.toJS;
      if (storageTexture != null) v.storageTexture = storageTexture!.toJS;
    },
  );
}

extension BufferBindingLayoutToJS on webgpu.BufferBindingLayout {
  web.GPUBufferBindingLayout get toJS => _convert(
    () => .new(),
    (v) {
      if (type != .undefined) v.type = type.name!;
      v.hasDynamicOffset = hasDynamicOffset;
      v.minBindingSize = minBindingSize;
    },
  );
}

extension SamplerBindingLayoutToJS on webgpu.SamplerBindingLayout {
  web.GPUSamplerBindingLayout get toJS => _convert(
    () => .new(),
    (v) {
      if (type != .undefined) v.type = type.name!;
    },
  );
}

extension TextureBindingLayoutToJS on webgpu.TextureBindingLayout {
  web.GPUTextureBindingLayout get toJS => _convert(
    () => .new(),
    (v) {
      if (sampleType != .undefined) v.sampleType = sampleType.name!;
      if (viewDimension != .undefined) v.viewDimension = viewDimension.name!;
      v.multisampled = multisampled;
    },
  );
}

extension StorageTextureBindingLayoutToJS on webgpu.StorageTextureBindingLayout {
  web.GPUStorageTextureBindingLayout get toJS => _convert(
    () => .new(format: format.name!),
    (v) {
      if (access != .undefined) v.access = access.name!;
      if (viewDimension != .undefined) v.viewDimension = viewDimension.name!;
    },
  );
}

extension BindGroupDescriptorToJS on webgpu.BindGroupDescriptor {
  web.GPUBindGroupDescriptor get toJS => _convert(
    () => .new(layout: layout!.toJS, entries: entries.map((e) => e.toJS).toList().toJS),
    (v) {
      v.label = label;
    },
  );
}

extension BindGroupEntryToJS on webgpu.BindGroupEntry {
  web.GPUBindGroupEntry get toJS => _convert(
    () {
      final JSObject resource;

      if (buffer != null) {
        final bufferBinding = web.GPUBufferBinding(buffer: buffer!.toJS, offset: offset);
        if (size != null) bufferBinding.size = size!;
        resource = bufferBinding;
      } else if (sampler != null) {
        resource = sampler!.toJS;
      } else if (textureView != null) {
        resource = textureView!.toJS;
      } else {
        throw Exception('No valid resource provided for BindGroupEntry.');
      }

      return .new(binding: binding, resource: resource);
    },
    (v) {},
  );
}

extension ComputePassDescriptorToJS on webgpu.ComputePassDescriptor {
  web.GPUComputePassDescriptor get toJS => _convert(
    () => .new(),
    (v) {
      v.label = label;
      if (timestampWrites != null) v.timestampWrites = timestampWrites!.toComputePassTimestampWritesJS;
    },
  );
}

extension ComputePipelineDescriptorToJS on webgpu.ComputePipelineDescriptor {
  web.GPUComputePipelineDescriptor get toJS => _convert(
    () => .new(layout: layout?.toJS ?? 'auto'.toJS, compute: compute.toJS),
    (v) {
      v.label = label;
    },
  );
}

extension ComputeStateToJS on webgpu.ComputeState {
  web.GPUProgrammableStage get toJS => _convert(
    () => .new(module: module!.toJS),
    (v) {
      v.constants = constants.toJS;
      if (entryPoint != null) v.entryPoint = entryPoint!;
    },
  );
}

extension PipelineLayoutDescriptorToJS on webgpu.PipelineLayoutDescriptor {
  web.GPUPipelineLayoutDescriptor get toJS => _convert(
    () => .new(bindGroupLayouts: bindGroupLayouts.map((e) => e.toJS).toList().toJS),
    (v) {
      v.immediateSize = immediateSize;
      v.label = label;
    },
  );
}

extension QuerySetDescriptorToJS on webgpu.QuerySetDescriptor {
  web.GPUQuerySetDescriptor get toJS => _convert(
    () => .new(type: type.name!, count: count),
    (v) {
      v.label = label;
    },
  );
}

extension RenderBundleEncoderDescriptorToJS on webgpu.RenderBundleEncoderDescriptor {
  web.GPURenderBundleEncoderDescriptor get toJS => _convert(
    () => .new(colorFormats: colorFormats.map((e) => e.name!).toList().toJS),
    (v) {
      v.depthReadOnly = depthReadOnly;
      v.stencilReadOnly = stencilReadOnly;
      if (depthStencilFormat != .undefined) v.depthStencilFormat = depthStencilFormat.name!;
      v.sampleCount = sampleCount;
      v.label = label;
    },
  );
}

extension SamplerDescriptorToJS on webgpu.SamplerDescriptor {
  web.GPUSamplerDescriptor get toJS => _convert(
    () => .new(),
    (v) {
      v.label = label;
      if (addressModeU != .undefined) v.addressModeU = addressModeU.name!;
      if (addressModeV != .undefined) v.addressModeV = addressModeV.name!;
      if (addressModeW != .undefined) v.addressModeW = addressModeW.name!;
      if (magFilter != .undefined) v.magFilter = magFilter.name!;
      if (minFilter != .undefined) v.minFilter = minFilter.name!;
      if (mipmapFilter != .undefined) v.mipmapFilter = mipmapFilter.name!;
      v.lodMinClamp = lodMinClamp;
      v.lodMaxClamp = lodMaxClamp;
      if (compare != .undefined) v.compare = compare.name!;
      v.maxAnisotropy = maxAnisotropy;
    },
  );
}

extension ErrorFilterToJS on webgpu.ErrorFilter {
  web.GPUErrorFilter get toJS => name!;
}

extension TexelCopyBufferLayoutToJS on webgpu.TexelCopyBufferLayout {
  web.GPUTexelCopyBufferLayout get toJS => _convert(
    () => .new(),
    (v) {
      v.offset = offset;
      if (bytesPerRow != null) v.bytesPerRow = bytesPerRow!;
      if (rowsPerImage != null) v.rowsPerImage = rowsPerImage!;
    },
  );
}

extension RenderBundleDescriptorToJS on webgpu.RenderBundleDescriptor {
  web.GPURenderBundleDescriptor get toJS => _convert(
    () => .new(),
    (v) {
      v.label = label;
    },
  );
}

extension CompilationInfoToDart on web.GPUCompilationInfo {
  webgpu.CompilationInfo get toDart => .new(
    messages: messages.toDart.map((e) => e.toDart).toList(),
  );
}

extension CompilationMessageToDart on web.GPUCompilationMessage {
  webgpu.CompilationMessage get toDart => .new(
    message: message,
    type: .fromName(type)!,
    lineNum: lineNum,
    linePos: linePos,
    offset: offset,
    length: length,
  );
}

extension LimitsToDart on web.GPUSupportedLimits {
  webgpu.Limits get toDart => .new(
    maxTextureDimension1D: maxTextureDimension1D,
    maxTextureDimension2D: maxTextureDimension2D,
    maxTextureDimension3D: maxTextureDimension3D,
    maxTextureArrayLayers: maxTextureArrayLayers,
    maxBindGroups: maxBindGroups,
    maxBindGroupsPlusVertexBuffers: maxBindGroupsPlusVertexBuffers,
    maxBindingsPerBindGroup: maxBindingsPerBindGroup,
    maxDynamicUniformBuffersPerPipelineLayout: maxDynamicUniformBuffersPerPipelineLayout,
    maxDynamicStorageBuffersPerPipelineLayout: maxDynamicStorageBuffersPerPipelineLayout,
    maxSampledTexturesPerShaderStage: maxSampledTexturesPerShaderStage,
    maxSamplersPerShaderStage: maxSamplersPerShaderStage,
    maxStorageBuffersPerShaderStage: maxStorageBuffersPerShaderStage,
    maxStorageTexturesPerShaderStage: maxStorageTexturesPerShaderStage,
    maxUniformBuffersPerShaderStage: maxUniformBuffersPerShaderStage,
    maxUniformBufferBindingSize: maxUniformBufferBindingSize,
    maxStorageBufferBindingSize: maxStorageBufferBindingSize,
    minUniformBufferOffsetAlignment: minUniformBufferOffsetAlignment,
    minStorageBufferOffsetAlignment: minStorageBufferOffsetAlignment,
    maxVertexBuffers: maxVertexBuffers,
    maxBufferSize: maxBufferSize,
    maxVertexAttributes: maxVertexAttributes,
    maxVertexBufferArrayStride: maxVertexBufferArrayStride,
    maxInterStageShaderVariables: maxInterStageShaderVariables,
    maxColorAttachments: maxColorAttachments,
    maxColorAttachmentBytesPerSample: maxColorAttachmentBytesPerSample,
    maxComputeWorkgroupStorageSize: maxComputeWorkgroupStorageSize,
    maxComputeInvocationsPerWorkgroup: maxComputeInvocationsPerWorkgroup,
    maxComputeWorkgroupSizeX: maxComputeWorkgroupSizeX,
    maxComputeWorkgroupSizeY: maxComputeWorkgroupSizeY,
    maxComputeWorkgroupSizeZ: maxComputeWorkgroupSizeZ,
    maxComputeWorkgroupsPerDimension: maxComputeWorkgroupsPerDimension,
    maxImmediateSize: maxImmediateSize,
  );
}

extension SupportedFeaturesToDart on web.GPUSupportedFeatures {
  webgpu.SupportedFeatures get toDart => .new(
    features: webgpu.FeatureName.values.where((n) => n != .zero && hasProperty(n.name!.toJS).toDart).toList(),
  );
}

extension AdapterInfoToDart on web.GPUAdapterInfo {
  webgpu.AdapterInfo get toDart => .new(
    vendor: vendor,
    architecture: architecture,
    device: device,
    description: description,
    backendType: .webgpu,
    subgroupMinSize: subgroupMinSize,
    subgroupMaxSize: subgroupMaxSize,
    vendorID: -1,
    deviceID: -1,
  );
}

// --
// Wrapped types to JS
// --

extension AdapterToJS on webgpu.Adapter {
  web.GPUAdapter get toJS => (this as Adapter).obj;
}

extension BindGroupLayoutToJS on webgpu.BindGroupLayout {
  web.GPUBindGroupLayout get toJS => (this as BindGroupLayout).obj;
}

extension BindGroupToJS on webgpu.BindGroup {
  web.GPUBindGroup get toJS => (this as BindGroup).obj;
}

extension BufferToJS on webgpu.Buffer {
  web.GPUBuffer get toJS => (this as Buffer).obj;
}

extension CommandBufferToJS on webgpu.CommandBuffer {
  web.GPUCommandBuffer get toJS => (this as CommandBuffer).obj;
}

extension CommandEncoderToJS on webgpu.CommandEncoder {
  web.GPUCommandEncoder get toJS => (this as CommandEncoder).obj;
}

extension ComputePassEncoderToJS on webgpu.ComputePassEncoder {
  web.GPUComputePassEncoder get toJS => (this as ComputePassEncoder).obj;
}

extension ComputePipelineToJS on webgpu.ComputePipeline {
  web.GPUComputePipeline get toJS => (this as ComputePipeline).obj;
}

extension DeviceToJS on webgpu.Device {
  web.GPUDevice get toJS => (this as Device).obj;
}

extension ExternalTextureToJS on webgpu.ExternalTexture {
  web.GPUExternalTexture get toJS => (this as ExternalTexture).obj;
}

extension InstanceToJS on webgpu.Instance {
  web.GPU get toJS => (this as Instance).obj;
}

extension PipelineLayoutToJS on webgpu.PipelineLayout {
  web.GPUPipelineLayout get toJS => (this as PipelineLayout).obj;
}

extension QuerySetToJS on webgpu.QuerySet {
  web.GPUQuerySet get toJS => (this as QuerySet).obj;
}

extension QueueToJS on webgpu.Queue {
  web.GPUQueue get toJS => (this as Queue).obj;
}

extension RenderBundleEncoderToJS on webgpu.RenderBundleEncoder {
  web.GPURenderBundleEncoder get toJS => (this as RenderBundleEncoder).obj;
}

extension RenderPassEncoderToJS on webgpu.RenderPassEncoder {
  web.GPURenderPassEncoder get toJS => (this as RenderPassEncoder).obj;
}

extension RenderPipelineToJS on webgpu.RenderPipeline {
  web.GPURenderPipeline get toJS => (this as RenderPipeline).obj;
}

extension SamplerToJS on webgpu.Sampler {
  web.GPUSampler get toJS => (this as Sampler).obj;
}

extension ShaderModuleToJS on webgpu.ShaderModule {
  web.GPUShaderModule get toJS => (this as ShaderModule).obj;
}

extension TextureViewToJS on webgpu.TextureView {
  web.GPUTextureView get toJS => (this as TextureView).obj;
}

extension TextureToJS on webgpu.Texture {
  web.GPUTexture get toJS => (this as Texture).obj;
}
