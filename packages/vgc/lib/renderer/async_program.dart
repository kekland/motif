import 'dart:ui' as ui;

class AsyncFragmentProgram {
  AsyncFragmentProgram(this.key);

  final String key;

  ui.FragmentProgram? _program;
  Future<void>? _loadingFuture;

  bool get isLoaded => _program != null;
  ui.FragmentProgram get program => _program!;

  Future<void> load() async {
    if (_program != null) return;
    if (_loadingFuture != null) return _loadingFuture!;

    _loadingFuture = ui.FragmentProgram.fromAsset(key).then((p) => _program = p);
    return _loadingFuture!;
  }
}
