part of '../src.dart';
// ignore_for_file: unused_element

class Adapter extends _Adapter {
  Adapter._(super.ptr) : super._();
  Adapter._borrowed(super.ptr) : super._borrowed();

  Device createDevice([DeviceDescriptor? descriptor]) => _adapterCreateDevice(this, descriptor);
  Future<Device> requestDevice([DeviceDescriptor? descriptor]) => _adapterRequestDevice(this, descriptor);

  SupportedFeatures get features => _adapterGetFeatures(this);
  bool hasFeature(FeatureName feature) => _adapterHasFeature(this, feature);

  AdapterInfo get info => _adapterGetInfo(this);
  Instance get instance => _adapterGetInstance(this);
  Limits get limits => _adapterGetLimits(this);
}
