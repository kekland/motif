part of '../generator.dart';

List<String> generateArray(ArrayInfo info) {
  final lines = <String>[];

  lines.add('typedef ${info.dartTypedefName} = ${info.dartType};');
  lines.add('typedef ${info.internalTypedefName} = ${info.internalType};');

  return lines;
}