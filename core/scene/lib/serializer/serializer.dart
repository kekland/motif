import 'dart:convert';

import 'package:color/color.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:scene/scene.dart';
import 'package:schema/schema.dart' as pb;

part 'scene_codec.dart';
part 'delta_codec.dart';
part 'utils.dart';

class SceneCodec {
  static pb.Scene encodeScene(Scene scene) => _sceneCodec.encode(scene);
  static Scene decodeScene(pb.Scene scene) => _sceneCodec.decode(scene);

  static pb.Program encodeProgram(Program scene) => _programCodec.encode(scene);
  static Program decodeProgram(pb.Program scene) => _programCodec.decode(scene);

  static pb.SceneSlice encodeSceneSlice(SceneSlice slice) => _sceneSliceCodec.encode(slice);
  static SceneSlice decodeSceneSlice(pb.SceneSlice slice) => _sceneSliceCodec.decode(slice);

  static pb.Statement encodeStatement(Statement statement) => _statementCodec.encode(statement);
  static T decodeStatement<T extends Statement>(pb.Statement statement) => _statementCodec.decode(statement) as T;
}

extension SceneEncode on Scene {
  pb.Scene encode() => SceneCodec.encodeScene(this);
}

extension SceneSliceEncode on SceneSlice {
  pb.SceneSlice encode() => _sceneSliceCodec.encode(this);
}
