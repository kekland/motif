part of 'widgets.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({super.key, required this.cell});

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return SceneObjectBuilder(
      object: cell,
      builder: null,
    );
  }
}
