part of 'decoration_input_field.dart';

class const DecorationInputWindow({
  super.key,
  required final Editor editor,
  required final DecorationInputField field,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final kind = useProxyComputedValue(field.value, (v) => v.kind);

    return WindowScaffold(
      title: ButtonRow(
        buttons: [
          IconButton.flat(
            onTap: () {
              if (kind == .color) return;
              final decoration = ColorDecoration(.white);
              field.onChanged?.call(decoration);
            },
            isSelected: kind == .color,
            child: Icons.decorationColor(),
          ),
          IconButton.flat(
            child: Icons.decorationGradient(),
          ),
          IconButton.flat(
            onTap: () {
              if (kind == .image) return;
              final decoration = ImageDecoration(null);
              field.onChanged?.call(decoration);
            },
            isSelected: kind == .image,
            child: Icons.decorationImage(),
          ),
        ],
      ),
      child: SizedBox(
        width: 240.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: switch (kind) {
            .color => _ColorDecorationInputBody(
              key: ValueKey(kind),
              editor: editor,
              value: field.value,
              onChanged: field.onChanged,
              sessionCallbacks: field.sessionCallbacks,
            ),
            .image => _ImageDecorationInputBody(
              key: ValueKey(kind),
              editor: editor,
              value: field.value,
              onChanged: field.onChanged,
              sessionCallbacks: field.sessionCallbacks,
            ),
          },
        ),
      ),
    );
  }
}

final class const _ColorDecorationInputBody({
  super.key,
  required final Editor editor,
  required final ReadonlySignal<Decoration> value,
  final ValueChanged<Decoration>? onChanged,
  final InputSessionCallbacks? sessionCallbacks,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _value = useCastComputed<ColorDecoration>(value);

    return ColorInputWindowBody(
      value: useProxyComputed(_value, (v) => v.color.partial),
      onChanged: (v) => onChanged?.call(.color(v.apply(_value().color))),
      sessionCallbacks: sessionCallbacks,
    );
  }
}

final class const _ImageDecorationInputBody({
  super.key,
  required final Editor editor,
  required final ReadonlySignal<Decoration> value,
  final ValueChanged<Decoration>? onChanged,
  final InputSessionCallbacks? sessionCallbacks,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _value = useCastComputed<ImageDecoration>(value);
    final id = useProxyComputedValue(_value, (v) => v.image);

    return Surface(
      borderSide: .new(color: context.colors.divider),
      borderRadius: .circular(4.0),
      color: context.colors.surface.tertiary,
      height: 200.0,
      child: Stack(
        children: [
          if (id != null) Center(child: RawImage(image: editor.scene.assetCache.image[id])),
          Center(
            child: Button(
              onTap: () async {
                final result = await FilePicker.pickFile(
                  dialogTitle: 'Select an image',
                  type: .image,
                );

                if (result == null) return;

                final data = await result.readAsBytes();
                final id = await editor.uploadImageAsset(data, mimeType: result.xFile.mimeType ?? 'image');
                onChanged?.call(.image(id));
              },
              child: Text('Upload'),
            ),
          ),
        ],
      ),
    );
  }
}
