part of '../_program.dart';

enum DecorationKind { color, image, shader }

sealed class const Decoration(final String id) {
  factory color(ColorData color) = ColorDecoration.create;
  factory image(Hash? image, {double opacity}) = ImageDecoration.create;
  factory shader(ShaderBlueprint shader, {double opacity}) = ShaderDecoration.create;

  DecorationKind get kind;

  Decoration withOpacity(double opacity);
  Decoration _withId(String id);

  Decoration copyWithDecoration(Decoration decoration) => _withId(id);
}

final class const ColorDecoration(super.id, final ColorData color) extends Decoration with Equatable {
  factory create(ColorData color) => .new(uuid.v4(), color);

  @override
  DecorationKind get kind => .color;

  @override
  List<Object?> get props => [id, color];

  @override
  ColorDecoration _withId(String id) => .new(id, color);

  @override
  ColorDecoration withOpacity(double opacity) => copyWith(color: color.withAlpha(opacity));
  ColorDecoration copyWith({ColorData? color}) => .new(id, color ?? this.color);
}

final class const ImageDecoration(
  super.id,
  final Hash? image, {
  final double opacity = 1.0,
}) extends Decoration with Equatable {
  factory create(Hash? image, {double opacity = 1.0}) => .new(uuid.v4(), image, opacity: opacity);

  @override
  DecorationKind get kind => .image;

  @override
  List<Object?> get props => [id, image, opacity];

  @override
  ImageDecoration _withId(String id) => .new(id, image, opacity: opacity);

  @override
  ImageDecoration withOpacity(double opacity) => copyWith(opacity: opacity);
  ImageDecoration copyWith({Hash? image, double? opacity}) => .new(
    id,
    image ?? this.image,
    opacity: opacity ?? this.opacity,
  );
}

final class const ShaderDecoration(
  super.id,
  final ShaderBlueprint shader, {
  final double opacity = 1.0,
}) extends Decoration with Equatable {
  factory create(ShaderBlueprint shader, {double opacity = 1.0}) => .new(uuid.v4(), shader, opacity: opacity);
  factory createEmpty() => .create(.empty());

  @override
  DecorationKind get kind => .shader;

  @override
  List<Object?> get props => [id, shader, opacity];

  @override
  ShaderDecoration _withId(String id) => .new(id, shader, opacity: opacity);

  @override
  ShaderDecoration withOpacity(double opacity) => copyWith(opacity: opacity);
  ShaderDecoration copyWith({ShaderBlueprint? shader, double? opacity}) => .new(
    id,
    shader ?? this.shader,
    opacity: opacity ?? this.opacity,
  );
}

final class const Decorations(final List<Decoration> entries) {
  static const none = Decorations([]);
  static final white = Decorations([.color(.white)]);
  static final black = Decorations([.color(.black)]);

  static Decorations color(ColorData color) => Decorations([.color(color)]);
  static Decorations image(Hash? image) => Decorations([.image(image)]);

  Iterable<ColorDecoration> get colors => entries.whereType<ColorDecoration>();
  Iterable<ImageDecoration> get images => entries.whereType<ImageDecoration>();
  Iterable<ShaderDecoration> get shaders => entries.whereType<ShaderDecoration>();

  bool get isEmpty => entries.isEmpty;
  bool get isNotEmpty => entries.isNotEmpty;

  @override
  int get hashCode => Object.hashAll(entries);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Decorations) return false;
    return listEquals(entries, other.entries);
  }
  
  int indexOf(String id) => entries.indexWhere((e) => e.id == id);

  Decorations append(Decoration d) => .new([...entries, d]);
  Decorations appendAll(Iterable<Decoration> decorations) => .new([...entries, ...decorations]);

  Decorations remove(String id) {
    final out = entries.toList();
    out.removeAt(indexOf(id));
    return .new(out);
  }

  Decorations update(String id, Decoration d) {
    final out = entries.toList();
    out[indexOf(id)] = d._withId(id);
    return .new(out);
  }

  Decorations reorder(int i, int j) {
    final out = entries.toList();
    final moved = out.removeAt(i);
    out.insert(j, moved);
    return .new(out);
  }
}
