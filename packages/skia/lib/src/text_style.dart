import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

final class TextStyle extends NativeObject<gen.text_style> {
  TextStyle({
    double? fontSize,
    List<String>? fontFamilies,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) : super(gen.motif_text_style_create()) {
    if (fontSize != null) this.fontSize = fontSize;
    if (fontFamilies != null) this.fontFamilies = fontFamilies;
    if (height != null) this.height = height;
    if (letterSpacing != null) this.letterSpacing = letterSpacing;
    if (fontStyle != null) this.fontStyle = fontStyle;
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

  double get height => gen.motif_text_style_get_height(ptr);
  set height(double height) => gen.motif_text_style_set_height(ptr, height);

  double get letterSpacing => gen.motif_text_style_get_letter_spacing(ptr);
  set letterSpacing(double letterSpacing) => gen.motif_text_style_set_letter_spacing(ptr, letterSpacing);

  FontStyle get fontStyle {
    final out = gen.motif_text_style_get_font_style(ptr);
    return FontStyle(weight: .new(out.weight), width: .new(out.width), slant: .values[out.slant.value]);
  }

  set fontStyle(FontStyle style) => using((arena) {
    final nativeStyle = arena<gen.text_style_font_style>();
    nativeStyle.ref.weight = style.weight;
    nativeStyle.ref.width = style.width;
    nativeStyle.ref.slantAsInt = gen.text_style_font_style_slant.values[style.slant.index].value;
    gen.motif_text_style_set_font_style(ptr, nativeStyle.ref);
  });

  @override
  void attachFinalizer(Pointer<Void> ptr) => _finalizer.attach(this, ptr, detach: this);

  @override
  void detachFinalizer() => _finalizer.detach(this);

  @override
  void destroy() => gen.motif_text_style_destroy(ptr);
}
