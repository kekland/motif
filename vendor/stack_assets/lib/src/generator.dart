import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:stack_assets/src/asset_manifest.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart' as vgc;

extension _FileExt on File {
  String get name {
    final parts = uri.pathSegments.last.split('.');
    return parts.length > 1 ? parts.sublist(0, parts.length - 1).join('.') : uri.pathSegments.last;
  }

  String get ext => uri.pathSegments.last.split('.').last;
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
String _toCamelCase(String s) {
  final separators = RegExp(r'[_\s-.]+');
  final segments = s.split(separators).where((s) => s.isNotEmpty).toList();

  return [
    segments[0].toLowerCase(),
    ...segments.skip(1).map((s) => _capitalize(s)),
  ].join();
}

abstract class Node {
  const Node();

  String get name;

  Future<Node> process(Directory outputDir);
}

class AssetRootNode extends Node {
  const AssetRootNode({required this.directory, required this.categories});

  final List<AssetCategoryNode> categories;
  final Directory directory;

  @override
  Future<AssetRootNode> process(Directory outputDir) async {
    if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

    return AssetRootNode(
      directory: directory,
      categories: await Future.wait(categories.map((c) => c.process(outputDir))),
    );
  }

  @override
  String get name => 'Assets';

  String get className => 'Assets';
  String get recordName => 'assets';
}

class AssetSubcategoryNode extends Node {
  const AssetSubcategoryNode({required this.directory, required this.children});

  final List<Node> children;
  final Directory directory;

  @override
  Future<AssetSubcategoryNode> process(Directory outputDir) async {
    final _outputDir = Directory.fromUri(outputDir.uri.resolve('$name/'));
    if (!_outputDir.existsSync()) _outputDir.createSync(recursive: true);

    return AssetSubcategoryNode(
      directory: directory,
      children: await Future.wait(children.map((c) => c.process(_outputDir))),
    );
  }

  @override
  String get name => _toCamelCase(directory.uri.pathSegments[directory.uri.pathSegments.length - 2]);

  Map<String, AssetShape> get leafShapes {
    final shapes = <String, List<AssetShape>>{};

    void _traverse(Node node, List<String> path) {
      if (node is AssetNode) {
        shapes[node.assetName] ??= [];
        shapes[node.assetName]!.add(
          AssetShape(
            name: node.assetName,
            classType: node.classType,
            selectors: [path],
            isSingleColor: node.isSingleColor,
          ),
        );
      } else if (node is AssetSubcategoryNode) {
        for (final child in node.children) _traverse(child, [...path, node.name]);
      }
    }

    for (final child in children) _traverse(child, []);
    final result = <String, AssetShape>{};

    for (final key in shapes.keys) {
      final values = shapes[key]!;
      final selectorCount = values.first.selectors[0].length;
      if (values.any((v) => v.selectors[0].length != selectorCount)) {
        throw Exception('Inconsistent selector count for asset "$key"');
      }

      final selectors = <Set<String>>[];
      for (var i = 0; i < selectorCount; i++) {
        selectors.add(values.map((v) => v.selectors[0][i]).toSet());
      }

      final shape = AssetShape(
        name: key,
        classType: values.first.classType,
        selectors: selectors.map((s) => s.toList()).toList(),
        isSingleColor: values.every((s) => s.isSingleColor),
      );

      result[key] = shape;
    }

    return result;
  }

  String resolveClassName(Directory inputRoot) {
    final relativePath = directory.uri.pathSegments.skip(inputRoot.uri.pathSegments.length - 1).join('/');
    final segments = relativePath.split('/').where((s) => s.isNotEmpty).toList();
    final className = segments.reversed.map((s) => _capitalize(_toCamelCase(s))).join();
    return '${className}Assets';
  }

  String resolveRecordName(Directory inputRoot) {
    final className = resolveClassName(inputRoot);
    return className[0].toLowerCase() + className.substring(1);
  }
}

class AssetCategoryNode extends AssetSubcategoryNode {
  const AssetCategoryNode({required super.directory, required super.children});

  @override
  Future<AssetCategoryNode> process(Directory outputDir) async {
    final result = await super.process(outputDir);
    return AssetCategoryNode(directory: result.directory, children: result.children);
  }
}

class AssetShape {
  const AssetShape({
    required this.name,
    required this.classType,
    required this.selectors,
    this.isSingleColor = false,
  });

  final String name;
  final String classType;
  final List<List<String>> selectors;
  final bool isSingleColor;

