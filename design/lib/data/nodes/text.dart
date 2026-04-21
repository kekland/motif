part of '../data.dart';

class TextStyleData {
  const TextStyleData({
    this.fontFamily = 'Arial',
    this.fontSize = 14.0,
    this.color = .white,
  });

  final String fontFamily;
  final double fontSize;
  final ColorData color;
}

class TextSpanData {
  const TextSpanData(
    this.text, {
    this.style = const TextStyleData(),
  });

  final String text;
  final TextStyleData style;
}

mixin TextNode implements Node {
  @override
  bool get isLeaf => true;

  List<TextSpanData> get spans;
}

class ImmutableTextNode extends ImmutableNode with TextNode {
  ImmutableTextNode({
    super.parent,
    super.name,
    super.layout,
    super.transform,
    this.spans = const [],
  });

  ImmutableTextNode.fromMutable(MutableTextNode mutable)
    : this(
        name: mutable.name,
        layout: mutable.layout,
        transform: mutable.transform,
        spans: mutable.spans,
      );

  @override
  final List<TextSpanData> spans;

  @override
  MutableTextNode copyAsMutable() => .fromImmutable(this);

  @override
  ImmutableTextNode copyWith({
    ImmutableNode? parent,
    List<ImmutableNode>? children,
    String? name,
    NodeTransformData? transform,
    NodeLayoutData? layout,
  }) => ImmutableTextNode(
    parent: parent ?? this.parent,
    name: name ?? this.name,
    layout: layout ?? this.layout,
    transform: transform ?? this.transform,
    spans: spans,
  );
}

class MutableTextNode extends MutableNode with TextNode {
  MutableTextNode({
    super.name,
    super.layout,
    super.transform,
    List<TextSpanData> spans = const [],
  }) {
    _spansSignal = $listSignal(spans);
    notifyListenersOn([_spansSignal]);
  }

  MutableTextNode.fromImmutable(ImmutableTextNode immutable)
    : this(
        name: immutable.name,
        layout: immutable.layout,
        transform: immutable.transform,
        spans: immutable.spans,
      );

  // dart format off
  late final ListSignal<TextSpanData> _spansSignal;
  @override List<TextSpanData> get spans => _spansSignal.value;
  set spans(List<TextSpanData> value) => _spansSignal.value = value;
  // dart format on

  @override
  ImmutableTextNode copyAsImmutable() => .fromMutable(this);
}
