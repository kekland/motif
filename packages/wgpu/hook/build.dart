// ignore_for_file: avoid_print
import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final root = input.packageRoot;
    final code = input.config.code;
    final os = code.targetOS;
    final arch = code.targetArchitecture;

    final platformDir = switch ((os, arch)) {
      (.macOS, _) => 'macos-${arch.name}',
      (.iOS, _) when (code.iOS.targetSdk == .iPhoneOS) => 'iphoneos-${arch.name}',
      (.iOS, _) when (code.iOS.targetSdk == .iPhoneSimulator) => 'iphonesimulator-${arch.name}',
      _ => throw Exception('Unsupported platform: $os-$arch'),
    };

    final libDir = root.resolve('build/$platformDir-release/');
    final headers = root.resolve('build/include/');

    if (!Directory.fromUri(libDir).existsSync()) {
      throw Exception('Library directory not found: $libDir. Is it built?');
    }

    final wgpuLib = 'wgpu_native';
    final wgpuLibFilePath = libDir.resolve('lib$wgpuLib.a');
    if (!File.fromUri(wgpuLibFilePath).existsSync()) throw Exception('libwgpu_native.a not found: $wgpuLibFilePath');

    final frameworks = <String>[];
    if (os == .macOS || os == .iOS) {
      frameworks.addAll([
        'Metal',
        'Foundation',
        'QuartzCore',
        'IOSurface',
        'CoreGraphics',
        'IOKit',
        'Security',
      ]);
    }

    final srcDir = root.resolve('src/');
    if (!Directory.fromUri(srcDir).existsSync()) throw Exception('Source directory not found: $srcDir');

    final sources = <Uri>[];
    final headersList = <Uri>[];

    for (final entry in Directory.fromUri(srcDir).listSync(recursive: true).whereType<File>()) {
      final path = entry.path;
      if (path.endsWith('.cpp') || path.endsWith('.cc') || path.endsWith('.c') || path.endsWith('.mm')) {
        sources.add(Uri.file(path));
      } else if (path.endsWith('.h') || path.endsWith('.hpp')) {
        headersList.add(Uri.file(path));
      }
    }

    if (sources.isEmpty) {
      print('No source files found in src/');
      return;
    }

    final builder = CBuilder.library(
      name: 'wgpu_native',
      assetName: 'src/asset.dart',
      language: .cpp,
      cppLinkStdLib: 'c++',
      sources: sources.map((u) => u.toFilePath()).toList(),
      includes: [srcDir.toFilePath()],
      frameworks: frameworks,
      optimizationLevel: .o0,
      flags: [
        '-std=c++17',
        '-fno-rtti',
        '-fvisibility=hidden',
        '-fvisibility-inlines-hidden',
        '-I',
        headers.toFilePath(),
        '-I',
        root.toFilePath(),
        for (final fw in frameworks) ...['-framework', fw],

        if (os == .macOS || os == .iOS) 
          '-Wl,-force_load,${wgpuLibFilePath.toFilePath()}'
        else
          wgpuLibFilePath.toFilePath(),
      ],
    );

    await builder.run(input: input, output: output);

    output.dependencies.add(wgpuLibFilePath);
    output.dependencies.add(headers);
  });
}
