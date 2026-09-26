import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

final class TextStyle extends NativeObject<gen.text_style> {
  TextStyle({double? fontSize, List<String>? fontFamilies}) : super(gen.motif_text_style_create()) {
    if (fontSize != null) this.fontSize = fontSize;
    if (fontFamilies != null) this.fontFamilies = fontFamilies;
  }

  static final _finalizer = NativeFinalizer(gen.addresses.motif_text_style_destroy.cast());

  double get fontSize => gen.motif_text_style_get_font_size(ptr);
  set fontSize(double size) => gen.motif_text_style_set_font_size(ptr, size);

  List<String> get fontFamilies => using(
    (arena) => readListString(
      arena,
      gen.motif_text_style_get_font_families_count(ptr),
      (index, buffer) => gen.motif_text_style_get_font_family(ptr, index, buffer),
    ),
  );

  set fontFamilies(List<String> families) => using((arena) {
    final buffer = writeListString(arena, families);
    gen.motif_text_style_set_font_families(ptr, buffer, families.length);
  });

  @override
  void attachFinalizer(Pointer<Void> ptr) => _finalizer.attach(this, ptr, detach: this);

  @override
  void detachFinalizer() => _finalizer.detach(this);

  @override
  void destroy() => gen.motif_text_style_destroy(ptr);
}
