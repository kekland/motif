part of '../src.dart';

// ignore_for_file: unused_element

class Instance extends _Instance {
  Instance._(super.ptr) : super._();
  Instance._borrowed(super.ptr) : super._borrowed();

  static bool _procsInitialized = false;
  factory Instance.create([InstanceDescriptor? descriptor]) {
    if (!_procsInitialized) {
      bindings.dawn_init();
      _procsInitialized = true;
    }

    return _createInstance(descriptor);
  }

  static SupportedInstanceFeatures get features => _getInstanceFeatures();
  static InstanceLimits get limits => _getInstanceLimits();
  static bool hasFeature(InstanceFeatureName feature) => _hasInstanceFeature(feature);
  SupportedWGSLLanguageFeatures get wgslLanguageFeatures => _instanceGetWGSLLanguageFeatures(this);
  bool hasWgslLanguageFeature(WGSLLanguageFeatureName feature) => _instanceHasWGSLLanguageFeature(this, feature);
  void processEvents() => _instanceProcessEvents(this);
  Future<Adapter> requestAdapter([RequestAdapterOptions? options]) => _instanceRequestAdapter(this, options);
}
