import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

enum TextAlignment {
  left,
  right,
  center,
  justify,
  start,
  end;

  factory TextAlignment.fromNative(gen.text_alignment v) => .values[v.index];
  gen.text_alignment get asNative => gen.text_alignment.values[index];
}

final class ParagraphStyle extends NativeObject<gen.paragraph_style> {
  ParagraphStyle({
    TextAlignment? alignment,
    String? ellipsis,
  }) : super(gen.motif_paragraph_style_create()) {
    gen.motif_paragraph_style_set_apply_rounding_hack(ptr, false);
    if (alignment != null) this.alignment = alignment;
    if (ellipsis != null) this.ellipsis = ellipsis;
  }

  static final _finalizer = NativeFinalizer(gen.addresses.motif_paragraph_style_destroy.cast());

  TextAlignment get alignment => TextAlignment.fromNative(gen.motif_paragraph_style_get_alignment(ptr));
  set alignment(TextAlignment value) => gen.motif_paragraph_style_set_alignment(ptr, value.asNative);

  String? get ellipsis => using((arena) {
    final str = readString(arena, (buffer) => gen.motif_paragraph_style_get_ellipsis(ptr, buffer));
    if (str.isEmpty) return null;
    return str;
  });

  set ellipsis(String? value) => using((arena) {
    final _value = value ?? '';
    gen.motif_paragraph_style_set_ellipsis(ptr, _value.toNativeUtf8(allocator: arena).cast());
  });

  @override
  void attachFinalizer(Pointer<Void> ptr) => _finalizer.attach(this, ptr, detach: this);

  @override
  void detachFinalizer() => _finalizer.detach(this);

  @override
  void destroy() => gen.motif_paragraph_style_destroy(ptr);
}
