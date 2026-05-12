part of '../webgpu.g.dart';

// ignore_for_file: unused_element

typedef InstanceCallbackDriver =
    void Function(
      List<WeakReference<Instance>>,
      List<WeakReference<Adapter>>,
      List<WeakReference<Device>>,
    );

class Instance extends _InstanceBase with _InstanceImpl {
  Instance._(super.ptr) : super._();
  Instance._borrowed(super.ptr) : super._borrowed();

  static final _instances = <WeakReference<Instance>>[];
  static final _adapters = <WeakReference<Adapter>>[];
  static final _devices = <WeakReference<Device>>[];

  factory Instance.create([InstanceDescriptor? descriptor]) {
    final instance = _createInstance(descriptor);
    _instances.add(WeakReference(instance));
    return instance;
  }

  static SupportedInstanceFeatures get features => _getInstanceFeatures();
  static InstanceLimits get limits => _getInstanceLimits();
  static bool hasFeature(InstanceFeatureName feature) => _hasInstanceFeature(feature);

  static InstanceCallbackDriver? asyncCallbackDriverOverride;
  static void asyncDriver() {
    if (asyncCallbackDriverOverride != null) {
      asyncCallbackDriverOverride!(_instances, _adapters, _devices);
    } else {
      for (final ref in _instances) {
        ref.target?.processEvents();
      }
    }
  }

  static InstanceCallbackDriver? syncCallbackDriverOverride;
  static void syncDriver() {
    if (syncCallbackDriverOverride != null) {
      syncCallbackDriverOverride!(_instances, _adapters, _devices);
    } else {
      for (final ref in _instances) {
        ref.target?.processEvents();
      }
    }
  }
}

mixin _InstanceImpl on _InstanceBase {
  SupportedWGSLLanguageFeatures get wgslLanguageFeatures => _getWGSLLanguageFeaturesImpl();
  bool hasWgslLanguageFeature(WGSLLanguageFeatureName feature) => _hasWGSLLanguageFeatureImpl(feature);

  void processEvents() => _processEventsImpl();

  Adapter _onAdapterObtained(Adapter adapter) {
    Instance._adapters.add(WeakReference(adapter));
    return adapter;
  }

  Future<Adapter> requestAdapter([RequestAdapterOptions? options]) async {
    final adapter = await _requestAdapterImpl(options);
    return _onAdapterObtained(adapter);
  }

  Adapter requestAdapterSync([RequestAdapterOptions? options]) {
    final adapter = _requestAdapterSyncImpl(options);
    return _onAdapterObtained(adapter);
  }

  Surface createSurface(SurfaceDescriptor descriptor) => _createSurfaceImpl(descriptor);
}
