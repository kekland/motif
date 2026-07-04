import 'package:ui/ui.dart';
import 'package:vc/renderer.dart';
import 'package:vc/vc.dart';

class SymbolSelectWindow extends StatelessWidget {
  const SymbolSelectWindow({
    super.key,
    required this.vectorComplexContext,
  });

  final VectorComplexContext vectorComplexContext;

  static WindowEntry createEntry(BuildContext context, {required VectorComplexContext vectorComplexContext}) =>
      .withContextAnchor(
        context,
        builder: (_) => SymbolSelectWindow(vectorComplexContext: vectorComplexContext),
      );

  @override
  Widget build(BuildContext context) {
    final manager = vectorComplexContext.symbol;

    return WindowScaffold(
      leading: Icons.symbols(),
      title: Text('Select symbol'),
      child: SizedBox(
        width: 240.0,
        height: 400.0,
        child: ListView.builder(
          itemCount: manager.symbols.length,
          itemBuilder: (context, i) {
            final symbol = manager.symbols[i];

            return Tile(
              onTap: () => Navigator.pop(context, symbol),
              leading: Surface(
                width: 64.0,
                height: 64.0,
                borderRadius: .circular(8.0),
                color: context.colors.surface.secondary,
                padding: const EdgeInsets.all(12.0),
                child: FittedBox(
                  alignment: .center,
                  fit: .contain,
                  child: VectorComplexWidget(
                    complex: .new(
                      context: vectorComplexContext,
                      cells: symbol.bundle.cells,
                    ),
                    resizeToFit: true,
                    debug: true,
                  ),
                ),
              ),
              title: Text('Symbol ${symbol.id}'),
            );
          },
        ),
      ),
    );
  }
}
