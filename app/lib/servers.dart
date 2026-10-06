import 'package:app/imports.dart';
import 'package:app/main.dart';
import 'package:sync/schema.dart' as pb;
import 'package:sync/sync.dart' as sync;
import 'package:sync_server/embedded.dart';
import 'package:sync_server/network.dart';

final class AppServers with ChangeNotifier, ChangeNotifierDisposable {
  new(this.embeddedServer) {
    ownUser = pb.Client(id: prefs.getString('userId')!);
    _servers.value = (prefs.getStringList('servers') ?? []).map(Uri.parse).toList();
    _embeddedClient = EmbeddedClient(embeddedServer);

    for (final s in _servers.value) _createClient(s);
  }

  final EmbeddedServer embeddedServer;

  late final pb.Client ownUser;

  late final _servers = $listSignal<Uri>([]);
  List<Uri> get servers => _servers.value;

  final _clients = <Uri, NetworkClient>{};
  final _status = <Uri, ServerStatus>{};

  late final EmbeddedClient _embeddedClient;

  bool contains(Uri? uri) => uri == null || _servers.value.contains(uri);

  sync.Client clientFor(Uri? uri) {
    if (uri == null) return _embeddedClient;
    return _clients[uri]!;
  }

  ServerStatus statusFor(Uri uri) => _status[uri] ?? .unknown;

  void _createClient(Uri uri) async {
    _clients[uri] = NetworkClient(uri);
    refreshServerStatus(uri);
  }

  Future<void> refreshServerStatus(Uri uri) async {
    _status[uri] = .unknown;
    try {
      final client = _clients[uri]!;
      await client.listScenes();
      _status[uri] = .online;
    } catch (e, st) {
      logger.warning('failed to connect to server', e, st);
      _status[uri] = .offline;
    } finally {
      notifyListeners();
    }
  }

  void addServer(Uri uri) {
    _servers.value = [..._servers.value, uri];
    prefs.setStringList('servers', _servers.value.map((e) => e.toString()).toList());
    _createClient(uri);
    notifyListeners();
  }

  void removeServer(Uri uri) {
    _servers.value = _servers.value.where((e) => e != uri).toList();
    prefs.setStringList('servers', _servers.value.map((e) => e.toString()).toList());
    _clients.remove(uri)?.close();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final client in _clients.values) {
      client.close();
    }

    _embeddedClient.close();
    super.dispose();
  }
}

enum ServerStatus {
  online,
  offline,
  unknown,
}
