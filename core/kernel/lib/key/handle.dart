import 'package:kernel/kernel.dart';

export 'handle_native.dart' if (dart.library.js) 'handle_js.dart';

extension CellHandleUtils on CellHandle {
  FrameHandle get asFrame {
    assert(kind == .frame);
    return .raw(this);
  }

  VertexHandle get asVertex {
    assert(kind == .vertex);
    return .raw(this);
  }

  EdgeHandle get asEdge {
    assert(kind == .edge);
    return .raw(this);
  }

  FaceHandle get asFace {
    assert(kind == .face);
    return .raw(this);
  }

  CellRef ref(Bundle bundle) => bundle.ref(this);

}
