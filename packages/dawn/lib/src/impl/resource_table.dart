part of '../src.dart';
// ignore_for_file: unused_element

class ResourceTable extends _ResourceTable {
  ResourceTable._(super.ptr) : super._();
  ResourceTable._borrowed(super.ptr) : super._borrowed();

  void destroy() => _resourceTableDestroy(this);
  int get size => _resourceTableGetSize(this);
  int insertBinding(BindingResource resource) => _resourceTableInsertBinding(this, resource);
  Status removeBinding(int bindingIndex) => _resourceTableRemoveBinding(this, bindingIndex);
  void setLabel(String label) => _resourceTableSetLabel(this, label);
  Status update(int slot, BindingResource resource) => _resourceTableUpdate(this, slot, resource);
}
