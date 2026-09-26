part of '../_program.dart';

extension type const Hash._(String value) {}

typedef AssetResolver = Future<Uint8List> Function(Program, ProgramAsset);

sealed class ProgramAsset {
  ProgramAsset({required this.size});

  final int size;
  Hash get hash;
}

final class FontAsset extends ProgramAsset {
  FontAsset({
    required super.size,
    required this.family,
    required this.weight,
    required this.italic,
    this.index = 0,
  });

  final String family;
  final int weight;
  final bool italic;
  final int index;

  @override
  Hash get hash => throw UnimplementedError();
}
