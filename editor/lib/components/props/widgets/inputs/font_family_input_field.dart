import 'package:editor/imports.dart';

class FontFamilyInputField extends InputField<String> {
  const new({
    super.key,
    required super.value,
    super.sessionCallbacks,
    super.onChanged,
    super.options,
  });

  @override
  Widget build(BuildContext context) {
    final editor = Editor.of(context);

    final window = usePortalEntry(
      () => WindowEntry<String>(
        builder: (context) => FontFamilyPickerWindow(
          field: this,
          catalogs: {
            'builtin': editor.builtinFonts.catalog,
          },
        ),
        isModal: true,
      ),
      [value],
    );

    return ValueInputField<String>(
      onTap: () async {
        final result = await window.push(context, anchor: .compute(context, axis: .horizontal));
        if (result != null) onChanged?.call(result);
      },
      value: value,
      sessionCallbacks: sessionCallbacks,
      onChanged: onChanged,
      options: options,
    );
  }
}

class FontFamilyPickerWindow extends HookWidget {
  const new({
    super.key,
    required this.field,
    required this.catalogs,
  });

  final InputField<String> field;
  final Map<String, FontCatalog> catalogs;

  @override
  Widget build(BuildContext context) {
    final query = useState<String?>(null);
    final catalog = catalogs.values.first;
    final families = catalog.families.values.toList();

    final selection = useMemoComputed(() {
      final id = field.value();
      return id != null ? catalog[id] : null;
    }, keys: [field.value]);

    return WindowScaffold(
      largeHeader: true,
      title: TextField(
        onChanged: (v) => query.value = v.trim().toLowerCase(),
        options: .new(
          autofocus: true,
          leading: Icons.search(),
          hintText: 'Search fonts',
        ),
      ),
      child: SizedBox(
        width: 240.0,
        height: 400.0,
        child: SearchableSelectableList<FontFamily>(
          focusNode: FocusScope.of(context),
          items: families,
          selection: selection.value,
          query: query.value,
          onSubmit: (v) => Navigator.of(context).pop(v?.name),
          filter: (q) => families.where((f) => f.name.toLowerCase().contains(q)).toList(),
          builder: (context, items) => ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final family = items[i];

              return SelectableListItem(
                key: ValueKey(family),
                value: family,
                builder: (context, isSelected) => ListItem(
                  onTap: () => Navigator.of(context).pop(family.name),
                  isSelected: isSelected,
                  title: family.thumbnail != null
                      ? CustomPaint(
                          size: .infinite,
                          painter: _FontThumbnailPainter(
                            thumbnail: family.thumbnail!,
                            color: context.colors.display.primary,
                          ),
                        )
                      : Text(family.name),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FontThumbnailPainter extends CustomPainter {
  _FontThumbnailPainter({required this.thumbnail, required this.color});

  final FontFaceThumbnail thumbnail;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = thumbnail.path.toUiPath();

    // Resize to fit into 24px height
    final height = thumbnail.height;
    final scale = 24.0 / height;

    canvas.translate(0, (size.height - thumbnail.height * scale) / 2);
    canvas.scale(scale, scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FontThumbnailPainter oldDelegate) =>
      color != oldDelegate.color || thumbnail != oldDelegate.thumbnail;
}
