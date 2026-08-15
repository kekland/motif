import 'dart:io';

class CategoryResolver {
  CategoryResolver({required this.type, required this.name, required this.getter});

  final String type;
  final String name;
  final String getter;
}

class IconData {
  const IconData(this.name, this.iconData);

  final String name;
  final String iconData;
}

class AssetManifest {
  const AssetManifest({
    required this.rootDirectory,
    required this.assetsDirectory,
    required this.inputDirectoryName,
    required this.outputDirectoryName,
    this.icons = const [],
    this.prelude = const [],
    this.categoryResolvers = const {},
    this.package,
  });

  final Directory rootDirectory;
  final Directory assetsDirectory;
  final String inputDirectoryName;
  final String outputDirectoryName;
  final List<String> prelude;
  final Map<String, List<CategoryResolver>> categoryResolvers;
  final List<IconData> icons;
  final String? package;
}
