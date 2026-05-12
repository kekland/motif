part of '../src.dart';
// ignore_for_file: unused_element

class QuerySet extends _QuerySet {
  QuerySet._(super.ptr) : super._();
  QuerySet._borrowed(super.ptr) : super._borrowed();

  void destroy() => _querySetDestroy(this);
  int get count => _querySetGetCount(this);
  QueryType get type => _querySetGetType(this);
  void setLabel(String label) => _querySetSetLabel(this, label);
}