  List<List<String>> get permutations {
    if (selectors.isEmpty) return [[]];

    List<List<String>> result = [[]];
    for (final selectorSet in selectors) {
      final newResult = <List<String>>[];
      for (final selector in selectorSet) {
        for (final existing in result) {
          newResult.add([...existing, selector]);
        }
      }
      result = newResult;
    }

    return result;
  }
}

class AssetNode extends Node {
  const AssetNode({required this.file, this.preprocessContents});

  final File file;
  final Uint8List? preprocessContents;

  bool get isSingleColor {
    if (ext != 'svg' && ext != 'vec') return false;

    final xml = preprocessContents != null ? utf8.decode(preprocessContents!) : file.readAsStringSync();
    final parsed = vgc.parse(xml);
    final colors = <vgc.Color>{};

    for (final p in parsed.paints) {
      if (p.fill != null) colors.add(p.fill!.color);
      if (p.stroke != null) colors.add(p.stroke!.color);
    }

    return colors.length <= 1;
  }

  @override
  String get name => file.name;

  String get fullName => file.uri.pathSegments.last;

  String get ext => file.ext.toLowerCase();

  String get classType => switch (ext) {
    'svg' || 'vec' => 'AssetBytesLoader',
    'png' || 'jpg' || 'jpeg' || 'gif' || 'bmp' || 'webp' => 'AssetImage',
    _ => 'String',
  };

  String get assetName => _toCamelCase(name);

  @override
  Future<AssetNode> process(Directory outputDir) async {
    if (ext == 'svg') {
      final optimized = vgc.encodeSvg(
        xml: file.readAsStringSync(),
        useHalfPrecisionControlPoints: true,
        enableClippingOptimizer: true,
        enableMaskingOptimizer: true,
        enableOverdrawOptimizer: true,
        debugName: file.uri.pathSegments.last,
      );

      final outputFile = File.fromUri(outputDir.uri.resolve('$name.vec'));
      await outputFile.writeAsBytes(optimized);
      return AssetNode(file: outputFile, preprocessContents: await file.readAsBytes());
    } else {
      final outputFile = File.fromUri(outputDir.uri.resolve(fullName));
      await file.copy(outputFile.path);
      return AssetNode(file: outputFile, preprocessContents: await file.readAsBytes());
    }
  }

