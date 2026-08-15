extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> interleave(T element) sync* {
    var first = true;
    for (final item in this) {
      if (!first) yield element;
      yield item;
      first = false;
    }
  }
}
