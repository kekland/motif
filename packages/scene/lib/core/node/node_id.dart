part of '../core.dart';

/// Identifier of a scene node. Each scene node has a unique identifier once attached to the scene graph.
/// 
/// The [keep] and [none] values can be used in methods that mutate nodes to indicate that the existing identifier
/// should be kept or that a new identifier should be generated, respectively.
extension type const NodeId(int id) {
  static NodeId generate() => .new(_id++);
  static var _id = 0;

  /// A sentinel value that indicates that the existing identifier for the node should be kept.
  static const NodeId keep = .new(-1);
  
  /// A sentinel value that indicates that a new identifier should be generated for the node.
  static const NodeId none = .new(-2);

  /// Resolves the identifier for a node based on the existing identifier and the requested identifier (either an actual
  /// value or a sentinel value).
  static NodeId resolve(NodeId existing, NodeId requested) {
    if (requested == .keep) return existing;
    if (requested == .none) return generate();
    return requested;
  }
}

