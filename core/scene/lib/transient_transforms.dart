// part of 'scene.dart';

// final class SceneTransientTransforms with ChangeNotifier, ChangeNotifierDisposable {
//   SceneTransientTransforms(this.scene);
//   final Scene scene;

//   final _local = <FrameRef, Mat4>{};
//   final _global = <FrameRef, Mat4>{};

//   Mat4? local(FrameRef frame) => _local[frame];
//   Mat4? global(FrameRef frame) => _global[frame];

//   void setLocal(FrameRef frame, Mat4? transform) => _set(_local, frame, transform);
//   void setGlobal(FrameRef frame, Mat4? transform) => _set(_global, frame, transform);

//   void _set(Map<FrameRef, Mat4> map, FrameRef frame, Mat4? transform) {
//     final before = map[frame];
//     if (transform == null ? before == null : before != null && before.equals(transform)) return;

//     if (transform == null) {
//       map.remove(frame);
//     } else {
//       map[frame] = transform;
//     }
//     notifyListeners();
//   }
// }
