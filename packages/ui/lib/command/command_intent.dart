part of 'command.dart';

sealed class CommandArg<T>();

bool get _isApple => switch (defaultTargetPlatform) {
  .macOS || .iOS => true,
  _ => false,
};

class PlatformSingleActivator extends SingleActivator {
  PlatformSingleActivator(
    super.key, {
    bool control = false,
    super.shift = false,
    super.alt = false,
  }) : super(
         meta: _isApple && control,
         control: !_isApple && control,
       );
}

abstract class const CommandIntent() extends Intent;

class CommandIntentDescriptor<I extends CommandIntent> {
  CommandIntentDescriptor({
    required this.build,
    required this.command,
    this._resolveDescription,
    this._resolveShortcut,
  });

  final I Function(BuildContext context, List<CommandArg<dynamic>> args) build;
  final String command;
  final String? Function(BuildContext context)? _resolveDescription;
  final List<SingleActivator> Function(BuildContext context)? _resolveShortcut;

  String? resolveDescription(BuildContext context) => _resolveDescription?.call(context);
  List<SingleActivator> resolveShortcut(BuildContext context) => _resolveShortcut?.call(context) ?? const [];
}

abstract class CommandAction<I extends CommandIntent> extends ContextAction<I> {
  CommandIntentDescriptor<I> get descriptor;

  bool canInvoke(BuildContext context, I intent) => true;
  Object? performInvoke(BuildContext context, I intent);

  @override
  bool isEnabled(I intent, [BuildContext? context]) => canInvoke(context!, intent);

  @override
  Object? invoke(I intent, [BuildContext? context]) => performInvoke(context!, intent);
}
