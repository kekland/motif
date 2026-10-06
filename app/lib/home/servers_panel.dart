import 'package:app/imports.dart';
import 'package:app/main.dart';
import 'package:app/servers.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

class ServersPanel extends StatelessWidget {
  const new({
    super.key,
    required this.servers,
    this.selectedServer,
    this.onServerSelected,
    required this.onAddServer,
    required this.onConnect,
  });

  final List<Uri> servers;
  final Uri? selectedServer;
  final ValueChanged<Uri?>? onServerSelected;

  final void Function(String) onAddServer;
  final void Function(String) onConnect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserTile(),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: 1 + servers.length,
            itemBuilder: (context, i) {
              if (i == 0) {
                return ServerTile(
                  name: 'Local',
                  isSelected: selectedServer == null,
                  onTap: () => onServerSelected?.call(null),
                );
              }

              final uri = servers[i - 1];
              return ServerTile(
                name: uri.toString().split('://').last,
                uri: uri,
                isSelected: selectedServer == uri,
                onTap: () => onServerSelected?.call(uri),
              );
            },
          ),
        ),
        Divider(),
        AddServerTile(onAddServer: onAddServer),
        ConnectTile(onConnect: onConnect),
      ],
    );
  }
}

class UserTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = prefs.getString('userId')!;

    return Column(
      crossAxisAlignment: .start,
      children: [
        const SizedBox(height: 16.0),
        Padding(
          padding: const .symmetric(horizontal: 8.0),
          child: SizedBox(
            width: 64.0,
            height: 64.0,
            child: BoringAvatar(
              name: userId,
              palette: .new(Colors.primaries),
              shape: CircleBorder(),
              type: .marble,
            ),
          ),
        ),
        ListItem(
          onTap: () {},
          title: Text('Anonymous user'),
          subtitle: Text(userId),
        ),
      ],
    );
  }
}

class ServerTile extends HookWidget {
  const new({
    super.key,
    required this.name,
    this.onTap,
    this.isSelected = false,
    this.uri,
  });

  final String name;
  final Uri? uri;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final servers = useListenable(context.watch<AppServers>());
    final status = uri != null ? servers.statusFor(uri!) : null;

    return ListItem(
      onTap: onTap,
      leading: switch (uri) {
        null => Icons.folder(),
        _ => Icons.cloud(),
      },
      title: Text(name),
      isSelected: isSelected,
      dividerBelow: true,
      tooltip: uri == null ? .new('Your local documents') : null,
      trailing: status != null
          ? Tooltip(
              tooltip: .new(switch (status) {
                .unknown => 'Loading server status',
                .offline => 'Server unreachable',
                .online => 'Server online',
              }),
              child: Container(
                width: 6.0,
                height: 6.0,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: switch (status) {
                    .online => Colors.green,
                    .offline => Colors.red,
                    .unknown => Colors.grey,
                  },
                ),
              ),
            )
          : null,
    );
  }
}

class AddServerTile extends StatelessWidget {
  const new({super.key, required this.onAddServer});

  final void Function(String) onAddServer;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      onTap: () async {
        final result = await context.pushDialog<String>((_) => AddServerDialog());
        if (!context.mounted || result == null) return;
        onAddServer(result);
      },
      leading: Icons.add(),
      title: Text('Add server'),
      tooltip: .new('Add a hosted server'),
      dividerBelow: true,
    );
  }
}

class ConnectTile extends StatelessWidget {
  const new({super.key, required this.onConnect});

  final void Function(String) onConnect;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      onTap: () async {
        final result = await context.pushDialog<String>((_) => JoinDialog());
        if (!context.mounted || result == null) return;
        onConnect(result);
      },
      leading: Icons.link(),
      title: Text('Connect'),
      tooltip: .new('Join a shared room via URL'),
      dividerBelow: true,
    );
  }
}

class AddServerDialog extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return DialogScaffold(
      title: Text('Add server'),
      actions: [
        Button(
          onTap: () => Navigator.pop(context, controller.text),
          child: Text('Add'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          options: .new(hintText: 'Server URL'),
        ),
      ),
    );
  }
}

class JoinDialog extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return DialogScaffold(
      title: Text('Join'),
      actions: [
        Button(
          onTap: () => Navigator.pop(context, controller.text),
          child: Text('Join'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          options: .new(hintText: 'Room URL'),
        ),
      ),
    );
  }
}
