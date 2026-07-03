// import 'package:flutter/foundation.dart';
// import 'package:stack/stack.dart';
// import 'package:vc/vc.dart';

// class GeometrySymbol {
//   const GeometrySymbol({required this.id, required this.complex});

//   factory GeometrySymbol.fromCells(List<Cell> cells, {required SymbolManager manager}) {
//     final vertices = <Vertex, Vertex>{};
//     for (final v in cells.whereType<Vertex>()) {
//       vertices[v] = v.copyWith();
//     }

//     final edges = <Edge, Edge>{};
//     for (final e in cells.whereType<Edge>()) {
//       final v1 = vertices.putIfAbsent(e.start, () => e.start.copyWith());
//       final v2 = vertices.putIfAbsent(e.end, () => e.end.copyWith());
//       edges[e] = e.copyWith(start: v1, end: v2);
//     }

//     final newCells = <Cell>[];
//     for (final c in cells) {
//       final instance = switch (c) {
//         Vertex v => vertices[v]!,
//         Edge e => edges[e]!,
//       };

//       newCells.add(instance);
//     }

//     final complex = VectorComplexBase(cells: newCells);
//     return GeometrySymbol(id: 0, complex: complex);
//   }

//   final int id;
//   final VectorComplexBase complex;
// }

// class SymbolManager with ChangeNotifier, ChangeNotifierDisposable {
//   SymbolManager(this._symbols);

//   final Map<int, GeometrySymbol> _symbols;

//   GeometrySymbol? getSymbol(int id) => _symbols[id];
//   GeometrySymbol? getSymbolAt(int index) => _symbols.values.elementAt(index);

//   int get symbolCount => _symbols.length;

//   void addSymbol(GeometrySymbol symbol) {
//     _symbols[symbol.id] = symbol;
//     notifyListeners();
//   }

//   void removeSymbol(int id) {
//     _symbols.remove(id);
//     notifyListeners();
//   }
// }
