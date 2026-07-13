import 'package:flutter/foundation.dart';
import 'package:stack/stack.dart';
import '../vc.dart';

export 'geometry_symbol.dart';

class SymbolManager with ChangeNotifier, ChangeNotifierDisposable {
  SymbolManager() : symbols = [];

  final List<GeometrySymbol> symbols;

  GeometrySymbol createSymbol(CellBundle bundle) {
    final g = GeometrySymbol(bundle: bundle);
    addSymbol(g);
    return g;
  }

  void addSymbol(GeometrySymbol g) {
    symbols.add(g);
    notifyListeners();
  }

  void removeSymbol(GeometrySymbol g) {
    symbols.remove(g);
    notifyListeners();
  }

  GeometrySymbol? operator [](Object id) => symbols.firstWhereOrNull((g) => g.id == id);
}
