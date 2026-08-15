import 'dart:convert';

import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:scene/scene.dart';
import 'package:schema/scene.dart' as pb;

part 'codecs.dart';
part 'utils.dart';

class SceneCodec {
  static pb.Scene encodeScene(Scene scene) => _sceneCodec.encode(scene);
  static Scene decodeScene(pb.Scene scene) => _sceneCodec.decode(scene);

  static pb.Program encodeProgram(Program scene) => _programCodec.encode(scene);
  static Program decodeProgram(pb.Program scene) => _programCodec.decode(scene);

  static pb.Statement encodeStatement(Statement statement) => _statementCodec.encode(statement);
  static T decodeStatement<T extends Statement>(pb.Statement statement) => _statementCodec.decode(statement) as T;
}

extension SceneEncode on Scene {
  pb.Scene serialize() => SceneCodec.encodeScene(this);
}
