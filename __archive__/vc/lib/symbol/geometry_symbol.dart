import 'package:flutter/foundation.dart';
import '../vc.dart';

extension type SymbolId(String value) implements String {}

class GeometrySymbol {
  GeometrySymbol({required this.bundle}) : id = .new(shortHash(UniqueKey()));
  GeometrySymbol.from({required List<Cell> cells}) : this(bundle: .new(cells: cells));

  final SymbolId id;
  final CellBundle bundle;
}
