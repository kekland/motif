part of '../src.dart';

extension _StringViewExt on StringView {
  String toDartString() {
    if (length == 0) return '';
    if (data == null) return '';
    return data!;
  }
}
