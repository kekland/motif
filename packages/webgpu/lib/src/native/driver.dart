import 'wgpu.g.dart';

typedef InstanceCallbackDriver = void Function(
  List<WeakReference<Instance>>,
  List<WeakReference<Adapter>>,
  List<WeakReference<Device>>,
);

final _instances = <WeakReference<Instance>>[];
final _adapters = <WeakReference<Adapter>>[];
final _devices = <WeakReference<Device>>[];

void registerInstance(Instance instance) => _instances.add(WeakReference(instance));
void registerAdapter(Adapter adapter) => _adapters.add(WeakReference(adapter));
void registerDevice(Device device) => _devices.add(WeakReference(device));

void _clean() {
  _instances.removeWhere((ref) => ref.target == null);
  _adapters.removeWhere((ref) => ref.target == null);
  _devices.removeWhere((ref) => ref.target == null);
}

InstanceCallbackDriver? asyncCallbackDriverOverride;
void asyncDriver() {
  _clean();

  if (asyncCallbackDriverOverride != null) {
    asyncCallbackDriverOverride!(_instances, _adapters, _devices);
  } else {
    for (final ref in _instances) ref.target?.processEvents();
  }
}

InstanceCallbackDriver? syncCallbackDriverOverride;
void syncDriver() {
  _clean();

  if (syncCallbackDriverOverride != null) {
    syncCallbackDriverOverride!(_instances, _adapters, _devices);
  } else {
    for (final ref in _instances) ref.target?.processEvents();
  }
}
