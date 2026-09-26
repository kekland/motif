import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

final class ParagraphStyle extends NativeObject<gen.paragraph_style> {
  ParagraphStyle() : super(gen.motif_paragraph_style_create());
  static final _finalizer = NativeFinalizer(gen.addresses.motif_paragraph_style_destroy.cast());

  @override
  void attachFinalizer(Pointer<Void> ptr) => _finalizer.attach(this, ptr, detach: this);

  @override
  void detachFinalizer() => _finalizer.detach(this);

  @override
  void destroy() => gen.motif_paragraph_style_destroy(ptr);
}
