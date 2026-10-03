import 'package:app/imports.dart';
import 'package:sync/client.dart' as sync;

// Future<Uint8List> _assetResolver(Program program, AssetId id) async {
//   if (id is FontFileId) {
//     final hash = id.hash;
//     final font = await rootBundle.load('packages/editor/assets/builtin/fonts/$hash');
//     final data = font.buffer.asUint8List();

//     // TODO: all of this is unnecessary once the text editor uses the skia output.
//     final familyData = EditorBuiltinFonts.instance.catalog.assets.values.firstWhere(
//       (a) => a.files.any((f) => f.id.hash == id.hash),
//     );
//     final loader = FontLoader(familyData.family);
//     loader.addFont(Future.value(data.buffer.asByteData()));
//     await loader.load();

//     return data;
//   }

//   throw UnimplementedError('Asset resolver not implemented for $id');
// }

class EditorPage extends HookWidget {
  const new({super.key, required this.client, required this.id});

  final sync.Client client;
  final String id;

  @override
  Widget build(BuildContext context) {
    final editorSync = useDisposable(() => EditorSync(client: client, sceneId: id, clientId: null));
    return EditorWidget(sync: editorSync);
  }
}
