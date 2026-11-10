part of '../_program.dart';

typedef AssetFetchListener = void Function(StatementId);

abstract class AssetCache {
  FontCache get font;

  void addFetchListener(AssetFetchListener listener);
  void removeFetchListener(AssetFetchListener listener);

  FutureOr<void> add(Asset asset, Uint8List data);
  FutureOr<void> fetch(StatementId? statementId, Asset asset);
  FutureOr<ImageData?> fetchImage(StatementId? statementId, ImageAsset asset);

  void dispose();
}

final class ImageData({
  required final ByteData bytes,
  required final int width,
  required final int height,
});

abstract class FontCache {
  skia.FontProvider get provider;

  Future<void> add(FontAsset asset, Uint8List bytes);

  void dispose();
}
