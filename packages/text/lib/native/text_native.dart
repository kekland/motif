import 'package:skia_dart/skia_dart.dart' as skia;

void test_text() {
  final fontManager = skia.SkFontMgr.createPlatformDefault()!;
  final fontCollection = skia.SkFontCollection();
  fontCollection.setDefaultFontManagerWithFamily(fontManager, 'Arial');

  final textStyle = skia.SkTextStyle()
    ..color = skia.SkColor(0xFF000000)
    ..fontSize = 24.0
    ..fontFamilies = ['Arial', 'Roboto', 'sans-serif'];

  final paragraphStyle = skia.SkParagraphStyle()
    ..textStyle = textStyle
    ..maxLines = 2
    ..ellipsis = '...';

  final builder = skia.SkParagraphBuilder(
    style: paragraphStyle,
    fontCollection: fontCollection,
    unicode: skia.SkUnicode.icu()!,
  );

  builder.pushStyle(textStyle);
  builder.addText('Hello, world!');
  builder.pop();

  final paragraph = builder.build();
  paragraph.layout(200);

  // Print the resulting metrics!
  print('Paragraph height: ${paragraph.height}');
  print('Max intrinsic width: ${paragraph.maxIntrinsicWidth}');
  print('Longest line: ${paragraph.longestLine}');

  final lineMetrics = paragraph.lineMetrics;
  for (var i = 0; i < lineMetrics.length; i++) {
    final line = lineMetrics[i];
    print('Line $i: start=${line.left}, width=${line.width}');

    final path = skia.SkPath();
    paragraph.getPath(i, path);

    print('Line $i path: ${path.getPoint(5).x}');
  }
}
