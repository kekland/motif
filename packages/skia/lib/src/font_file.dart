import 'dart:typed_data';

import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

final class FontFaceInfo({
  required final int index,
  required final FontWeight weight,
  required final FontWidth width,
  required final FontSlant slant,
  required final String family,
});

class FontFile extends NativeObject<gen.font_file> {
  FontFile._(super.ptr);
  static final _finalizer = NativeFinalizer(gen.addresses.motif_font_file_destroy.cast());

  static FontFile? create(Uint8List bytes) => using((arena) {
    final data = arena<Uint8>(bytes.length);
    data.asTypedList(bytes.length).setAll(0, bytes);
    final ptr = gen.motif_font_file_create(data, bytes.length);
    return ptr != nullptr ? ._(ptr) : null;
  });

  List<FontFaceInfo> get faces => using((arena) {
    final out = arena<gen.font_face>();
    final count = gen.motif_font_file_face_count(ptr);
    return .generate(count, (i) {
      gen.motif_font_file_get_face(ptr, i, out);
      final face = out.ref;
      return .new(
        index: face.index,
        weight: .new(face.weight),
        width: .new(face.width),
        slant: .fromNative(face.slant),
        family: face.family.cast<Utf8>().toDartString(),
      );
    });
  });

  @override
  void attachFinalizer(Pointer<Void> ptr) => _finalizer.attach(this, ptr, detach: this);

  @override
  void detachFinalizer() => _finalizer.detach(this);

  @override
  void destroy() => gen.motif_font_file_destroy(ptr);
}
