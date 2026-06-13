import 'dart:io';

final _includeRegex = RegExp(r'#import\s+"([^"]+)"');
final _defineImportPathRegex = RegExp(r'#define_import_path\s+(\w+)');

/// Preprocesses #import "relative_path" directives in WGSL.
String preprocessWgsl(File file, String content, {Set<Uri>? includedFiles}) {
  final _includedFiles = includedFiles ?? {};

  final baseDirUri = file.parent.uri;

  final lines = content.split('\n');
  final processedLines = <String>[];

  for (final line in lines) {
    final includeMatch = _includeRegex.firstMatch(line);
    final defineImportPathMatch = _defineImportPathRegex.firstMatch(line);

    if (includeMatch != null) {
      final includePath = includeMatch.group(1)!;
      final includeUri = baseDirUri.resolve(includePath);
      if (_includedFiles.contains(includeUri)) continue;
      _includedFiles.add(includeUri);

      final includeFile = File.fromUri(includeUri);
      if (!includeFile.existsSync()) throw Exception('Included file "${includeFile.path}" does not exist.');

      final includeContent = includeFile.readAsStringSync();
      var processedInclude = preprocessWgsl(
        includeFile,
        includeContent,
        includedFiles: _includedFiles,
      ).split('\n');

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
