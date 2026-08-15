part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _AdapterImpl on _AdapterBase {
  Device _onDeviceObtained(Device device) {
    Instance._devices.add(WeakReference(device));
    return device;
  }

  Future<Device> requestDevice([DeviceDescriptor? descriptor]) async {
    final device = await _requestDeviceImpl(descriptor);
    return _onDeviceObtained(device);
  }

  Device requestDeviceSync([DeviceDescriptor? descriptor]) {
    final device = _requestDeviceSyncImpl(descriptor);
    return _onDeviceObtained(device);
  }

  SupportedFeatures get features => _getFeaturesImpl();
  bool hasFeature(FeatureName feature) => _hasFeatureImpl(feature);

  AdapterInfo get info => _getInfoImpl();
  Limits get limits => _getLimitsImpl();
}
