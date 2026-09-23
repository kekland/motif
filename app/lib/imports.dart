export 'package:program/program.dart';
export 'package:scene/scene.dart';
export 'package:editor/editor.dart';
export 'package:state/state.dart';
export 'package:ui/ui.dart';

export 'app/app.dart';
export 'storage/storage.dart';

const serverUrl = String.fromEnvironment('SERVER_URL', defaultValue: 'http://localhost:8085');
final Uri serverUri = Uri.parse(serverUrl);