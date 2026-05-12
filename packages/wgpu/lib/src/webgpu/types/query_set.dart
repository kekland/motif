part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _QuerySetImpl on _QuerySetBase {
  void destroy() => _destroyImpl();
  int get count => _getCountImpl();
  QueryType get type => _getTypeImpl();
  set label(String label) => _setLabelImpl(label);
}
