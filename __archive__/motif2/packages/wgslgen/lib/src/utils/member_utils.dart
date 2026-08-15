part of '../generator.dart';

extension MemberInfoExt on MemberInfo {
  String get dartType => type.dartType;
  String get dartDefaultValue => type.dartDefaultValue;
  String get internalType => type.internalType;
  String get internalDefaultValue => type.internalDefaultValue;

  String get dartName => toDartMemberName(name);
}

extension ListMemberInfoExt on List<MemberInfo> {
  String get nameTuple => map((m) => m.dartName).join(', ');
  String get namePassthroughArgs => map((m) => '${m.dartName}: ${m.dartName}').join(', ');
  String get dartTuple => map((m) => '${m.type.dartName} ${m.dartName}').join(', ');
  String get internalTuple => map((m) => '${m.type.internalName} ${m.dartName}').join(', ');

  String get dartNamedCtorArgs => map((m) => '${m.type.dartName} ${m.dartName} = ${m.dartDefaultValue}').join(', ');
  String get dartCtorArgs => map((m) => '${m.type.dartName} ${m.dartName}').join(', ');

  String get dartZeroValuesTuple => map((m) => m.dartDefaultValue).join(', ');
  String get internalZeroValuesTuple => map((m) => m.internalDefaultValue).join(', ');
}
