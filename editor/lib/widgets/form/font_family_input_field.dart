import 'package:editor/imports.dart';

class FontFamilyInputField extends InputField<FontFamilyId> {
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
      () => WindowEntry<FontFamilyId>(
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

    return ValueInputField<FontFamilyId>(
      onTap: () async {
        final result = await window.push(context, anchor: .compute(context, axis: .horizontal));
        if (result != null) onChanged?.call(result);
      },
      value: value,
      valueToString: (v) => v?.name,
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

  final InputField<FontFamilyId> field;
  final Map<String, FontCatalog> catalogs;

  @override
  Widget build(BuildContext context) {
    final query = useState<String?>(null);
    final catalog = catalogs.values.first;
    final families = catalog.assets.values.toList();

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
        child: SearchableSelectableList<FontAsset>(
          focusNode: FocusScope.of(context),
          items: families,
          selection: selection.value,
          query: query.value,
          onSubmit: (v) => Navigator.of(context).pop(v?.id),
          filter: (q) => families.where((f) => f.family.toLowerCase().contains(q)).toList(),
          builder: (context, items) => ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final family = items[i];

              return SelectableListItem(
                key: ValueKey(family),
                value: family,
                builder: (context, isSelected) => ListItem(
                  onTap: () => Navigator.of(context).pop(family.id),
                  isSelected: isSelected,
                  title: CustomPaint(
                    size: .infinite,
                    painter: _FontFamilyPainter(
                      asset: family,
                      color: context.colors.display.primary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FontFamilyPainter extends CustomPainter {
  _FontFamilyPainter({required this.asset, required this.color});

  final FontAsset asset;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = asset.thumbnail.path.toUiPath();

    // Resize to fit into 24px height
    final height = asset.thumbnail.height;
    final scale = 24.0 / height;

    canvas.translate(0, (size.height - asset.thumbnail.height * scale) / 2);
    canvas.scale(scale, scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FontFamilyPainter oldDelegate) => color != oldDelegate.color || asset != oldDelegate.asset;
}
