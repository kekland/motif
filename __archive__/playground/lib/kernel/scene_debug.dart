// ignore_for_file: unused_import

import 'package:debug/kernel/scenes/scene1.dart';
import 'package:debug/kernel/scenes/scene2.dart';
import 'package:debug/kernel/scenes/scene3.dart';
import 'package:debug/kernel/scenes/scene4.dart';
import 'package:debug/kernel/scenes/simulation.dart';
import 'package:flutter/material.dart';
import 'package:renderer/renderer.dart';

class SceneDebug extends StatefulWidget {
  const new({super.key});

  @override
  State<SceneDebug> createState() => _SceneDebugState();
}

class _SceneDebugState extends State<SceneDebug> with TickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  late final simulations = <String, SceneSimulation Function()>{
    'Stars fillets': SceneSimulationStarsFillets.new,
    'Shapes': SceneSimulationShapes.new,
    'Auto Layout': SceneSimulationAutoLayout.new,
    'Generators': SceneSimulationGenerators.new,
  };

  late final _tabController = TabController(length: simulations.length, vsync: this);

  SceneSimulation? simulation;
  var index = 0;

  void _createSimulation() {
    simulation?.dispose();
    simulation = simulations.values.elementAt(index)();
  }

  @override
  void initState() {
    super.initState();
    _createSimulation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    simulation?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _createSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 0.1,
              constrained: false,
              boundaryMargin: .all(.infinity),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  simulation!.update(simulation!.scene, _animation.value);

                  return Center(
                    child: SceneWidget(
                      scene: simulation!.scene,
                      debug: false,
                    ),
                  );
                },
              ),
            ),
          ),
          Divider(height: 1.0),
          TabBar(
            controller: _tabController,
            onTap: (i) {
              index = i;
              _createSimulation();
            },
            tabs: simulations.keys.map((name) => Tab(text: name)).toList(),
          ),
        ],
      ),
    );
  }
}
