part of '../generator.dart';

extension StringUtils on String {
  String indent([int level = 1]) => '  ' * level + this;
}

extension StringListUtils on Iterable<String> {
  List<String> indent([int level = 1]) => map((l) => '  ' * level + l).toList();
}

String _toPascalCase(String str) => str.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join();

String _toCamelCase(String str) {
  final pascal = _toPascalCase(str);
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String toDartTopLevelName(String str) => _toPascalCase(str);
String toDartMemberName(String str) {
  if (str.startsWith('_')) return str.substring(1);
  return _toCamelCase(str);
}
