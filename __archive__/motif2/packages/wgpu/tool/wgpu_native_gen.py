#!/usr/bin/env python3

from _common import ROOT
from webgpu_gen import WGPUEnum, WGPUEnumEntry, WGPUFlag, WGPUFlagEntry, WGPUStructMember, WGPUStruct, WGPUStructType, WGPUType, WGPUTypeKind, WGPUPointerKind, WGPUFunction, WGPUFunctionArg, WGPUFunctionReturn, WGPUCallback, WGPUCallbackStyle, parse, generate

OUT_PATH = ROOT / 'lib' / 'src' / 'wgpu_native' / 'wgpu_native.g.dart'

ENUMS = {
  's_type': WGPUEnum(
    name='native_s_type',
    entries=[
      WGPUEnumEntry('device_extras', 0x00030001),
      WGPUEnumEntry('native_limits', 0x00030002),
      WGPUEnumEntry('pipeline_layout_extras', 0x00030003),
      WGPUEnumEntry('shader_source_GLSL', 0x00030004),
      WGPUEnumEntry('instance_extras', 0x00030006),
      WGPUEnumEntry('bind_group_entry_extras', 0x00030007),
      WGPUEnumEntry('bind_group_layout_entry_extras', 0x00030008),
      WGPUEnumEntry('query_set_descriptor_extras', 0x00030009),
      WGPUEnumEntry('surface_configuration_extras', 0x0003000A),
      WGPUEnumEntry('surface_source_swap_chain_panel', 0x0003000B),
      WGPUEnumEntry('primitive_state_extras', 0x0003000C),
    ]
  ),
  # 'surface_get_current_texture_status': WGPUEnum(
  #   name='surface_get_current_texture_status',
  #   entries = [
  #     WGPUEnumEntry('occluded', 0x00030001),
  #   ],
  # ),
  'native_feature': WGPUEnum(
    name='native_feature',
    extends='feature_name',
    entries=[
      WGPUEnumEntry('immediates', 0x00030001),
      WGPUEnumEntry('texture_adapter_specific_format_features', 0x00030002),
      WGPUEnumEntry('multi_draw_indirect_count', 0x00030004),
      WGPUEnumEntry('vertex_writable_storage', 0x00030005),
      WGPUEnumEntry('texture_binding_array', 0x00030006),
      WGPUEnumEntry('sampled_texture_and_storage_buffer_array_non_uniform_indexing', 0x00030007),
      WGPUEnumEntry('pipeline_statistics_query', 0x00030008),
      WGPUEnumEntry('storage_resource_binding_array', 0x00030009),
      WGPUEnumEntry('partially_bound_binding_array', 0x0003000A),
      WGPUEnumEntry('texture_format_16bit_norm', 0x0003000B),
      WGPUEnumEntry('texture_compression_astc_hdr', 0x0003000C),
      WGPUEnumEntry('mappable_primary_buffers', 0x0003000E),
      WGPUEnumEntry('buffer_binding_array', 0x0003000F),
      WGPUEnumEntry('uniform_buffer_and_storage_texture_array_non_uniform_indexing', 0x00030010),
      WGPUEnumEntry('polygon_mode_line', 0x00030013),
      WGPUEnumEntry('polygon_mode_point', 0x00030014),
      WGPUEnumEntry('conservative_rasterization', 0x00030015),
      WGPUEnumEntry('spirv_shader_passthrough', 0x00030016),
      WGPUEnumEntry('vertex_attribute_64bit', 0x00030019),
      WGPUEnumEntry('texture_format_nv12', 0x0003001A),
      WGPUEnumEntry('ray_query', 0x0003001C),
      WGPUEnumEntry('shader_f64', 0x0003001D),
      WGPUEnumEntry('shader_i16', 0x0003001E),
      WGPUEnumEntry('shader_early_depth_test', 0x00030020),
      WGPUEnumEntry('subgroup', 0x00030021),
      WGPUEnumEntry('subgroup_vertex', 0x00030022),
      WGPUEnumEntry('subgroup_barrier', 0x00030023),
      WGPUEnumEntry('timestamp_query_inside_encoders', 0x00030024),
      WGPUEnumEntry('timestamp_query_inside_passes', 0x00030025),
      WGPUEnumEntry('shader_int64', 0x00030026),
    ]
  ),
  'log_level': WGPUEnum(
    name='log_level',
    entries=[
      WGPUEnumEntry('off', 0x00000000),
      WGPUEnumEntry('error', 0x00000001),
      WGPUEnumEntry('warn', 0x00000002),
      WGPUEnumEntry('info', 0x00000003),
      WGPUEnumEntry('debug', 0x00000004),
      WGPUEnumEntry('trace', 0x00000005),
    ]
  ),
  'dx12_compiler': WGPUEnum(
    name='dx12_compiler',
    entries=[
      WGPUEnumEntry('undefined', 0x00000000),
      WGPUEnumEntry('fxc', 0x00000001),
      WGPUEnumEntry('dxc', 0x00000002),
    ],
  ),
  'gles3_minor_version': WGPUEnum(
    name='gles3_minor_version',
    entries=[
      WGPUEnumEntry('automatic', 0x00000000),
      WGPUEnumEntry('version0', 0x00000001),
      WGPUEnumEntry('version1', 0x00000002),
      WGPUEnumEntry('version2', 0x00000003),
    ],
  ),
  'pipeline_statistic_name': WGPUEnum(
    name='pipeline_statistic_name',
    entries=[
      WGPUEnumEntry('vertex_shader_invocations', 0x00000000),
      WGPUEnumEntry('clipper_invocations', 0x00000001),
      WGPUEnumEntry('clipper_primitives_out', 0x00000002),
      WGPUEnumEntry('fragment_shader_invocations', 0x00000003),
      WGPUEnumEntry('compute_shader_invocations', 0x00000004),
    ],
  ),
  'native_query_type': WGPUEnum(
    name='native_query_type',
    extends='query_type',
    entries=[
      WGPUEnumEntry('pipeline_statistics', 0x00003000),
    ]
  ),
  'dxc_max_shader_model': WGPUEnum(
    name='dxc_max_shader_model',
    entries=[
      WGPUEnumEntry('v6__0', 0x00000000),
      WGPUEnumEntry('v6__1', 0x00000001),
      WGPUEnumEntry('v6__2', 0x00000002),
      WGPUEnumEntry('v6__3', 0x00000003),
      WGPUEnumEntry('v6__4', 0x00000004),
      WGPUEnumEntry('v6__5', 0x00000005),
      WGPUEnumEntry('v6__6', 0x00000006),
      WGPUEnumEntry('v6__7', 0x00000007),
    ],
  ),
  'GL_fence_behaviour': WGPUEnum(
    name='GL_fence_behaviour',
    entries=[
      WGPUEnumEntry('normal', 0x00000000),
      WGPUEnumEntry('auto_finish', 0x00000001),
    ],
  ),
  'dx12_swapchain_kind': WGPUEnum(
    name='dx12_swapchain_kind',
    entries=[
      WGPUEnumEntry('undefined', 0x00000000),
      WGPUEnumEntry('dxgi_from_hwnd', 0x00000001),
      WGPUEnumEntry('dxgi_from_visual', 0x00000002),
    ],
  ),
  'native_display_handle_type': WGPUEnum(
    name='native_display_handle_type',
    entries=[
      WGPUEnumEntry('none', 0x00000000),
      WGPUEnumEntry('xlib', 0x00000001),
      WGPUEnumEntry('xcb', 0x00000002),
      WGPUEnumEntry('wayland', 0x00000003),
    ],
  ),
  'polygon_mode': WGPUEnum(
    name='polygon_mode',
    entries=[
      WGPUEnumEntry('fill', 0),
      WGPUEnumEntry('line', 1),
      WGPUEnumEntry('point', 2),
    ],
  ),
  'native_texture_format': WGPUEnum(
    name='native_texture_format',
    extends='texture_format',
    entries=[
      WGPUEnumEntry('r16_unorm', 0x00030001),
      WGPUEnumEntry('r16_snorm', 0x00030002),
      WGPUEnumEntry('rg16_unorm', 0x00030003),
      WGPUEnumEntry('rg16_snorm', 0x00030004),
      WGPUEnumEntry('rgba16_unorm', 0x00030005),
      WGPUEnumEntry('rgba16_snorm', 0x00030006),
      WGPUEnumEntry('NV12', 0x00030007),
      WGPUEnumEntry('p010', 0x00030008),
    ],
  ),
}

