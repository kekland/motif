part of '../_program.dart';

typedef AssetFetchListener = void Function(StatementId);

abstract class AssetCache {
  FontCache get font;

  void addFetchListener(AssetFetchListener listener);
  void removeFetchListener(AssetFetchListener listener);

  FutureOr<void> add(AssetId id, Uint8List data);
  FutureOr<void> fetch(StatementId? statementId, AssetId id);

  void dispose();
}

abstract class FontCache {
  skia.FontProvider get provider;

  void dispose();
}
