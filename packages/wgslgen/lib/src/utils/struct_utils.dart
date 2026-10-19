part of '../generator.dart';

extension StructInfoExt on StructInfo {
  List<MemberInfo> get visibleMembers => members.where((m) => !m.name.startsWith('_')).toList();

  bool get isVertexIOStruct {
    final allHaveLocation =
        members.isNotEmpty &&
        members.every((m) => m.attributes.any((a) => a.name == 'location' || a.name == 'builtin'));

    return allHaveLocation;
  }

  String get dartTypedefName => toDartTopLevelName(name);
  String get internalTypedefName => '${dartTypedefName}Internal';
  String get dartStructName => '${dartTypedefName}Struct';

  String get dartStructFromCtor => '$dartStructName.from';
}
