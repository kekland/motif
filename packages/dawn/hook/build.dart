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

    final libDir = root.resolve('build/$platformDir/Release/');
    final headers = root.resolve('include/');

    if (!Directory.fromUri(libDir).existsSync()) {
      throw Exception('Library directory not found: $libDir. Is it built?');
    }

    final dawnLibs = <String>[
      'dawn_proc_static',
      'dawn_native_static',
      'dawn_platform_static',
    ];

    for (final lib in dawnLibs) {
      final p = libDir.resolve('lib$lib.a').toFilePath();
      if (!File(p).existsSync()) {
        throw Exception('Library not found: $p');
      }
    }

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
    if (!Directory.fromUri(srcDir).existsSync()) {
      throw Exception('Source directory not found: $srcDir');
    }

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
      print('No source files found in src/.');
      return;
    }

    final exports = root.resolve('hook/dawn_exports.txt');

    final builder = CBuilder.library(
      name: 'dawn',
      assetName: 'src/asset.dart',
      language: .cpp,
      cppLinkStdLib: 'c++',
      sources: sources.map((u) => u.toFilePath()).toList(),
      includes: [srcDir.toFilePath()],
      frameworks: frameworks,
      libraries: dawnLibs,
      libraryDirectories: [libDir.toFilePath()],
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
        if (os == .macOS || os == .iOS) ...[
          '-Wl,-force_load,${libDir.resolve('libdawn_proc_static.a').toFilePath()}',
          // '-Wl,-exported_symbols_list,${exports.toFilePath()}',
          // '-Wl,-dead_strip',
        ],
        if (os == .linux) '-Wl,--gc-sections',
      ],
    );

    await builder.run(input: input, output: output);

    for (final lib in dawnLibs) output.dependencies.add(libDir.resolve('lib$lib.a'));
    output.dependencies.add(headers);
    output.dependencies.add(exports);
  });
}
