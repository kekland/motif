import 'dart:async';

import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:renderer2/renderer.dart';
import 'package:renderer2/src/buffers/decoration.dart';
import 'package:renderer2/src/storage.dart';
import 'package:scene/scene.dart';
import 'package:shared/shared.dart';

final class DecorationCache with ChangeNotifier {
  DecorationCache(
    this.storage,
    this.shaderValidator,
    this.onShaderCodeUpdated,
  );

  final RendererStorage storage;
  final ShaderValidator shaderValidator;
  final void Function() onShaderCodeUpdated;

  DecorationStorage get decorationStorage => storage.decorations.storage;

  DataSpan spanFor(CellRef ref, Decorations decorations, {DataSpan? previousSpan}) {
    final ready = <Decoration>[];

    for (final entry in decorations.entries) {
      if (entry.kind == .color) {
        ready.add(entry);
      } else if (entry.kind == .shader) {
        final decoration = _getShaderDecoration(ref, entry as ShaderDecoration);
        if (decoration != null) {
          ready.add(decoration);
        }
      }
    }

    return decorationStorage.put(ready, span: previousSpan);
  }

  final shaderCode = <String, String>{};
  final _shaderCache = <String, int?>{};
  final _shaderPreparation = <String, bool>{};

  ShaderDecoration? _getShaderDecoration(CellRef ref, ShaderDecoration decoration) {
    final id = decoration.id;

    if (_shaderCache[id] == -1) return null;
    if (_shaderCache[id] == decoration.shader.hashCode) {
      return decoration;
    } else {
      _shaderCache[id] = null;
      _prepareShaderDecoration(ref, decoration);
      return null;
    }
  }

  Future<void> _prepareShaderDecoration(CellRef ref, ShaderDecoration decoration) async {
    final id = decoration.id;
    if (_shaderPreparation[id] == true) return;
    _shaderPreparation[id] = true;

    final hash = Mix64.hashInt(id.hashCode);
    final shaderName = 'fragment_$hash';
    final shaderCode = decoration.shader.toWgsl(shaderName).join('\n');

    final validationShaderCode = [
      'struct VtxOut {',
      '  @location(0) world_position: vec2f,',
      '  @location(1) local_position: vec2f,',
      '};',
      shaderCode,
    ];

    final validation = await shaderValidator.validateShader(validationShaderCode.join('\n'));
    if (validation.isEmpty) {
      _shaderCache[id] = decoration.shader.hashCode;
      this.shaderCode[id] = shaderCode;
      storage.shaderUpdated.add(ref);

      onShaderCodeUpdated();
      notifyListeners();
    } else {
      print(validation);
      _shaderCache[id] = -1;
    }

    _shaderPreparation[id] = false;
  }
}
