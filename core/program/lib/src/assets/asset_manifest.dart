part of '../_program.dart';

typedef AssetResolver = Future<Uint8List> Function(AssetId);

final class AssetManifest {
  AssetManifest(this.entries);
  AssetManifest.empty() : entries = {};

  final Map<Hash, Asset> entries;
  Asset? operator [](AssetId id) => entries[id.hash];
  bool contains(AssetId id) => entries.containsKey(id.hash);

  void insertUnsynced(Asset asset) => entries[asset.hash] = asset;

  void _insertAll(Iterable<Asset> assets) {
    for (final asset in assets) {
      entries[asset.hash] = asset;
    }
  }

  void _removeAll(Iterable<Asset> assets) {
    for (final asset in assets) {
      entries.remove(asset.hash);
    }
  }
}