  String resolvePath(Directory root) => file.uri.pathSegments.skip(root.uri.pathSegments.length - 2).join('/');
}

AssetRootNode _parseAssetTree(AssetManifest manifest) {
  final assetsDir = manifest.assetsDirectory;
  final inputDir = Directory.fromUri(assetsDir.uri.resolve(manifest.inputDirectoryName));
  final categories = <AssetCategoryNode>[];

  AssetSubcategoryNode _parseSubcategory(Directory dir) {
    final children = <Node>[];

    for (final file in dir.listSync().whereType<File>()) children.add(AssetNode(file: file));
    for (final dir in dir.listSync().whereType<Directory>()) children.add(_parseSubcategory(dir));

    return AssetSubcategoryNode(directory: dir, children: children);
  }

  for (final dir in inputDir.listSync().whereType<Directory>()) {
    final category = AssetCategoryNode(
      directory: dir,
      children: _parseSubcategory(dir).children.toList(),
    );

    categories.add(category);
  }

  return AssetRootNode(directory: assetsDir, categories: categories);
}

Future<List<String>> generateAssets(AssetManifest manifest) async {
  // Configuration
  vgc.initializePathOpsFromFlutterCache();

  final pn = manifest.package != null ? '\'${manifest.package!}\'' : 'null';

  // Parse tree and process assets
  final inputDirectory = Directory.fromUri(manifest.assetsDirectory.uri.resolve(manifest.inputDirectoryName));

  var root = _parseAssetTree(manifest);
  root = await root.process(Directory.fromUri(root.directory.uri.resolve(manifest.outputDirectoryName)));

  // Prepare code
  final blocks = <List<String>>[];
  final imports = <String>{};

  Map<String, (String, String?)> _traverseNode(Node node, List<String> path, List<CategoryResolver>? resolvers) {
    if (node is AssetNode) return {node.assetName: (node.classType, node.resolvePath(root.directory))};
    if (node is AssetSubcategoryNode) {
      final result = <String, (String, String?)>{};
      final childResolvers = resolvers?.skip(1).toList();
      for (final child in node.children) result.addAll(_traverseNode(child, [...path, node.name], childResolvers));

      final code = <String>[];
      final className = node.resolveClassName(inputDirectory);
      final recordName = node.resolveRecordName(inputDirectory);

      // Generate resolvers for leaf nodes if this category has resolvers defined
      final resolvableIcons = <String, String>{};
      final shape = node.leafShapes;
      if (resolvers != null && resolvers.isNotEmpty) {
        for (final entry in shape.entries) {
          final assetName = entry.key;
          final classType = entry.value.classType;
          final permutations = entry.value.permutations;

          final fnName = '_${recordName}_${assetName}_resolver';
          final args = resolvers.map((r) => 'required ${r.type} ${r.name}').join(', ');
          code.add('$classType $fnName({$args}) {');
          code.add('  return switch ((${resolvers.map((r) => r.name).join(', ')})) {');

          for (final p in permutations) {
            final c = p.map((v) => '.$v').join(', ');
            final parts = ['assets', ...path, node.name, ...p, assetName];
            code.add('    ($c) => ${parts.join('.')},');
          }

          code.add('  };');
          code.add('}');
          code.add('');

          if (node is AssetCategoryNode) {
            final contextFnName = '_${recordName}_${assetName}_contextResolver';
            code.add('$classType $contextFnName(BuildContext context) {');
            code.add('  return $fnName(');
            for (final r in resolvers) {
              code.add('    ${r.name}: ${r.getter},');
            }
            code.add('  );');
            code.add('}');
            code.add('');
          }

          resolvableIcons[assetName] = fnName;
        }
      }

      code.add('class $className {');
      code.add('  const $className();');
      code.add('');
      for (final entry in result.entries) {
        if (entry.value.$2 == null) {
          code.add('  static const ${entry.key} = ${entry.value.$1};');
        } else {
          if (entry.value.$1 == 'String') {
            code.add('  static const ${entry.key} = \'${entry.value.$2}\';');
          } else {
            code.add('  static const ${entry.key} = ${entry.value.$1}(\'${entry.value.$2}\', packageName: $pn);');
          }
        }
      }

      for (final resolvable in resolvableIcons.entries)
        code.add('  static const ${resolvable.key} = ${resolvable.value};');

      code.add('}');
      code.add('');
      code.add('const $recordName = (');
      for (final entry in result.entries) code.add('  ${entry.key}: $className.${entry.key},');
      for (final resolvable in resolvableIcons.entries) code.add('  ${resolvable.key}: $className.${resolvable.key},');
      code.add(');');

      blocks.add(code);
      return {node.name: (recordName, null)};
    }

    return {};
  }

  // Assets code
  {
    final code = <String>[];
    code.add('class Assets {');
    code.add('  const Assets();');
    code.add('');

    for (final category in root.categories) {
      final recordName = category.resolveRecordName(inputDirectory);
      code.add('  static const ${category.name} = $recordName;');
    }

    code.add('}');
    code.add('');
    code.add('const assets = (');
    for (final category in root.categories) code.add('  ${category.name}: Assets.${category.name},');
    code.add(');');
    blocks.add(code);

    for (final category in root.categories) {
      _traverseNode(
        category,
        [],
        manifest.categoryResolvers[category.name],
      );
    }
  }

  // Icons code
  {
    final iconCategories = root.categories
        .where((c) => c.leafShapes.values.every((s) => s.classType == 'AssetBytesLoader'))
        .toList();

    if (iconCategories.isNotEmpty) {
      final code = <String>[];
      code.add(_baseIconTemplate);

      for (final category in iconCategories) {
        final shape = category.leafShapes;
        var _cname = category.name;
        if (_cname.endsWith('Icons')) _cname = _cname.substring(0, _cname.length - 5);

        final className = category.name == 'icons' ? 'Icons' : _capitalize('${_cname}Icons');
        code.add('class $className extends _BaseIcon {');

        String _getBasicLoaderFnName(String assetName) => '${category.resolveClassName(inputDirectory)}.$assetName';

        String _getSelectorLoaderFnName(String assetName) =>
            '_${category.resolveRecordName(inputDirectory)}_${assetName}_contextResolver';

        for (final entry in shape.entries) {
          final assetName = entry.key;
          final filledAsset = shape['${assetName}Fill'] ?? shape['${assetName}Filled'];
          final isSingleColor = entry.value.isSingleColor;
          final selectors = entry.value.selectors;
          final hasSelectors = selectors.isNotEmpty;

          String _getLoaderFnName(String assetName) =>
              hasSelectors ? _getSelectorLoaderFnName(assetName) : _getBasicLoaderFnName(assetName);

          final args = '{super.key, super.size, super.color}';
          final loaderFn = _getLoaderFnName(assetName);
          final loaderFnFilled = filledAsset != null ? _getLoaderFnName(filledAsset.name) : null;

          final superName = hasSelectors ? 'super.vgSelector' : 'super.vgBasic';

          code.add(
            '  const $className.$assetName($args) : $superName(loader: $loaderFn, filledLoader: $loaderFnFilled, autocolor: $isSingleColor);',
          );
        }

        if (className == 'Icons') {
          final iconDataIcons = manifest.icons;

          for (final data in iconDataIcons) {
            final name = data.name;
            final iconData = data.iconData;

            final args = '{super.key, super.size, super.color}';
            code.add('  const $className.$name($args): super.iconData(icon: $iconData);');

            if (iconData.startsWith('Symbols.')) {
              imports.add('package:material_symbols_icons/material_symbols_icons.dart');
            } else if (iconData.startsWith('Icons.')) {
              imports.add('package:flutter/material.dart');
            }
          }
        }

        code.add('}');
        code.add('');
      }

      blocks.add(code);
    }
  }

  blocks.insert(0, [
    '// GENERATED CODE - DO NOT MODIFY BY HAND',
    '// Generated by stack_assets',
    '',
    'import \'package:flutter/widgets.dart\';',
    'import \'package:vector_graphics/vector_graphics.dart\';',
    for (final imp in imports) 'import \'$imp\';',
    '',
    '// ignore_for_file: non_constant_identifier_names, unused_import, unused_element, unused_element_parameter, unnecessary_import',
    '',
    ...manifest.prelude,
  ]);

  final resultCode = <String>[];
  for (final block in blocks) {
    if (block.last == '') block.removeLast();
    resultCode.addAll(block);
    resultCode.add('');
  }

  return resultCode;
}

const _baseIconTemplate = '''
enum _BaseIconMode {
  vg,
  iconData,
}

class _BaseIcon extends StatelessWidget {
  const _BaseIcon.vgSelector({
    super.key,
    required BytesLoader Function(BuildContext) loader,
    BytesLoader Function(BuildContext)? filledLoader,
    this.size,
    this.color,
    this.autocolor = true,
  }) : mode = .vg,
       icon = null,
       loader = null,
       filledLoader = null,
       loaderFn = loader,
       filledLoaderFn = filledLoader,
       isSelectorBased = true;

  const _BaseIcon.vgBasic({
    super.key,
    required this.loader,
    this.filledLoader,
    this.size,
    this.color,
    this.autocolor = true,
  }) : mode = .vg,
       icon = null,
       loaderFn = null,
       filledLoaderFn = null,
       isSelectorBased = false;

  const _BaseIcon.iconData({
    super.key,
    required IconData this.icon,
    this.size,
    this.color,
  }) : mode = .iconData,
       loader = null,
       loaderFn = null,
       filledLoader = null,
       filledLoaderFn = null,
       isSelectorBased = false,
       autocolor = true;

  final _BaseIconMode mode;
  final IconData? icon;
  final BytesLoader Function(BuildContext)? loaderFn;
  final BytesLoader Function(BuildContext)? filledLoaderFn;
  final BytesLoader? loader;
  final BytesLoader? filledLoader;
  final bool isSelectorBased;
  final double? size;
  final Color? color;
  final bool autocolor;

  Widget _buildVgIcon(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    final color = this.color ?? iconTheme.color ?? Surface.maybeColorOf(context)?.foreground;
    final size = this.size ?? iconTheme.size ?? 24.0;
    final fill = iconTheme.fill ?? 0.0;

    Widget _buildIcon(BytesLoader loader, [double? opacity]) {
      return VectorGraphic(
        key: ValueKey((loader, opacity)),
        loader: loader,
        colorFilter: color != null && autocolor ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        width: size,
        height: size,
        opacity: opacity != null ? AlwaysStoppedAnimation(opacity) : null,
      );
    }

    final loader = isSelectorBased ? loaderFn!(context) : this.loader!;
    final filledLoader = isSelectorBased ? filledLoaderFn?.call(context) : this.filledLoader;

    if (filledLoader != null) {
      return Stack(
        children: [
          _buildIcon(loader, 1.0 - fill),
          _buildIcon(filledLoader, fill),
        ],
      );
    } else {
      return _buildIcon(loader);
    }
  }

  Widget _buildIconDataIcon(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return switch (mode) {
      .vg => _buildVgIcon(context),
      .iconData => _buildIconDataIcon(context),
    };
  }
}
''';