FLAGS: dict[str, WGPUFlag] = {
  'instance_backend': WGPUFlag(
    name='instance_backend',
    entries=[
      WGPUFlagEntry('all', 0x00000000),
      WGPUFlagEntry('vulkan', 1 << 0),
      WGPUFlagEntry('GL', 1 << 1),
      WGPUFlagEntry('metal', 1 << 2),
      WGPUFlagEntry('DX12', 1 << 3),
      WGPUFlagEntry('browser_webgpu', 1 << 5),
      WGPUFlagEntry('primary', (1 << 0) | (1 << 2) | (1 << 3) | (1 << 5)),
      WGPUFlagEntry('secondary', (1 << 1)),
    ]
  ),
  'instance_flag': WGPUFlag(
    name='instance_flag',
    entries=[
      WGPUFlagEntry('empty', 0x00000000),
      WGPUFlagEntry('debug', 1 << 0),
      WGPUFlagEntry('validation', 1 << 1),
      WGPUFlagEntry('discard_hal_labels', 1 << 2),
      WGPUFlagEntry('allow_underlying_noncompliant_adapters', 1 << 3),
      WGPUFlagEntry('gpu_based_validation', 1 << 4),
      WGPUFlagEntry('validation_indirect_calls', 1 << 5),
      WGPUFlagEntry('automatic_timestamp_normalization', 1 << 6),
      WGPUFlagEntry('default', 1 << 24),
      WGPUFlagEntry('debugging', 1 << 25),
      WGPUFlagEntry('advanced_debugging', 1 << 26),
      WGPUFlagEntry('with_env', 1 << 27),
    ]
  ),
}

