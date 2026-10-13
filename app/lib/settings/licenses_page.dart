import 'package:app/imports.dart';

class LicensesPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      child: Flexible(
        child: LicensePage(
          applicationName: 'motif',
        ),
      ),
    );
  }
}
