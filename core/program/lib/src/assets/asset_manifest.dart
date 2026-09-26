part of '../_program.dart';

final class AssetManifest {
  AssetManifest();
  AssetManifest.empty();

  final _assets = <Hash, ProgramAsset>{};

  ProgramAsset? operator [](Hash hash) => _assets[hash];
}
