import 'generator/blueprint_generator.dart';
export 'generator/blueprint_generator.dart';

final class GeneratedBlueprintCode {
  new({
    required this.blueprintCode,
    required this.codecCode,
    required this.protoCode,
  });

  final List<String> blueprintCode;
  final List<String> codecCode;
  final List<String> protoCode;
}

GeneratedBlueprintCode generateFullBlueprint({
  List<NodeDescription> nodes = const [],
  List<SocketDescription> sockets = const [],
  List<String> prelude = const [],
}) {
  final blueprintCode = generateBlueprint(nodes: nodes, sockets: sockets, prelude: prelude);
  final codecCode = generateBlueprintCodec(nodes: nodes, sockets: sockets);
  final protoCode = generateBlueprintProto(nodes: nodes, sockets: sockets);

  return GeneratedBlueprintCode(
    blueprintCode: blueprintCode,
    codecCode: codecCode,
    protoCode: protoCode,
  );
}
