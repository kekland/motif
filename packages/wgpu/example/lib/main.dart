import 'package:example/cases/render_to_bytes.dart';
import 'package:example/cases/render_to_mtl_texture.dart';
import 'package:flutter/material.dart';
import 'package:wgpu/wgpu_native.dart' as wgpu;

void main() {
  wgpu.WGPUNative.init();
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
      appBar: AppBar(title: Text('wgpu')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Render to bytes'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RenderToBytesCase())),
          ),
          ListTile(
            title: Text('Render to MTLTexture'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RenderToMtlTextureCase())),
          ),
        ],
      ),
    );
  }
}
