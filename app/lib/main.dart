import 'package:app/imports.dart';
import 'package:bindings/bindings.dart';
import 'package:flutter/services.dart';
import 'package:skia/skia.dart' as skia;

Future<void> main() async {
  AugmentedWidgetsFlutterBinding.ensureInitialized();

  await skia.Skia.initialize();
  // await skiaTest();

  await SceneStorage.initialize();
  runApp(App());
}

// Future<void> skiaTest() async {
//   final fontProvider = skia.FontProvider();

//   final font = await rootBundle.load('packages/ui/assets/fonts/RobotoMono/RobotoMono-VariableFont_wght.ttf');
//   fontProvider.add(font.buffer.asUint8List());

//   final textStyle = skia.TextStyle(fontFamilies: fontProvider.families);
//   final paragraphStyle = skia.ParagraphStyle();
//   final paragraphBuilder = skia.ParagraphBuilder(paragraphStyle, fontProvider);
//   paragraphBuilder.pushStyle(textStyle);
//   paragraphBuilder.addText('Hello from Skia!');
//   paragraphBuilder.popStyle();

//   final paragraph = paragraphBuilder.build();
//   paragraph.layout(100.0);

//   print('Paragraph longest line: ${paragraph.longestLine}');
//   print('Paragraph height: ${paragraph.height}');

//   for (final metrics in paragraph.lineMetrics) {
//     print('Line metrics: left=${metrics.left}, baseline=${metrics.baseline}, ascent=${metrics.ascent}, descent=${metrics.descent}, width=${metrics.width}, height=${metrics.height}, glyphStart=${metrics.glyphStart}, glyphEnd=${metrics.glyphEnd}');
//   }
  
//   for (final metrics in paragraph.glyphMetrics) {
//     print('Glyph metrics: x=${metrics.x}, y=${metrics.y}, left=${metrics.left}, top=${metrics.top}, right=${metrics.right}, bottom=${metrics.bottom}, id=${metrics.id}, font=${metrics.font}');
//   }
// }
