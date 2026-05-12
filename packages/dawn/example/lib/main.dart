import 'package:dawn/dawn.dart' as dawn;
import 'package:example/cases/render_to_bytes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dawn')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Render to bytes'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RenderToBytesCase())),
          ),
        ],
      ),
    );
  }
}
