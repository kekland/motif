import 'package:flutter/widgets.dart';

final reassembleProviderKey = GlobalKey<ReassembleProviderState>();

class ReassembleProvider extends StatefulWidget {
  ReassembleProvider({required this.child}) : super(key: reassembleProviderKey);

  static ReassembleProviderState get instance => reassembleProviderKey.currentState!;
  static void register(VoidCallback callback) => instance.register(callback);
  static void unregister(VoidCallback callback) => instance.unregister(callback);

  final Widget child;

  @override
  State<ReassembleProvider> createState() => ReassembleProviderState();
}

class ReassembleProviderState extends State<ReassembleProvider> {
  final _reassembleCallbacks = <VoidCallback>{};

  void register(VoidCallback callback) => _reassembleCallbacks.add(callback);
  void unregister(VoidCallback callback) => _reassembleCallbacks.remove(callback);

  @override
  void reassemble() {
    super.reassemble();
    for (final callback in _reassembleCallbacks) callback();
  }

  @override
  void dispose() {
    _reassembleCallbacks.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
