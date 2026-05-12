import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as ffi;

import 'gen/webgpu_native_bindings.dart' as bindings;
export 'asset.dart';

part 'gen/webgpu_callbacks.dart';
part 'gen/webgpu_enums.dart';
part 'gen/webgpu_flags.dart';
part 'gen/webgpu_methods.dart';
part 'gen/webgpu_structs.dart';
part 'gen/webgpu_types.dart';

part 'impl/_stub.dart';
part 'impl/adapter.dart';
part 'impl/bind_group.dart';
part 'impl/bind_group_layout.dart';
part 'impl/buffer.dart';
part 'impl/command_buffer.dart';
part 'impl/command_encoder.dart';
part 'impl/compute_pass_encoder.dart';
part 'impl/compute_pipeline.dart';
part 'impl/device.dart';
part 'impl/external_texture.dart';
part 'impl/instance.dart';
part 'impl/pipeline_layout.dart';
part 'impl/query_set.dart';
part 'impl/queue.dart';
part 'impl/render_bundle.dart';
part 'impl/render_bundle_encoder.dart';
part 'impl/render_pass_encoder.dart';
part 'impl/render_pipeline.dart';
part 'impl/resource_table.dart';
part 'impl/sampler.dart';
part 'impl/shader_module.dart';
part 'impl/shared_buffer_memory.dart';
part 'impl/shared_fence.dart';
part 'impl/shared_texture_memory.dart';
part 'impl/surface.dart';
part 'impl/texel_buffer_view.dart';
part 'impl/texture.dart';
part 'impl/texture_view.dart';

part 'utils/chained_struct.dart';
part 'utils/extensions.dart';
part 'utils/utils.dart';
