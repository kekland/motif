import 'package:app/imports.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsDialog extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final packageInfo = useState<(String, String)?>(null);
    void loadPackageInfo() async {
      final info = await PackageInfo.fromPlatform();
      packageInfo.value = (info.version, info.buildNumber);
    }

    useEffect(() {
      loadPackageInfo();
      return null;
    });

    return DialogScaffold(
      title: Text('Settings'),
      child: ListView(
        shrinkWrap: true,
        children: [
          ListItem(
            title: Text('Version'),
            subtitle: Text(packageInfo.value?.$1 ?? 'Loading'),
          ),
          Divider(),
          ListItem(
            title: Text('Build number'),
            subtitle: Text(packageInfo.value?.$2 ?? 'Loading'),
          ),
          Divider(),
          ListItem(
            title: Text('Source repository'),
            subtitle: Text('https://github.com/kekland/motif'),
            trailing: Icons.link(),
            onTap: () => launchUrl(Uri.parse('https://github.com/kekland/motif')),
          ),
          Divider(),
          ListItem(
            title: Text('Support'),
            subtitle: Text('https://ko-fi.com/kekland'),
            trailing: Icons.link(),
            onTap: () => launchUrl(Uri.parse('https://ko-fi.com/kekland')),
          ),
        ],
      ),
    );
  }
}
