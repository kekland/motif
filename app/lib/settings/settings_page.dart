import 'package:app/imports.dart';
import 'package:app/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

final swatches = <Color>[...Colors.primaries];

class SettingsDialog extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final packageInfo = useState<(String, String)?>(null);
    final stamp = useState(0);
    void loadPackageInfo() async {
      final info = await PackageInfo.fromPlatform();
      packageInfo.value = (info.version, info.buildNumber);
    }

    useEffect(() {
      loadPackageInfo();
      return null;
    });

    final brightness = switch (prefs.getString('themeMode')) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    late final Color selectedAccentColor;
    final accentColorValue = prefs.getInt('accentColor');
    if (accentColorValue != null) {
      selectedAccentColor = Color(accentColorValue);
    } else {
      selectedAccentColor = Colors.indigo;
    }

    late final double selectedContrastLevel;
    final contrastLevelValue = prefs.getDouble('contrastLevel');
    if (contrastLevelValue != null) {
      selectedContrastLevel = contrastLevelValue;
    } else {
      selectedContrastLevel = 0.5;
    }

    void updatePrefs(VoidCallback cb) {
      cb();
      stamp.value++;
      App.of(context).onPrefsChanged();
      PortalEntry.maybeOf(context)?.hideScrim();
    }

    return DialogScaffold(
      title: Text('Settings'),
      child: ListView(
        shrinkWrap: true,
        children: [
          Header(
            title: Text('Theme'),
          ),
          Divider(),
          ListItem(
            title: Text('Brightness'),
            trailing: ToggleableButtonRow(
              isExpanded: false,
              children: [
                ToggleableButton(
                  isActive: brightness == .light,
                  onChanged: (_) => updatePrefs(() => prefs.setString('themeMode', 'light')),
                  child: Icons.brightnessLight(),
                ),
                ToggleableButton(
                  isActive: brightness == .dark,
                  onChanged: (_) => updatePrefs(() => prefs.setString('themeMode', 'dark')),
                  child: Icons.brightnessDark(),
                ),
                ToggleableButton(
                  isActive: brightness == .system,
                  onChanged: (_) => updatePrefs(() => prefs.setString('themeMode', 'system')),
                  child: Icons.brightnessSystem(),
                ),
              ],
            ),
          ),
          Divider(),
          ListItem(title: Text('Accent color')),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 32.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: swatches.length,
            padding: .only(left: 8.0, right: 8.0, bottom: 8.0),
            itemBuilder: (context, i) {
              final swatch = swatches[i];
              final isSelected = swatch.toARGB32() == selectedAccentColor.toARGB32();
              final fgColor = swatch.computeLuminance() > 0.5 ? Colors.black : Colors.white;

              return GestureSurface(
                onTap: () => updatePrefs(() => prefs.setInt('accentColor', swatch.toARGB32())),
                color: swatch,
                width: 32.0,
                height: 32.0,
                borderRadius: .circular(8.0),
                borderSide: BorderSide(
                  color: swatch == selectedAccentColor ? context.colors.divider : Colors.transparent,
                  width: 2.0,
                ),
                child: Center(
                  child: isSelected ? Icons.check(color: fgColor) : null,
                ),
              );
            },
          ),
          Divider(),
          ListItem(title: Text('Contrast level')),
          Padding(
            padding: .only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Slider(
              value: selectedContrastLevel * 0.5 + 0.5,
              onChanged: (v) => updatePrefs(() => prefs.setDouble('contrastLevel', (v - 0.5) * 2)),
              stopsGenerator: (v) => Color.lerp(Colors.black, Colors.white, v)!,
            ),
          ),
          Divider(),
          Header(
            title: Text('Information'),
          ),
          Divider(),
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
