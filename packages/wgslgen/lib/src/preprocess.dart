import 'dart:io';

final _includeRegex = RegExp(r'#import\s+"([^"]+)"');
final _defineImportPathRegex = RegExp(r'#define_import_path\s+(\w+)');

/// Preprocesses #import "relative_path" directives in WGSL.
///
/// Note: this doesn't handle circular imports or anything fancy, just processes imports.
String preprocessWgsl(File file, String content) {
  final baseDirUri = file.parent.uri;

  final lines = content.split('\n');
  final processedLines = <String>[];

  for (final line in lines) {
    final includeMatch = _includeRegex.firstMatch(line);
    final defineImportPathMatch = _defineImportPathRegex.firstMatch(line);

    if (includeMatch != null) {
      final includePath = includeMatch.group(1)!;
      final includeFile = File.fromUri(baseDirUri.resolve(includePath));
      if (!includeFile.existsSync()) throw Exception('Included file "${includeFile.path}" does not exist.');

      final includeContent = includeFile.readAsStringSync();
      var processedInclude = preprocessWgsl(includeFile, includeContent).split('\n');

      while (processedInclude.isNotEmpty && processedInclude.first.trim().isEmpty) processedInclude.removeAt(0);
      while (processedInclude.isNotEmpty && processedInclude.last.trim().isEmpty) processedInclude.removeLast();

      processedLines.add('// import "$includePath"');
      processedLines.addAll(processedInclude);
      processedLines.add('// end import "$includePath"');
      processedLines.add('');
    } else if (defineImportPathMatch != null) {
      // Ignore the line
    } else {
      processedLines.add(line);
    }
  }

  return processedLines.join('\n');
}
