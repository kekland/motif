import 'dart:typed_data';

import 'package:skia/src/gen/skia_bindings.g.dart' as gen;
import 'package:skia/internal.dart';

class FontProvider extends NativeObject<gen.font_provider> {
  FontProvider() : super(gen.motif_font_provider_create());
  static final _finalizer = NativeFinalizer(gen.addresses.motif_font_provider_destroy.cast());

  bool add(Uint8List bytes, {String? family, int index = 0}) => using((arena) {
    final data = arena<Uint8>(bytes.length);
    data.asTypedList(bytes.length).setAll(0, bytes);

    final alias = family != null ? family.toNativeUtf8(allocator: arena) : nullptr;
    return gen.motif_font_provider_add(ptr, data, bytes.length, index, alias.cast()) != 0;
  });

  int get familyCount => gen.motif_font_provider_family_count(ptr);

  List<String> get families => using(
    (arena) => readListString(
      arena,
      familyCount,
      (index, buffer) => gen.motif_font_provider_family_name(ptr, index, buffer),
    ),
  );

  @override
  void attachFinalizer(Pointer<Void> ptr) => _finalizer.attach(this, ptr, detach: this);

  @override
  void detachFinalizer() => _finalizer.detach(this);

  @override
  void destroy() => gen.motif_font_provider_destroy(ptr);
}
