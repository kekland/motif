part of '../generator.dart';

extension OverrideInfoExt on OverrideInfo {
  String get dartName => toDartMemberName(name);
}
