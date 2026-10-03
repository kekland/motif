part of '../editor.dart';

class EditorBuiltinFonts {
  EditorBuiltinFonts._({
    required this.catalog,
    required this.licenses,
  });

  static const _fontCatalogFile = 'packages/editor/assets/builtin/font_catalog.pb';
  static const _licenseBundleFile = 'packages/editor/assets/builtin/license_bundle.pb';
  static const _fontFileFolder = 'packages/editor/assets/builtin/fonts';

  static var _initialized = false;
  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _logger.info('initializing EditorBuiltinFonts');
    var catalog = FontCatalog.decodeRaw((await rootBundle.load(_fontCatalogFile)).buffer.asUint8List());
    var licenses = LicenseBundle.decodeRaw((await rootBundle.load(_licenseBundleFile)).buffer.asUint8List());

    if (catalog == null) {
      _logger.warning('failed to decode font catalog');
      catalog = .new(assets: {});
    }

    if (licenses == null) {
      _logger.warning('failed to decode license bundle');
      licenses = .new(licenses: {});
    }

    _instance = EditorBuiltinFonts._(catalog: catalog, licenses: licenses);
  }

  static EditorBuiltinFonts get instance => _instance!;
  static EditorBuiltinFonts? _instance;

  final FontCatalog catalog;
  final LicenseBundle licenses;

  Future<Uint8List> loadFontFile(String hash) async {
    return (await rootBundle.load('$_fontFileFolder/$hash')).buffer.asUint8List();
  }
}
