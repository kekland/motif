part of '../_program.dart';

enum DecorationKind { color, image }

sealed class const Decoration() {
  const factory color(ColorData color) = ColorDecoration;
  const factory image(Hash? image) = ImageDecoration;

  DecorationKind get kind;

  Decoration withOpacity(double opacity);
}

final class const ColorDecoration(final ColorData color) extends Decoration with Equatable {
  @override
  DecorationKind get kind => .color;

  @override
  List<Object?> get props => [color];

  @override
  ColorDecoration withOpacity(double opacity) => .new(color.withAlpha(opacity));
}

final class const ImageDecoration(
  final Hash? image, {
  final double opacity = 1.0,
}) extends Decoration with Equatable {
  @override
  DecorationKind get kind => .image;

  @override
  List<Object?> get props => [image, opacity];

  @override
  ImageDecoration withOpacity(double opacity) => .new(image, opacity: opacity);
}

final class const Decorations(final List<Decoration> entries) {
  static const none = Decorations([]);
  static const white = Decorations([.color(.white)]);
  static const black = Decorations([.color(.black)]);

  Iterable<ColorDecoration> get colors => entries.whereType<ColorDecoration>();
  Iterable<ImageDecoration> get images => entries.whereType<ImageDecoration>();

  @override
  int get hashCode => Object.hash(runtimeType, Object.hashAll(entries));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Decorations) return false;
    return listEquals(entries, other.entries);
  }

  Decorations append(Decoration d) => .new([...entries, d]);
  Decorations appendAll(Iterable<Decoration> decorations) => .new([...entries, ...decorations]);

  Decorations remove(int index) {
    final out = entries.toList();
    out.removeAt(index);
    return .new(out);
  }

  Decorations update(int index, Decoration d) {
    final out = entries.toList();
    out[index] = d;
    return .new(out);
  }

  Decorations reorder(int i, int j) {
    final out = entries.toList();
    final moved = out.removeAt(i);
    out.insert(j, moved);
    return .new(out);
  }
}
