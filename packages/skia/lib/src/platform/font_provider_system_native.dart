import 'dart:io';

import 'package:skia/skia.dart';

Future<int> addSystemFontsImpl(FontProvider provider) async {
  final home = Platform.environment['HOME'];
  final dirs = switch (Platform.operatingSystem) {
    'macos' => ['/System/Library/Fonts', 'Library/Fonts', '$home/Library/Fonts'],
    'linux' => ['/usr/share/fonts', '/usr/local/share/fonts', '$home/.local/share/fonts'],
    'windows' => ['C:\\Windows\\Fonts'],
    _ => <String>[],
  };

  var added = 0;
  for (final dir in dirs.map(Directory.new).where((d) => d.existsSync())) {
    for (final file in dir.listSync(recursive: true, followLinks: false).whereType<File>()) {
      final path = file.path.toLowerCase();
      final isCollection = path.endsWith('.ttc') || path.endsWith('.otc');
      final isFont = path.endsWith('.ttf') || path.endsWith('.otf');
      if (!isCollection && !isFont) continue;

      final bytes = await file.readAsBytes();
      if (isCollection) {
        var i = 0;
        while (provider.add(bytes, index: i)) i++;
        added += i;
      } else if (provider.add(bytes)) {
        added++;
      }
    }
  }

  return added;
}
