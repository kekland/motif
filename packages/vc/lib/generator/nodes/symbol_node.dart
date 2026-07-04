part of '../blueprint.dart';

class SymbolNode extends SymbolNodeBase {
  SymbolNode();

  @override
  void execute() {
    final symbolManager = context.symbol;
    final id = i.symbolId.resolve().value;
    if (id == null) {
      o.geometry.value = .constant(.empty());
      return;
    }

    final symbol = symbolManager[id];
    if (symbol == null) {
      print('warning: no symbol found');
      o.geometry.value = .constant(.empty());
      return;
    }

    final bundle = symbol.bundle.deflate(context);
    o.geometry.value = .constant(bundle);
  }
}
