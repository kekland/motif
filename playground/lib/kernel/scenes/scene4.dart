import 'package:debug/kernel/scenes/simulation.dart';

final class SceneSimulationGenerators extends SceneSimulation {
  Generator produceGenerator(double x, double y) {
    var generator = Generator();
    generator.disconnect(generator.inputNode.o.slice.ref, generator.outputNode.i.slice.ref);
    final array = ArrayNode(
      count: .new(x.toDouble(), y.toDouble()),
      offset: .new(200, 200),
    );

    generator = generator.add(ArrayNode());
    generator = generator.connect(generator.inputNode.o.slice.ref, array.i.slice.ref);
    generator = generator.connect(array.o.slice.ref, generator.outputNode.i.slice.ref);
    return generator;
  }

  late GeneratorStatement _generatorStatement;

  @override
  Scene initialize() {
    final scene = Scene.empty();

    final generator = produceGenerator(3, 3);

    scene.edit((txn) {
      final rectangle = txn.insert(
        RectangleStatement(size: .fixed(100, 100)),
      );

      _generatorStatement = txn.insert(
        GeneratorStatement(
          generator: generator,
          selectors: [.new(rectangle.id)],
        ),
      );
    });

    return scene;
  }

  @override
  void update(Scene scene, double t) {
    scene.edit((txn) {
      txn.update<GeneratorStatement>(_generatorStatement.id, (g) {
        final newGenerator = produceGenerator(3 + 20 * t, 3 + 20 * t);
        return g.copyWith(generator: newGenerator);
      });
    });
  }
}
