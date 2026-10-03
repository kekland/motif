import 'package:sync_server/embedded.dart';
import 'package:ui/ui.dart';

export 'package:program/program.dart';
export 'package:scene/scene.dart';
export 'package:editor/editor.dart';
export 'package:state/state.dart';
export 'package:ui/ui.dart';

export 'app/app.dart';
export 'env.dart';

extension EmbeddedServerContext on BuildContext {
  EmbeddedServer get embeddedServer => read<EmbeddedServer>();
}
