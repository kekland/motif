import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:webgpu/webgpu.dart';
import 'package:webgpu/native.dart'
    if (dart.library.js_interop) 'package:webgpu/web.dart'
    show createDefaultInstance, initializeWebGpu;

import 'shared.g.dart';
export 'shared.g.dart';

part 'adapter.dart';
part 'bind_group_layout.dart';
part 'bind_group.dart';
part 'buffer.dart';
part 'command_buffer.dart';
part 'command_encoder.dart';
part 'compute_pass_encoder.dart';
part 'compute_pipeline.dart';
part 'device.dart';
part 'external_texture.dart';
part 'instance.dart';
part 'pipeline_layout.dart';
part 'query_set.dart';
part 'queue.dart';
part 'render_bundle_encoder.dart';
part 'render_bundle.dart';
part 'render_pass_encoder.dart';
part 'render_pipeline.dart';
part 'sampler.dart';
part 'shader_module.dart';
part 'surface.dart';
part 'texture_view.dart';
part 'texture.dart';
