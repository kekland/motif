part of '../generator.dart';

extension ArrayInfoExt on ArrayInfo {
  String get dartTypedefName => '${format.extensionName}Array${count > 0 ? count : ''}';
  String get internalTypedefName => '${dartTypedefName}Internal';
}
