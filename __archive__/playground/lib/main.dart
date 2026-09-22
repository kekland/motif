// import 'package:debug/kernel/kernel_debug.dart';
import 'package:debug/kernel/scene_debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:signals/signals.dart';

void main() {
  SignalsObserver.instance = null;
  runApp(const DebugApp());
}

class DebugApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: .dark(),
      showPerformanceOverlay: true,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final vmServiceUrl = connectedVmServiceUri;
            // ignore: avoid_print
            print(vmServiceUrl);
          },
          child: const Icon(Icons.copy),
        ),
        body: SceneDebug(),
      ),
    );
  }
}
