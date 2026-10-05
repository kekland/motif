part of '../editor.dart';

class EditorBuiltinAssets {
  EditorBuiltinAssets._({
    required this.catalog,
    required this.licenses,
  });

  static const _fontManifestFile = 'packages/editor/assets/builtin/font_manifest.pb';
  static const _licenseBundleFile = 'packages/editor/assets/builtin/license_bundle.pb';
  static const _fontFileFolder = 'packages/editor/assets/builtin/fonts';

  static var _initialized = false;
  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _logger.info('initializing EditorBuiltinFonts');
    var manifest = AssetManifest.decodeRaw((await rootBundle.load(_fontManifestFile)).buffer.asUint8List());
    var licenses = LicenseBundle.decodeRaw((await rootBundle.load(_licenseBundleFile)).buffer.asUint8List());

    if (manifest == null) {
      _logger.warning('failed to decode asset manifest');
      manifest = .empty();
    }

    if (licenses == null) {
      _logger.warning('failed to decode license bundle');
      licenses = .new(licenses: {});
    }

    _instance = EditorBuiltinAssets._(catalog: .fromAssets(manifest.fonts), licenses: licenses);
  }

  static EditorBuiltinAssets get instance => _instance!;
  static EditorBuiltinAssets? _instance;

  final FontCatalog catalog;
  final LicenseBundle licenses;

  bool contains(Hash hash) => catalog.contains(hash);

  Future<Uint8List> load(Hash hash) async {
    return (await rootBundle.load('$_fontFileFolder/$hash')).buffer.asUint8List();
  }
}
