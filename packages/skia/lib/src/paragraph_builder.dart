import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

final class ParagraphBuilder extends NativeObject<gen.paragraph_builder> {
  ParagraphBuilder(ParagraphStyle style, FontProvider provider)
    : super(gen.motif_paragraph_builder_create(style.ptr, provider.ptr));

  static final _finalizer = NativeFinalizer(gen.addresses.motif_paragraph_builder_destroy.cast());

  void addText(String text) => using((arena) {
    text.runes;
    gen.motif_paragraph_builder_add_text(ptr, text.toNativeUtf8(allocator: arena).cast());
  });

  void pushStyle(TextStyle style) => gen.motif_paragraph_builder_push_style(ptr, style.ptr);
  void popStyle() => gen.motif_paragraph_builder_pop_style(ptr);

  Paragraph build() => Paragraph(gen.motif_paragraph_builder_build(ptr));

  @override
  void attachFinalizer(Pointer<Void> ptr) => _finalizer.attach(this, ptr, detach: this);

  @override
  void detachFinalizer() => _finalizer.detach(this);

  @override
  void destroy() => gen.motif_paragraph_builder_destroy(ptr);
}
