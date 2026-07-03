import 'package:vector/imports.dart';

class SymbolsWindow extends StatelessWidget {
  const SymbolsWindow({super.key, required this.controller});

  final VectorController controller;

  static WindowEntry createEntry(BuildContext context, {required VectorController controller}) => .withContextAnchor(
    context,
    builder: (_) => SymbolsWindow(controller: controller),
  );

  @override
  Widget build(BuildContext context) {
    // final symbolManager = controller.symbolManager;

    return WindowScaffold(
      leading: Icons.symbols(),
      title: Text('Symbols'),
      child: SizedBox(
        width: 240.0,
        height: 400.0,
        // child: ListView.builder(
        //   itemCount: symbolManager.symbolCount,
        //   itemBuilder: (context, i) {
        //     final symbol = symbolManager.getSymbolAt(i)!;
        //     return Tile(
        //       leading: Surface(
        //         width: 64.0,
        //         height: 64.0,
        //         borderRadius: .circular(8.0),
        //         color: context.colors.surface.secondary,
        //         padding: const EdgeInsets.all(12.0),
        //         child: FittedBox(
        //           alignment: .center,
        //           fit: .contain,
        //           child: VectorComplexWidget(
        //             complex: symbol.complex,
        //             resizeToFit: true,
        //             debug: true,
        //           ),
        //         ),
        //       ),
        //       title: Text('Symbol ${symbol.id}'),
        //     );
        //   },
        // ),
      ),
    );
  }
}
