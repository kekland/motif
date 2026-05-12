part of 'tile_grid.dart';

const double tileSize = 128.0;

class TileBucket {
  TileBucket(this.x, this.y, {required this.tileSize}) : _quads = [];

  final int x;
  final int y;
  final double tileSize;
  final List<Quadratic2> _quads;

  Iterable<Quadratic2> get quads => _quads;
  ui.Rect get canvasBounds => ui.Rect.fromLTWH(x * tileSize, y * tileSize, tileSize, tileSize);

  void addQuad(Quadratic2 quad) => _quads.add(quad);
}
