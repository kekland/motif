part of '../core.dart';

/// Flags that indicate which aspects of a node have changed and need to be updated.
extension type const NodeUpdateAspect(int value) {
  /// No aspects of the node have changed.
  static const none = NodeUpdateAspect(0);

  /// Node's name has changed.
  static const name = NodeUpdateAspect(1);

  /// Node's parent has changed.
  static const parent = NodeUpdateAspect(2);

  /// Node's children have changed.
  static const children = NodeUpdateAspect(4);

  /// Node's size has changed.
  static const size = NodeUpdateAspect(8);

  /// Node's transform has changed.
  static const transform = NodeUpdateAspect(16);

  /// Node's transient transform has changed.
  static const transientTransform = NodeUpdateAspect(32);

  /// Node's paint property has changed.
  static const paint = NodeUpdateAspect(64);

  //
  // Derived aspects
  //

  /// Node's properties that affect its layout have changed.
  static const layout = NodeUpdateAspect(2 | 4 | 8 | 16 | 32);

  /// Any aspect of the node has changed.
  static const all = NodeUpdateAspect(1 | 2 | 4 | 8 | 16 | 32 | 64);

  static NodeUpdateAspect of(List<NodeUpdateAspect> flags) => NodeUpdateAspect(flags.fold(0, (v, f) => v | f.value));

  bool contains(NodeUpdateAspect aspect) => (value & aspect.value) == aspect.value;
  bool get hasName => contains(.name);
  bool get hasParent => contains(.parent);
  bool get hasChildren => contains(.children);
  bool get hasSize => contains(.size);
  bool get hasTransform => contains(.transform);
  bool get hasTransientTransform => contains(.transientTransform);
  bool get hasPaint => contains(.paint);

  NodeUpdateAspect operator |(NodeUpdateAspect other) => NodeUpdateAspect(value | other.value);
  NodeUpdateAspect operator &(NodeUpdateAspect other) => NodeUpdateAspect(value & other.value);
  NodeUpdateAspect operator ^(NodeUpdateAspect other) => NodeUpdateAspect(value ^ other.value);
  NodeUpdateAspect operator ~() => NodeUpdateAspect(~value);
}


// extension type const BufferUsage(int value) {
//   static const none = BufferUsage(0);

//   /// The buffer can be *mapped* on the CPU side in *read* mode (using @ref WGPUMapMode_Read).
//   static const mapRead = BufferUsage(1);

//   /// The buffer can be *mapped* on the CPU side in *write* mode (using @ref WGPUMapMode_Write).
//   /// 
//   /// @note This usage is **not** required to set `mappedAtCreation` to `true` in @ref WGPUBufferDescriptor.
//   static const mapWrite = BufferUsage(2);

//   /// The buffer can be used as the *source* of a GPU-side copy operation.
//   static const copySrc = BufferUsage(4);

//   /// The buffer can be used as the *destination* of a GPU-side copy operation.
//   static const copyDst = BufferUsage(8);

//   /// The buffer can be used as an Index buffer when doing indexed drawing in a render pipeline.
//   static const index = BufferUsage(16);

//   /// The buffer can be used as a Vertex buffer when using a render pipeline.
//   static const vertex = BufferUsage(32);

//   /// The buffer can be bound to a shader as a uniform buffer.
//   static const uniform = BufferUsage(64);

//   /// The buffer can be bound to a shader as a storage buffer.
//   static const storage = BufferUsage(128);

//   /// The buffer can store arguments for an indirect draw call.
//   static const indirect = BufferUsage(256);

//   /// The buffer can store the result of a timestamp or occlusion query.
//   static const queryResolve = BufferUsage(512);

//   static const all = BufferUsage(0 | 1 | 2 | 4 | 8 | 16 | 32 | 64 | 128 | 256 | 512);

//   static BufferUsage of(List<BufferUsage> flags) => BufferUsage(flags.fold(0, (v, f) => v | f.value));

//   bool contains(BufferUsage flag) => (value & flag.value) == flag.value;
//   bool get hasNone => contains(.none);
//   bool get hasMapRead => contains(.mapRead);
//   bool get hasMapWrite => contains(.mapWrite);
//   bool get hasCopySrc => contains(.copySrc);
//   bool get hasCopyDst => contains(.copyDst);
//   bool get hasIndex => contains(.index);
//   bool get hasVertex => contains(.vertex);
//   bool get hasUniform => contains(.uniform);
//   bool get hasStorage => contains(.storage);
//   bool get hasIndirect => contains(.indirect);
//   bool get hasQueryResolve => contains(.queryResolve);

//   BufferUsage operator |(BufferUsage other) => BufferUsage(value | other.value);
//   BufferUsage operator &(BufferUsage other) => BufferUsage(value & other.value);
//   BufferUsage operator ^(BufferUsage other) => BufferUsage(value ^ other.value);
//   BufferUsage operator ~() => BufferUsage(~value);
// }