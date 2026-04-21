part of '_nodes.dart';

class TextNodeWidget extends StatelessWidget {
  const TextNodeWidget({super.key, required this.node});

  final TextNode node;

  @override
  Widget build(BuildContext context) {
    debugPrintGestureArenaDiagnostics = true;
    return NodeBuilder(
      node: node,
      builder: (context, child) {
        final spans = useComputedValue(() => node.spans);
        final editingController = useManagedResource(
          create: () => _TextNodeEditingController(spans: spans),
          dispose: (v) => v.dispose(),
        );
        final focusNode = useFocusNode();
        useEffect(() {
          focusNode.addListener(() {
            print('Focus changed: ${focusNode.hasFocus}');
          });

          return () => focusNode.dispose();
        }, [focusNode]);


        return IntrinsicWidth(
          child: GestureDetector(
            onDoubleTap: () {
              print('Double tapped on TextNodeWidget');
              focusNode.requestFocus();
            },
            child: EditableText(
              controller: editingController,
              focusNode: focusNode,
              textWidthBasis: .longestLine,
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
              cursorColor: Colors.blue,
              backgroundCursorColor: Colors.transparent,
              cursorWidth: 1.0,
              
            ),
          ),
        );
      },
    );
  }
}

TextSpan _textSpanFromData(TextSpanData data) {
  return TextSpan(
    text: data.text,
    style: _textStyleFromData(data.style),
  );
}

TextStyle _textStyleFromData(TextStyleData data) {
  return TextStyle(
    fontSize: data.fontSize,
    fontFamily: data.fontFamily,
    color: data.color.toUiColor(),
  );
}

class _TextNodeEditingController extends TextEditingController {
  _TextNodeEditingController({
    required this.spans,
  }) : super(text: spans.map((e) => e.text).join());

  List<TextSpanData> spans;
  void setSpans(List<TextSpanData> newSpans) {
    spans = newSpans;
    text = spans.map((e) => e.text).join();
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    return TextSpan(
      children: spans.map(_textSpanFromData).toList(),
      style: style,
    );
  }
}
