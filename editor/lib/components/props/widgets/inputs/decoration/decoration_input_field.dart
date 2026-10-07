import 'package:color/color_flutter.dart';
import 'package:editor/imports.dart';
import 'package:file_picker/file_picker.dart';

part 'decoration_input_window.dart';

final class const DecorationInputField({
  super.key,
  required final Editor editor,
  required super.value,
  super.onChanged,
  super.sessionCallbacks,
}) extends InputField<Decoration> {
  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    final scene = editor.scene;
    final value = useProxyComputed(this.value, (value) => value!);
    final kind = useProxyComputedValue(value, (value) => value.kind);

    final window = usePortalEntry(
      () => WindowEntry(
        builder: (context) => DecorationInputWindow(
          editor: editor,
          field: this,
        ),
        isModal: true,
      ),
      [value],
    );

    final leadingBody = switch (kind) {
      .color => HookBuilder(
        builder: (context) {
          final color = useProxyComputedValue(value, (value) => (value as ColorDecoration).color);
          return ColoredBox(color: color.toUiColor());
        },
      ),
      .image => HookBuilder(
        builder: (context) {
          final id = useProxyComputedValue(value, (value) => (value as ImageDecoration).image);
          if (id == null) return SizedBox.shrink();
          return RawImage(image: scene.assetCache.image[id]);
        },
      ),
    };

    final leading = GestureSurface(
      onTap: () => window.push(context),
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: context.colors.inverse.withScaledAlpha(0.05)),
      width: iconTheme.size ?? 16.0,
      height: iconTheme.size ?? 16.0,
      child: leadingBody,
    );

    final opacity = useProxyComputed(
      value,
      (value) => switch (value) {
        ColorDecoration(:final color) => color.alpha * 100.0,
        ImageDecoration(:final opacity) => opacity * 100.0,
      },
    );

    final opacityInput = DoubleExpressionInputField(
      value: opacity,
      fractionDigits: 1,
      onChanged: (a) => onChanged?.call(value().withOpacity(a / 100)),
      options: .new(
        hintText: '0',
        trailing: Text('%'),
        borderRadius: .horizontal(right: .circular(4.0)),
        color: context.colors.surface.secondary.withScaledAlpha(0.0),
        padding: const .only(left: 8.0, right: 6.0),
        border: .new(color: context.colors.divider.withScaledAlpha(0.0)),
        supportedDevices: {.mouse, .trackpad},
      ),
    );

    final bodyOptions = InputFieldOptions(
      leading: leading,
      borderRadius: .horizontal(left: .circular(4.0)),
      color: context.colors.surface.secondary.withScaledAlpha(0.0),
      border: .new(color: context.colors.divider.withScaledAlpha(0.0)),
      supportedDevices: {.mouse, .trackpad},
    );

    final body = switch (kind) {
      .color => _ColorDecorationBody(
        value: value,
        onChanged: (v) => onChanged?.call(v),
        options: bodyOptions,
      ),
      .image => _ImageDecorationBody(
        value: value,
        options: bodyOptions,
        onTap: () => window.push(context),
      ),
    };

    return Stack(
      children: [
        Positioned.fill(
          child: Surface(
            color: context.colors.surface.secondary,
            borderSide: .new(color: context.colors.divider),
            borderRadius: .circular(4.0),
          ),
        ),
        Positioned(
          right: 80.0,
          child: SizedBox(height: 32.0, child: VerticalDivider()),
        ),
        GestureSurface(
          onTap: () => window.push(context),
          supportedDevices: {.stylus, .touch},
          borderRadius: .circular(4.0),
          child: Row(
            children: [
              Expanded(
                child: body,
              ),
              SizedBox(
                width: 80.0,
                child: opacityInput,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class const _ColorDecorationBody({
  super.key,
  required final InputFieldOptions options,
  required final ReadonlySignal<Decoration> value,
  final ValueChanged<Decoration>? onChanged,
  final InputSessionCallbacks? sessionCallbacks,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _value = useCastComputed<ColorDecoration>(value);

    return ExpressionInputField<ColorDataPartial>(
      value: useProxyComputed(_value, (v) => v.color.partial),
      onChanged: (v) => onChanged?.call(.color(v.apply(_value().color))),
      valueToString: (value) => value?.canConstruct == true ? value!.apply(.black).toString() : 'Mixed',
      evaluateExpression: (str) => null,
      options: options,
    );
  }
}

final class const _ImageDecorationBody({
  super.key,
  required final ReadonlySignal<Decoration> value,
  required final InputFieldOptions options,
  final VoidCallback? onTap,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ValueInputField(
      value: value,
      options: options,
      onTap: onTap,
      valueToString: (d) => 'Image',
    );
  }
}
