import 'package:renderer/dbg_renderer.dart';
import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';

Bundle _produce() {
  final bundle = Bundle();
  // var txn = bundle.beginTransaction(namespace: 2);

  // final v0Op = txn.apply(AddVertexOp(.zero()));

  // final v0 = v0Op.result! as VertexHandle;
  // final v1 = txn.addVertex(.new(100, 0));
  // final v2 = txn.addVertex(.new(100, 100));
  // final v3 = txn.addVertex(.new(0, 100));

  // final e0 = txn.addEdge(v0, v1);
  // final e1 = txn.addEdge(v1, v2);
  // final e2 = txn.addEdge(v2, v3);
  // final e3 = txn.addEdge(v3, v0);

  // final f = txn.addFace(
  //   [
  //     .walk([e0, e1, e2, e3]),
  //   ],
  // );

  // final v1Id = v1.ref(bundle);
  // final eId = e0.ref(bundle);
  // // final op1 = txn.apply(CutEdgeOp(eId, [0.25, 0.5, 0.75]));
  // txn.commit();

  // txn = bundle.beginTransaction(namespace: 3);
  // // final cutOp = txn.apply(CutEdgeOp(eId, [0.25, 0.5, 0.75]));
  // // final op2 = txn.filletFace(f, {
  // //   v0: .new(10, 10),
  // //   v1: .new(10, 10),
  // //   v2: .new(10, 10),
  // //   v3: .new(20, 20),
  // // });
  // txn.commit();

  // // txn = bundle.beginTransaction(namespace: 2);
  // // txn.update(v0Op, AddVertexOp(.new(10, 10)));
  // // txn.commit();

  // // txn = bundle.beginTransaction(namespace: 3);
  // // txn.update(cutOp, CutEdgeOp(eId, [0.3, 0.6, 0.9]));
  // // txn.commit();

  return bundle;
}

class KernelDebug extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    late final Bundle? bundle;
    String? error;
    try {
      bundle = _produce();
    } catch (e) {
      bundle = null;
      error = e.toString();
      // print(e);
    }

    return Scaffold(
      body: InteractiveViewer(
        child: Center(
          child: bundle != null
              ? CustomPaint(
                  painter: BundlePainter(bundle: bundle),
                  size: .square(1.0),
                )
              : Text(error ?? 'Unknown error'),
        ),
      ),
    );
  }
}