STRUCTS: dict[str, WGPUStruct] = {
  'xlib_display_handle': WGPUStruct(
    name='xlib_display_handle',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('display', WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.MUTABLE),
      WGPUStructMember('screen', WGPUType(WGPUTypeKind.INT32)),
    ],
  ),
  'xcb_display_handle': WGPUStruct(
    name='xcb_display_handle',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('connection', WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.MUTABLE),
      WGPUStructMember('screen', WGPUType(WGPUTypeKind.INT32)),
    ],
  ),
  'wayland_display_handle': WGPUStruct(
    name='wayland_display_handle',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('display', WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.MUTABLE),
    ],
  ),
  'native_display_handle': WGPUStruct(
    name='native_display_handle',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('type', WGPUType(WGPUTypeKind.ENUM, 'native_display_handle_type')),
    ],
  ),
  'instance_extras': WGPUStruct(
    name='instance_extras',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('flags', WGPUType(WGPUTypeKind.FLAG, 'instance_flag')),
      WGPUStructMember('dx12_shader_compiler', WGPUType(WGPUTypeKind.ENUM, 'dx12_compiler')),
      WGPUStructMember('gles3_minor_version', WGPUType(WGPUTypeKind.ENUM, 'gles3_minor_version')),
      WGPUStructMember('gl_fence_behaviour', WGPUType(WGPUTypeKind.ENUM, 'GL_fence_behaviour')),
      WGPUStructMember('dxc_path', WGPUType(WGPUTypeKind.STR_OUT)),
      WGPUStructMember('dxc_max_shader_model', WGPUType(WGPUTypeKind.ENUM, 'dxc_max_shader_model')),
      WGPUStructMember('dx12_presentation_system', WGPUType(WGPUTypeKind.ENUM, 'dx12_swapchain_kind')),
      # WGPUStructMember('budget_for_device_creation', WGPUType(WGPUTypeKind.UINT8), pointer=WGPUPointerKind.IMMUTABLE, optional=True),
      # WGPUStructMember('budget_for_device_loss', WGPUType(WGPUTypeKind.UINT8), pointer=WGPUPointerKind.IMMUTABLE, optional=True),
      WGPUStructMember('display_handle', WGPUType(WGPUTypeKind.STRUCT, 'native_display_handle')),
    ]
  ),
  'device_extras': WGPUStruct(
    name='device_extras',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('trace_path', WGPUType(WGPUTypeKind.STR_OUT)),
    ]
   ),
  'native_limits': WGPUStruct(
    name='native_limits',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('max_immediate_size', WGPUType(WGPUTypeKind.UINT32)),
      WGPUStructMember('max_non_sampler_bindings', WGPUType(WGPUTypeKind.UINT32)),
      WGPUStructMember('max_binding_array_elements_per_shader_stage', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'pipeline_layout_extras': WGPUStruct(
    name='pipeline_layout_extras',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('immediate_data_size', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'shader_define': WGPUStruct(
    name='shader_define',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('name', WGPUType(WGPUTypeKind.STR_WITH_DEFAULT_EMPTY)),
      WGPUStructMember('value', WGPUType(WGPUTypeKind.STR_WITH_DEFAULT_EMPTY)),
    ],
  ),
  'shader_source_GLSL': WGPUStruct(
    name='shader_source_GLSL',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('stage', WGPUType(WGPUTypeKind.FLAG, 'shader_stage')),
      WGPUStructMember('code', WGPUType(WGPUTypeKind.STR_WITH_DEFAULT_EMPTY)),
      WGPUStructMember('defines', WGPUType(WGPUTypeKind.ARRAY, array_inner=WGPUType(WGPUTypeKind.STRUCT, 'shader_define')), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'shader_module_descriptor_spir_v': WGPUStruct(
    name='shader_module_descriptor_spir_v',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('label', WGPUType(WGPUTypeKind.STR_WITH_DEFAULT_EMPTY)),
      WGPUStructMember('source_size', WGPUType(WGPUTypeKind.UINT32)),
      WGPUStructMember('source', WGPUType(WGPUTypeKind.UINT32), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'registry_report': WGPUStruct(
    name='registry_report',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('num_allocated', WGPUType(WGPUTypeKind.USIZE)),
      WGPUStructMember('num_kept_from_user', WGPUType(WGPUTypeKind.USIZE)),
      WGPUStructMember('num_released_from_user', WGPUType(WGPUTypeKind.USIZE)),
      WGPUStructMember('element_size', WGPUType(WGPUTypeKind.USIZE)),
    ],
  ),
  'hub_report': WGPUStruct(
    name='hub_report',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('adapters', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('devices', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('queues', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('pipeline_layouts', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('shader_modules', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('bind_group_layouts', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('bind_groups', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('command_buffers', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('render_bundles', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('render_pipelines', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('compute_pipelines', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('query_sets', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('buffers', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('textures', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('texture_views', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('samplers', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
    ],
  ),
  'global_report': WGPUStruct(
    name='global_report',
    type=WGPUStructType.STANDALONE,
    members=[
      WGPUStructMember('surfaces', WGPUType(WGPUTypeKind.STRUCT, 'registry_report')),
      WGPUStructMember('hub', WGPUType(WGPUTypeKind.STRUCT, 'hub_report')),
    ],
  ),
  'instance_enumerate_adapter_options': WGPUStruct(
    name='instance_enumerate_adapter_options',
    type=WGPUStructType.EXTENSIBLE,
    members=[
      WGPUStructMember('backends', WGPUType(WGPUTypeKind.FLAG, 'instance_backend')),
    ],
  ),
  'bind_group_entry_extras': WGPUStruct(
    name='bind_group_entry_extras',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('buffers', WGPUType(WGPUTypeKind.ARRAY, array_inner=WGPUType(WGPUTypeKind.OBJECT, 'buffer')), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUStructMember('samplers', WGPUType(WGPUTypeKind.ARRAY, array_inner=WGPUType(WGPUTypeKind.OBJECT, 'sampler')), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUStructMember('texture_views', WGPUType(WGPUTypeKind.ARRAY, array_inner=WGPUType(WGPUTypeKind.OBJECT, 'texture_view')), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'bind_groupp_layout_entry_extras': WGPUStruct(
    name='bind_group_layout_entry_extras',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('count', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'query_set_descriptor_extras': WGPUStruct(
    name='query_set_descriptor_extras',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('pipeline_statistics', WGPUType(WGPUTypeKind.ARRAY, array_inner=WGPUType(WGPUTypeKind.ENUM, 'pipeline_statistic_name')), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'surface_configuration_extras': WGPUStruct(
    name='surface_configuration_extras',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('desired_maximum_frame_latency', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'surface_source_swap_chain_panel': WGPUStruct(
    name='surface_source_swap_chain_panel',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('panel_native', WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.MUTABLE),
    ],
  ),
  'primitive_state_extras': WGPUStruct(
    name='primitive_state_extras',
    type=WGPUStructType.EXTENSION,
    members=[
      WGPUStructMember('polygon_mode', WGPUType(WGPUTypeKind.ENUM, 'polygon_mode')),
      WGPUStructMember('conservative', WGPUType(WGPUTypeKind.BOOL)),
    ],
  ),
}

FUNCTIONS: dict[str, WGPUFunction] = {
  'generate_report': WGPUFunction(
    name='generate_report',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('instance', WGPUType(WGPUTypeKind.OBJECT, 'instance'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('report', WGPUType(WGPUTypeKind.STRUCT, 'global_report'), pointer=WGPUPointerKind.MUTABLE),
    ],
  ),
  'instance_enumerate_adapters': WGPUFunction(
    name='instance_enumerate_adapters',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.USIZE)),
    args=[
      WGPUFunctionArg('instance', WGPUType(WGPUTypeKind.OBJECT, 'instance'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('options', WGPUType(WGPUTypeKind.STRUCT, 'instance_enumerate_adapter_options'), pointer=WGPUPointerKind.IMMUTABLE, optional=True),
      WGPUFunctionArg('adapters', WGPUType(WGPUTypeKind.ARRAY, array_inner=WGPUType(WGPUTypeKind.OBJECT, 'adapter')), pointer=WGPUPointerKind.MUTABLE, passed_with_ownership=False),
    ],
  ),
  'queue_submit_for_index': WGPUFunction(
    name='queue_submit_for_index',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.UINT64)),
    args=[
      WGPUFunctionArg('queue', WGPUType(WGPUTypeKind.OBJECT, 'queue'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('commands', WGPUType(WGPUTypeKind.ARRAY, array_inner=WGPUType(WGPUTypeKind.OBJECT, 'command_buffer')), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'queue_get_timestamp_period': WGPUFunction(
    name='queue_get_timestamp_period',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.FLOAT32)),
    args=[
      WGPUFunctionArg('queue', WGPUType(WGPUTypeKind.OBJECT, 'queue'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'device_poll': WGPUFunction(
    name='device_poll',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('device', WGPUType(WGPUTypeKind.OBJECT, 'device'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('wait', WGPUType(WGPUTypeKind.BOOL)),
      WGPUFunctionArg('submission_index', WGPUType(WGPUTypeKind.UINT64), pointer=WGPUPointerKind.MUTABLE, optional=True),
    ],
  ),
  'device_create_shader_module_spir_v': WGPUFunction(
    name='device_create_shader_module_spir_v',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.OBJECT, 'shader_module')),
    args=[
      WGPUFunctionArg('device', WGPUType(WGPUTypeKind.OBJECT, 'device'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('descriptor', WGPUType(WGPUTypeKind.STRUCT, 'shader_module_descriptor_spir_v'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  # hand-rolled
  # 'set_log_callback': WGPUFunction(
  #   name='set_log_callback',
  #   ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
  #   args=[
  #     WGPUFunctionArg('callback', WGPUType(WGPUTypeKind.CALLBACK, 'log'), pointer=WGPUPointerKind.IMMUTABLE),
  #     WGPUFunctionArg('userdata', WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.IMMUTABLE),
  #   ],
  # ),
  'set_log_level': WGPUFunction(
    name='set_log_level',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('level', WGPUType(WGPUTypeKind.ENUM, 'log_level')),
    ],
  ),
  'get_version': WGPUFunction(
    name='get_version',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.UINT32)),
    args=[],
  ),
  'device_get_native_metal_device': WGPUFunction(
    name='device_get_native_metal_device',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.MUTABLE),
    args=[
      WGPUFunctionArg('device', WGPUType(WGPUTypeKind.OBJECT, 'device'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'queue_get_native_metal_command_queue': WGPUFunction(
    name='queue_get_native_metal_command_queue',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.MUTABLE),
    args=[
      WGPUFunctionArg('queue', WGPUType(WGPUTypeKind.OBJECT, 'queue'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'texture_get_native_metal_texture': WGPUFunction(
    name='texture_get_native_metal_texture',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.MUTABLE),
    args=[
      WGPUFunctionArg('texture', WGPUType(WGPUTypeKind.OBJECT, 'texture'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'render_pass_encoder_set_immediates': WGPUFunction(
    name='render_pass_encoder_set_immediates',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('offset', WGPUType(WGPUTypeKind.UINT32)),
      WGPUFunctionArg('size_bytes', WGPUType(WGPUTypeKind.UINT32)),
      WGPUFunctionArg('data', WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'compute_pass_encoder_set_immediates': WGPUFunction(
    name='compute_pass_encoder_set_immediates',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'compute_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('offset', WGPUType(WGPUTypeKind.UINT32)),
      WGPUFunctionArg('size_bytes', WGPUType(WGPUTypeKind.UINT32)),
      WGPUFunctionArg('data', WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'render_bundle_encoder_set_immediates': WGPUFunction(
    name='render_bundle_encoder_set_immediates',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_bundle_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('offset', WGPUType(WGPUTypeKind.UINT32)),
      WGPUFunctionArg('size_bytes', WGPUType(WGPUTypeKind.UINT32)),
      WGPUFunctionArg('data', WGPUType(WGPUTypeKind.VOID), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'render_pass_encoder_multi_draw_indirect': WGPUFunction(
    name='render_pass_encoder_multi_draw_indirect',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('buffer', WGPUType(WGPUTypeKind.OBJECT, 'buffer'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('offset', WGPUType(WGPUTypeKind.UINT64)),
      WGPUFunctionArg('count', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'render_pass_encoder_multi_draw_indexed_indirect': WGPUFunction(
    name='render_pass_encoder_multi_draw_indexed_indirect',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('buffer', WGPUType(WGPUTypeKind.OBJECT, 'buffer'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('offset', WGPUType(WGPUTypeKind.UINT64)),
      WGPUFunctionArg('count', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'render_pass_encoder_multi_draw_indirect_count': WGPUFunction(
    name='render_pass_encoder_multi_draw_indirect_count',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('buffer', WGPUType(WGPUTypeKind.OBJECT, 'buffer'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('offset', WGPUType(WGPUTypeKind.UINT64)),
      WGPUFunctionArg('count_buffer', WGPUType(WGPUTypeKind.OBJECT, 'buffer'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('count_buffer_offset', WGPUType(WGPUTypeKind.UINT64)),
      WGPUFunctionArg('max_count', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'render_pass_encoder_multi_draw_indexed_indirect_count': WGPUFunction(
    name='render_pass_encoder_multi_draw_indexed_indirect_count',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('buffer', WGPUType(WGPUTypeKind.OBJECT, 'buffer'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('offset', WGPUType(WGPUTypeKind.UINT64)),
      WGPUFunctionArg('count_buffer', WGPUType(WGPUTypeKind.OBJECT, 'buffer'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('count_buffer_offset', WGPUType(WGPUTypeKind.UINT64)),
      WGPUFunctionArg('max_count', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'compute_pass_encoder_begin_pipeline_statistics_query': WGPUFunction(
    name='compute_pass_encoder_begin_pipeline_statistics_query',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'compute_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('query_set', WGPUType(WGPUTypeKind.OBJECT, 'query_set'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('query_index', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'compute_pass_encoder_end_pipeline_statistics_query': WGPUFunction(
    name='compute_pass_encoder_end_pipeline_statistics_query',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'compute_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'render_pass_encoder_begin_pipeline_statistics_query': WGPUFunction(
    name='render_pass_encoder_begin_pipeline_statistics_query',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('query_set', WGPUType(WGPUTypeKind.OBJECT, 'query_set'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('query_index', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'render_pass_encoder_end_pipeline_statistics_query': WGPUFunction(
    name='render_pass_encoder_end_pipeline_statistics_query',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'compute_pass_encoder_write_timestamp': WGPUFunction(
    name='compute_pass_encoder_write_timestamp',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'compute_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('query_set', WGPUType(WGPUTypeKind.OBJECT, 'query_set'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('query_index', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'render_pass_encoder_write_timestamp': WGPUFunction(
    name='render_pass_encoder_write_timestamp',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('encoder', WGPUType(WGPUTypeKind.OBJECT, 'render_pass_encoder'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('query_set', WGPUType(WGPUTypeKind.OBJECT, 'query_set'), pointer=WGPUPointerKind.IMMUTABLE),
      WGPUFunctionArg('query_index', WGPUType(WGPUTypeKind.UINT32)),
    ],
  ),
  'device_start_graphics_debugger_capture': WGPUFunction(
    name='device_start_graphics_debugger_capture',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.BOOL)),
    args=[
      WGPUFunctionArg('device', WGPUType(WGPUTypeKind.OBJECT, 'device'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
  'device_stop_graphics_debugger_capture': WGPUFunction(
    name='device_stop_graphics_debugger_capture',
    ret=WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID)),
    args=[
      WGPUFunctionArg('device', WGPUType(WGPUTypeKind.OBJECT, 'device'), pointer=WGPUPointerKind.IMMUTABLE),
    ],
  ),
}

CALLBACKS: dict[str, WGPUCallback] = {
  'log': WGPUCallback(
    name='log',
    style=WGPUCallbackStyle.IMMEDIATE,
    userdatas=1,
    args=[
      WGPUFunctionArg('level', WGPUType(WGPUTypeKind.ENUM, 'log_level')),
      WGPUFunctionArg('message', WGPUType(WGPUTypeKind.STR_OUT)),
    ],
  ),
}

if __name__ == '__main__':
  parse()
  generate(
    OUT_PATH,
    preludes=[
      f'// ignore_for_file: invalid_use_of_protected_member, unreachable_switch_case, unused_import',
      f'',
      f'import \'../webgpu/webgpu.g.dart\';',
      f'part \'wgpu_native_extensions.dart\';',
    ],
    chained_struct_prefix='WGPUNative',
    external=True,
    enums=ENUMS,
    flags=FLAGS,
    structs=STRUCTS,
    global_functions=FUNCTIONS,
    callbacks=CALLBACKS,
    constants=dict(),
    objects=dict(),
  )
