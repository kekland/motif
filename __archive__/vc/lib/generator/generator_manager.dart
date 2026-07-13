import 'package:flutter/foundation.dart';
import 'package:stack/stack.dart';
import '../vc.dart';

class GeneratorManager with ChangeNotifier, ChangeNotifierDisposable {
  GeneratorManager() : generators = [];

  final List<Generator> generators;

  Generator createGenerator() {
    final g = Generator();
    addGenerator(g);
    return g;
  }

  void addGenerator(Generator g) {
    generators.add(g);
    notifyListeners();
  }

  void removeGenerator(Generator g) {
    generators.remove(g);
    notifyListeners();
  }

  Generator? operator [](Object id) => generators.firstWhereOrNull((g) => g.id == id);
}
