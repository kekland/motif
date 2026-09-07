import 'package:flutter/rendering.dart';

extension RenderObjectExtensions on RenderObject {
  T? findAncestorRenderObjectOfType<T extends RenderObject>() {
    var current = parent;

    while (current != null) {
      if (current is T) return current;
      current = current.parent;
    }

    return null;
  }
}
