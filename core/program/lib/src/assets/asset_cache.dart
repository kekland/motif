part of '../_program.dart';

typedef AssetFetchListener = void Function(StatementId);

abstract class AssetCache {
  FontCache get font;

  void addFetchListener(AssetFetchListener listener);
  void removeFetchListener(AssetFetchListener listener);

  FutureOr<void> add(Asset asset, Uint8List data);
  FutureOr<void> fetch(StatementId? statementId, Asset asset);

  void dispose();
}

abstract class FontCache {
  skia.FontProvider get provider;

  Future<void> add(FontAsset asset, Uint8List bytes);

  void dispose();
}
