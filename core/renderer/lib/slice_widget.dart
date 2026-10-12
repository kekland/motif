import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:renderer/renderer.dart';
import 'package:scene/scene.dart';
import 'package:ui/ui.dart';

final class const FrameWidget({
  super.key,
  required final Scene scene,
  required final FrameRef ref,
  final BoxFit fit = .contain,
  final Alignment alignment = .center,
  final Clip clipBehavior = .none,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final bbox = scene.query.bbox([ref.statementId]);

    return FittedBox(
      fit: fit,
      alignment: alignment,
      clipBehavior: clipBehavior,
      child: Transform.translate(
        offset: Offset(-bbox.left, -bbox.top),
        child: SizedBox(
          width: bbox.width,
          height: bbox.height,
          child: SceneWidget(scene: scene, root: ref),
        ),
      ),
    );
  }
}
