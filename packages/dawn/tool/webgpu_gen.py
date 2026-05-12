#!/usr/bin/env python3

import sys
import subprocess
import pathlib
import clang.cindex
from clang.cindex import CursorKind, TypeKind, Type
from _common import root, digits, to_upper_camel_case, to_lower_camel_case
from _clang_helpers import get_dart_comment_lines, has_doc_comment_lines, indent
from dataclasses import dataclass, field
from enum import Enum, auto
from typing import Optional

output_enums = root / 'lib' / 'src' / 'gen' / 'webgpu_enums.dart'
output_flags = root / 'lib' / 'src' / 'gen' / 'webgpu_flags.dart'
output_types = root / 'lib' / 'src' / 'gen' / 'webgpu_types.dart'
output_structs = root / 'lib' / 'src' / 'gen' / 'webgpu_structs.dart'
output_callbacks = root / 'lib' / 'src' / 'gen' / 'webgpu_callbacks.dart'
output_methods = root / 'lib' / 'src' / 'gen' / 'webgpu_methods.dart'


opaque_types: map[str, 'WGPUOpaqueType'] = {}
enums: map[str, 'WGPUEnum'] = {}
flags: map[str, 'WGPUFlag'] = {}
structs: map[str, 'WGPUStruct'] = {}
callbacks: map[str, 'WGPUCallback'] = {}
methods: map[str, 'WGPUMethod'] = {}

method_names: set[str] = set()
callback_names: set[str] = set()


OWNED_CALLBACK_HANDLES: dict[str, set[str]] = {
  'WGPURequestAdapterCallback': {'arg1'},
  'WGPURequestDeviceCallback': {'arg1'},
  'WGPUCreateComputePipelineAsyncCallback': {'arg1'},
  'WGPUCreateRenderPipelineAsyncCallback': {'arg1'},
}

REPEATING_STRUCT_CALLBACKS: set[str] = {
  'WGPUUncapturedErrorCallback',
  'WGPULoggingCallback',
  'WGPUDeviceLostCallback',
}

IGNORED_STRUCTS: set[str] = {
  'WGPUChainedStruct',
  'WGPUDawnCacheDeviceDescriptor',
}

RENAMED: dict[str, str] = {
  'Future': 'WGPUFuture',
}

IGNORED_METHODS: set[str] = {
  'wgpuBufferReadMappedRange',
  'wgpuBufferWriteMappedRange',
  'wgpuBufferGetMappedRange',
  'wgpuBufferGetConstMappedRange',
  'wgpuQueueWriteBuffer',
  'wgpuQueueWriteTexture',
  'wgpuSharedBufferMemoryEndAccess',
  'wgpuSharedTextureMemoryEndAccess',
}

SENTINEL_FIELDS: dict[tuple[str, str], str] = {
  ('WGPURenderPassColorAttachment', 'depthSlice'): 'WGPU_DEPTH_SLICE_UNDEFINED',

  ('WGPUTextureViewDescriptor', 'mipLevelCount'): 'WGPU_MIP_LEVEL_COUNT_UNDEFINED',
  ('WGPUTextureViewDescriptor', 'arrayLayerCount'): 'WGPU_ARRAY_LAYER_COUNT_UNDEFINED',

  ('WGPUTextureDescriptor', 'mipLevelCount'): 'WGPU_MIP_LEVEL_COUNT_UNDEFINED',

  ('WGPURenderPassDepthStencilAttachment', 'depthClearValue'): 'WGPU_DEPTH_CLEAR_VALUE_UNDEFINED',

  ('WGPUTexelCopyBufferLayout', 'bytesPerRow'): 'WGPU_COPY_STRIDE_UNDEFINED',
  ('WGPUTexelCopyBufferLayout', 'rowsPerImage'): 'WGPU_COPY_STRIDE_UNDEFINED',
  ('WGPUImageCopyBuffer', 'bytesPerRow'): 'WGPU_COPY_STRIDE_UNDEFINED',
  ('WGPUImageCopyBuffer', 'rowsPerImage'): 'WGPU_COPY_STRIDE_UNDEFINED',

  ('WGPURenderPassTimestampWrites', 'beginningOfPassWriteIndex'): 'WGPU_QUERY_SET_INDEX_UNDEFINED',
  ('WGPURenderPassTimestampWrites', 'endOfPassWriteIndex'): 'WGPU_QUERY_SET_INDEX_UNDEFINED',
  ('WGPUComputePassTimestampWrites', 'beginningOfPassWriteIndex'): 'WGPU_QUERY_SET_INDEX_UNDEFINED',
  ('WGPUComputePassTimestampWrites', 'endOfPassWriteIndex'): 'WGPU_QUERY_SET_INDEX_UNDEFINED',
}

########################################################################################################
# Type classifier
########################################################################################################


class TypeCategory(Enum):
  VOID = auto()  # void
  BOOL = auto()  # WGPUBool
  INT = auto()  # int/uint/size_t
  FLOAT = auto()  # float/double
  STRING = auto()  # char *
  VOID_PTR = auto()  # void *
  RAW_PTR = auto()  # float*, int*
  ENUM = auto()
  FLAG = auto()
  OPAQUE = auto()
  STRUCT = auto()
  CALLBACK = auto()
  UNKNOWN = auto()


@dataclass
class ClassifiedType:
  category: TypeCategory
  c_spelling: str
  base_name: str
  is_pointer: bool
  inner: Optional['ClassifiedType'] = None

  @property
  def is_string(self) -> bool: return self.category == TypeCategory.STRING

  @property
  def is_bool(self) -> bool: return self.category == TypeCategory.BOOL

  @property
  def is_int(self) -> bool: return self.category == TypeCategory.INT

  @property
  def is_float(self) -> bool: return self.category == TypeCategory.FLOAT

  @property
  def is_enum(self) -> bool: return self.category == TypeCategory.ENUM

  @property
  def is_flag(self) -> bool: return self.category == TypeCategory.FLAG

  @property
  def is_opaque(self) -> bool: return self.category == TypeCategory.OPAQUE

  @property
  def is_struct(self) -> bool: return self.category == TypeCategory.STRUCT

  @property
  def is_callback(self) -> bool: return self.category == TypeCategory.CALLBACK

  @property
  def is_void_ptr(self) -> bool: return self.category == TypeCategory.VOID_PTR

  @property
  def is_void(self) -> bool: return self.category == TypeCategory.VOID


def _clean_spelling(spelling: str) -> str:
  s = spelling.replace('struct ', '')
  s = s.replace('const ', '')
  s = s.replace('*const', '*')
  s = s.replace('* const', '*')
  return s.strip()


_INT_KIND_TO_C_SPELLING = {
  TypeKind.UCHAR: 'uint8_t',
  TypeKind.SCHAR: 'int8_t',
  TypeKind.CHAR_S: 'int8_t',
  TypeKind.CHAR_U: 'uint8_t',
  TypeKind.USHORT: 'uint16_t',
  TypeKind.SHORT: 'int16_t',
  TypeKind.UINT: 'uint32_t',
  TypeKind.INT: 'int32_t',
  TypeKind.ULONG: 'uint64_t',
  TypeKind.LONG: 'int64_t',
  TypeKind.ULONGLONG: 'uint64_t',
  TypeKind.LONGLONG: 'int64_t',
}

_FLOAT_KIND_TO_C_SPELLING = {
  TypeKind.FLOAT: 'float',
  TypeKind.DOUBLE: 'double',
}


def _canonical_int_spelling(t: clang.cindex.Type) -> str | None: return _INT_KIND_TO_C_SPELLING.get(t.kind)
def _canonical_float_spelling(t: clang.cindex.Type) -> str | None: return _FLOAT_KIND_TO_C_SPELLING.get(t.kind)


def classify_type(c_type: clang.cindex.Type) -> ClassifiedType:
  spelling = _clean_spelling(c_type.spelling)

  if spelling in opaque_types: return ClassifiedType(TypeCategory.OPAQUE, spelling, spelling, False)
  if spelling in callback_names: return ClassifiedType(TypeCategory.CALLBACK, spelling, spelling, True)
  if spelling in enums: return ClassifiedType(TypeCategory.ENUM, spelling, spelling, False)
  if spelling in flags: return ClassifiedType(TypeCategory.FLAG, spelling, spelling, False)
  if spelling in structs: return ClassifiedType(TypeCategory.STRUCT, spelling, spelling, False)

  is_pointer = c_type.kind == TypeKind.POINTER

  if is_pointer:
    pointee = c_type.get_pointee()
    pointee_spelling = _clean_spelling(pointee.spelling)

    if pointee_spelling == 'char': return ClassifiedType(TypeCategory.STRING, spelling, 'char', True)
    if pointee_spelling == 'void': return ClassifiedType(TypeCategory.VOID_PTR, spelling, 'void', True)

    if pointee_spelling in opaque_types: return ClassifiedType(TypeCategory.OPAQUE, spelling, pointee_spelling, True)

    if pointee_spelling.startswith('WGPU'):
      if pointee_spelling.endswith('Impl'):
        base = pointee_spelling[:-4]
        if base in opaque_types: return ClassifiedType(TypeCategory.OPAQUE, spelling, base, True)

      if pointee_spelling in structs:
        inner = classify_type(pointee)
        return ClassifiedType(TypeCategory.STRUCT, spelling, pointee_spelling, True, inner)

      if pointee_spelling in callback_names:
        return ClassifiedType(TypeCategory.CALLBACK, spelling, pointee_spelling, True)

    canonical_int = _canonical_int_spelling(pointee)
    canonical_float = _canonical_float_spelling(pointee)
    if canonical_int is not None: return ClassifiedType(TypeCategory.RAW_PTR, spelling, canonical_int, True)
    if canonical_float is not None: return ClassifiedType(TypeCategory.RAW_PTR, spelling, canonical_float, True)
    return ClassifiedType(TypeCategory.RAW_PTR, spelling, pointee_spelling, True)

  if spelling == 'void': return ClassifiedType(TypeCategory.VOID, spelling, 'void', False)
  if spelling == 'WGPUBool': return ClassifiedType(TypeCategory.BOOL, spelling, spelling, False)
  if spelling in ('uint8_t', 'uint16_t', 'uint32_t', 'uint64_t', 'int8_t', 'int16_t', 'int32_t', 'int64_t', 'size_t', 'int'):
    return ClassifiedType(TypeCategory.INT, spelling, spelling, False)

  if spelling in ('float', 'double'):
    return ClassifiedType(TypeCategory.FLOAT, spelling, spelling, False)

  if spelling.startswith('WGPU'):
    if spelling in enums: return ClassifiedType(TypeCategory.ENUM, spelling, spelling, False)
    if spelling in flags: return ClassifiedType(TypeCategory.FLAG, spelling, spelling, False)
    if spelling in structs: return ClassifiedType(TypeCategory.STRUCT, spelling, spelling, False)

  print(f'Warning (classify_type): unrecognized type "{spelling}", defaulting to dynamic')
  return ClassifiedType(TypeCategory.UNKNOWN, spelling, spelling, is_pointer)


def dart_type_name(t: ClassifiedType) -> str:
  c = t.category

  if c == TypeCategory.VOID: return 'void'
  if c == TypeCategory.BOOL: return 'bool'
  if c == TypeCategory.INT: return 'int'
  if c == TypeCategory.FLOAT: return 'double'
  if c == TypeCategory.STRING: return 'String'
  if c == TypeCategory.VOID_PTR: return 'Pointer<Void>'
  if c == TypeCategory.ENUM: return enums[t.base_name].dart_name
  if c == TypeCategory.FLAG: return flags[t.base_name].dart_name
  if c == TypeCategory.OPAQUE: return opaque_types[t.base_name].dart_name
  if c == TypeCategory.STRUCT:
    if t.base_name == 'WGPUStringView': return 'String'
    return structs[t.base_name].dart_name
  if c == TypeCategory.CALLBACK:
    cb = callbacks.get(t.base_name)
    return f'{cb.dart_name}Listener' if cb.is_repeating else cb.dart_name
  if c == TypeCategory.RAW_PTR:
    if t.base_name == 'char*' or t.c_spelling in ('char **', 'char * *'): return 'Pointer<Pointer<ffi.Utf8>>'
    if t.base_name == 'float': return 'Pointer<Float>'
    if t.base_name == 'size_t': return 'Pointer<Size>'
    if t.base_name == 'uint64_t': return 'Pointer<Uint64>'
    if t.base_name in ('int', 'int32_t'): return 'Pointer<Int32>'
    if t.base_name == 'uint32_t': return 'Pointer<Uint32>'
    if t.base_name == 'uint8_t': return 'Pointer<Uint8>'
    return 'Pointer<Void>'

  # print(f'Warning (dart_type_name): unrecognized type category for "{t.c_spelling}", defaulting to dynamic')
  return 'dynamic'


def ffi_native_type(t: ClassifiedType) -> str:
  c = t.category

  if c == TypeCategory.VOID: return 'Void'
  if c == TypeCategory.BOOL: return 'Uint32'
  if c == TypeCategory.INT:
    if t.c_spelling == 'size_t': return 'Size'
    if t.c_spelling == 'uint64_t': return 'Uint64'
    if t.c_spelling == 'int64_t': return 'Int64'
    if t.c_spelling in ('int32_t', 'int'): return 'Int32'
    if t.c_spelling == 'int16_t': return 'Int16'
    if t.c_spelling == 'int8_t': return 'Int8'
    if t.c_spelling == 'uint16_t': return 'Uint16'
    if t.c_spelling == 'uint8_t': return 'Uint8'
    return 'Uint32'
  if c == TypeCategory.FLOAT:
    if t.c_spelling == 'float': return 'Float'
    if t.c_spelling == 'double': return 'Double'
  if c == TypeCategory.STRING: return 'Pointer<ffi.Utf8>'
  if c == TypeCategory.VOID_PTR: return 'Pointer<Void>'
  if c == TypeCategory.ENUM or c == TypeCategory.FLAG: return f'UnsignedInt'
  if c == TypeCategory.OPAQUE:
    if t.is_pointer: return f'Pointer<bindings.{t.base_name}>'
    else: return f'Pointer<bindings.{t.base_name}Impl>'
  if c == TypeCategory.STRUCT:
    if t.is_pointer: return f'Pointer<bindings.{t.base_name}>'
    return f'bindings.{t.base_name}'
  if c == TypeCategory.CALLBACK:
    cb = callbacks.get(t.base_name)
    native_typedef = f'{cb.dart_name}Native' if cb else 'Void'
    return f'Pointer<NativeFunction<{native_typedef}>>'

  print(f'Warning (ffi_native_type): unrecognized type category for "{t.c_spelling}", defaulting to Pointer<Void>')
  return 'Pointer<Void>'


def ffi_dart_type(t: ClassifiedType) -> str:
  c = t.category

  if c == TypeCategory.VOID: return 'void'
  if c == TypeCategory.BOOL or c == TypeCategory.INT: return 'int'
  if c == TypeCategory.ENUM or c == TypeCategory.FLAG: return 'int'
  if c == TypeCategory.FLOAT: return 'double'
  if c == TypeCategory.STRING: return 'Pointer<ffi.Utf8>'
  if c == TypeCategory.VOID_PTR: return 'Pointer<Void>'
  if c == TypeCategory.OPAQUE:
    if t.is_pointer: return f'Pointer<bindings.{t.base_name}>'
    else: return f'Pointer<bindings.{t.base_name}Impl>'
  if c == TypeCategory.STRUCT:
    if t.is_pointer: return f'Pointer<bindings.{t.base_name}>'
    return f'bindings.{t.base_name}'
  if c == TypeCategory.CALLBACK:
    cb = callbacks.get(t.base_name)
    native_typedef = f'{cb.dart_name}Native' if cb else 'Void'
    return f'Pointer<NativeFunction<{native_typedef}>>'

  print(f'Warning (ffi_dart_type): unrecognized type category for "{t.c_spelling}", defaulting to Pointer<Void>')
  return 'Pointer<Void>'


def to_native_expr(t: ClassifiedType, expr: str, nullable: bool = False, enum_as_int: bool = True) -> str:
  c = t.category

  _expr = expr
  _nexpr = f'{_expr}?' if nullable else _expr

  if c == TypeCategory.BOOL: _expr = f'({expr} ? 1 : 0)'
  if c == TypeCategory.INT or c == TypeCategory.FLOAT: _expr = expr
  if c == TypeCategory.STRING: _expr = f'{_nexpr}.toNativeUtf8(allocator: allocator).cast()'
  if c == TypeCategory.ENUM and not enum_as_int: _expr = f'{expr}.toNative()'
  if (c == TypeCategory.ENUM and enum_as_int) or c == TypeCategory.FLAG: _expr = f'{expr}.value'
  if c == TypeCategory.OPAQUE: _expr = f'{_nexpr}._ptr'
  if c == TypeCategory.STRUCT:
    if t.base_name == 'WGPUStringView': _nexpr = f'StringView(data: {_expr}, length: {_expr}.length)'

    if t.is_pointer: _expr = f'{_nexpr}.toNative(allocator)'
    else: _expr = f'{_nexpr}.toNative(allocator).ref'
  if c == TypeCategory.CALLBACK:
    cb = callbacks.get(t.base_name)
    registry = f'_{cb.dart_name}Registry'
    _expr = f'{registry}._nativeFunction'
  if c == TypeCategory.VOID_PTR or c == TypeCategory.RAW_PTR: _expr = expr

  if not nullable: return _expr

  if c == TypeCategory.STRUCT and not t.is_pointer:
    return f'{_expr} ?? allocator<bindings.{t.base_name}>().ref'

  print(f'Warning (to_native_expr): nullable not fully supported for type category {c}, defaulting to null pointer')
  return f'({_expr} ?? nullptr)'


def from_native_expr(t: ClassifiedType, expr: str, nullable: bool = False, enum_as_int: bool = True, opaque_borrow: bool = False) -> str:
  c = t.category
  _expr = expr

  if c == TypeCategory.BOOL: _expr = f'({expr} != 0)'
  if c == TypeCategory.INT or c == TypeCategory.FLOAT: _expr = expr
  if c == TypeCategory.STRING: _expr = f'{expr}.cast<ffi.Utf8>().toDartString()'
  if c == TypeCategory.ENUM and enum_as_int: _expr = f'{dart_type_name(t)}.fromValue({expr})'
  if c == TypeCategory.ENUM and not enum_as_int: _expr = f'{dart_type_name(t)}.fromNative({expr})'
  if c == TypeCategory.FLAG: _expr = f'{dart_type_name(t)}({expr})'
  if c == TypeCategory.OPAQUE:
    ctor = '_borrowed' if opaque_borrow else '_'
    expr = f'{expr}.cast()' if opaque_borrow else f'{expr}'
    _expr = f'{dart_type_name(t)}.{ctor}({expr})'
  if c == TypeCategory.STRUCT:
    if t.base_name == 'WGPUStringView':
      _expr = f'StringView.fromNative({expr}).toDartString()'
      expr = f'{expr}.data'
    elif t.is_pointer: _expr = f'{dart_type_name(t)}.fromNative({expr}.ref)'
    else: _expr = f'{dart_type_name(t)}.fromNative({expr})'

  if not nullable: return _expr

  return f'({expr} != nullptr ? {_expr} : null)'


########################################################################################################
# Opaque types
########################################################################################################


@dataclass
class WGPUOpaqueType:
  cursor: clang.cindex.Cursor
  pointee_name: str
  dart_name: str

  @property
  def spelling(self) -> str: return self.cursor.spelling


def parse_opaque_type(cursor: clang.cindex.Cursor) -> WGPUOpaqueType:
  dart_name = cursor.spelling
  if dart_name.startswith('WGPU'): dart_name = dart_name[4:]
  if dart_name.endswith('Impl'): dart_name = dart_name[:-4]

  pointee_name = dart_name
  dart_name = to_upper_camel_case(dart_name)

  return WGPUOpaqueType(cursor, pointee_name, dart_name)


def generate_opaque_type_code(opaque_type: WGPUOpaqueType) -> list[str]:
  template = [
    'class _{dart_name} with _NativeOwned<bindings.WGPU{c_name}Impl> {{',
    '  _{dart_name}._(Pointer<bindings.WGPU{c_name}Impl> ptr) {{',
    '    _attach(ptr, _finalizer);',
    '  }}',
    '',
    '  _{dart_name}._borrowed(Pointer<bindings.WGPU{c_name}Impl> ptr) {{',
    '    _borrow(ptr);',
    '  }}',
    '',
    '  static final _finalizer = NativeFinalizer(bindings.addresses.wgpu{c_name}Release.cast());',
    '',
    '  @override',
    '  void dispose() => _dispose(bindings.wgpu{c_name}Release, _finalizer);',
    '}}',
  ]

  template_str = '\n'.join(template).format(dart_name=opaque_type.dart_name, c_name=opaque_type.pointee_name)
  return template_str.splitlines()


########################################################################################################
# Flags
########################################################################################################


@dataclass
class WGPUFlagValue:
  cursor: clang.cindex.Cursor
  dart_name: str
  value: int

  @property
  def spelling(self) -> str: return self.cursor.spelling


@dataclass
class WGPUFlag:
  cursor: clang.cindex.Cursor
  dart_name: str
  values: list[WGPUFlagValue]

  @property
  def spelling(self) -> str: return self.cursor.spelling


def parse_flag_typedef(cursor: clang.cindex.Cursor) -> WGPUFlag:
  name = cursor.spelling
  if name.startswith('WGPU'): name = name[4:]
  dart_name = to_upper_camel_case(name)
  return WGPUFlag(cursor, dart_name, [])


def parse_append_flag_value(cursor: clang.cindex.Cursor):
  tokens = list(cursor.get_tokens())
  value_str = '0'

  for i, token in enumerate(tokens):
    if token.spelling == '=' and i + 1 < len(tokens):
      value_str = tokens[i + 1].spelling
      break

  try:
    val_int = int(value_str.rstrip('uL'), 0)
  except ValueError:
    print(f'Warning: failed to parse flag value "{value_str}" for {cursor.spelling}, defaulting to 0')
    val_int = 0

  type_spelling = cursor.type.spelling
  if type_spelling.startswith('const '): type_spelling = type_spelling[6:]

  member_name = cursor.spelling[len(type_spelling) + 1:]
  if member_name == 'Force32': return

  dart_member_name = to_lower_camel_case(member_name)
  flags[type_spelling].values.append(WGPUFlagValue(cursor, dart_member_name, val_int))


def generate_flag_code(flag: WGPUFlag) -> list[str]:
  lines = [
    f'extension type const {flag.dart_name}(int value) {{',
  ]

  dart_name = flag.dart_name

  for value in flag.values:
    lines.append(f'  static const {value.dart_name} = {dart_name}({value.value});')

  lines.append('')
  lines.append(f'  static {dart_name} of(List<{dart_name}> flags) => {dart_name}(flags.fold(0, (v, f) => v | f.value));')
  lines.append('')
  lines.append(f'  bool contains({dart_name} flag) => (value & flag.value) == flag.value;')
  for value in flag.values:
    cap = value.dart_name[0].upper() + value.dart_name[1:]
    lines.append(f'  bool get has{cap} => contains(.{value.dart_name});')
  lines.append('')
  lines.append(f'  {dart_name} operator |({dart_name} other) => {dart_name}(value | other.value);')
  lines.append(f'  {dart_name} operator &({dart_name} other) => {dart_name}(value & other.value);')
  lines.append(f'  {dart_name} operator ^({dart_name} other) => {dart_name}(value ^ other.value);')
  lines.append(f'  {dart_name} operator ~() => {dart_name}(~value);')
  lines.append('}')

  return lines


########################################################################################################
# Enums
########################################################################################################


@dataclass
class WGPUEnumValue:
  cursor: clang.cindex.Cursor
  dart_name: str
  value: int

  @property
  def spelling(self) -> str: return self.cursor.spelling


@dataclass
class WGPUEnum:
  cursor: clang.cindex.Cursor
  dart_name: str
  values: list[WGPUEnumValue]

  @property
  def spelling(self) -> str: return self.cursor.spelling


def parse_enum(cursor: clang.cindex.Cursor) -> WGPUEnum:
  name = cursor.spelling
  if name.startswith('WGPU'): name = name[4:]
  dart_name = to_upper_camel_case(name)

  values: list[WGPUEnumValue] = []
  for child in cursor.get_children():
    if child.kind == CursorKind.ENUM_CONSTANT_DECL:
      value = child.enum_value
      value_name = child.spelling
      value_name = value_name[len(cursor.spelling) + 1:]
      if value_name == 'Force32': continue

      dart_value_name = to_lower_camel_case(value_name)
      if dart_value_name in ('true', 'false', 'null'): dart_value_name += '_'

      values.append(WGPUEnumValue(child, dart_value_name, value))

  return WGPUEnum(cursor, dart_name, values)


def generate_enum_code(enum: WGPUEnum) -> list[str]:
  lines = [f'enum {enum.dart_name} {{']

  for value in enum.values:
    lines.append(f'  {value.dart_name}({value.value}),')
  lines[-1] = lines[-1].rstrip(',') + ';'

  lines.append('')
  lines.append(f'  const {enum.dart_name}(this.value);')
  lines.append(f'  final int value;')
  lines.append('')

  # toNative
  lines.append(f'  bindings.{enum.spelling} toNative() => switch (this) {{')
  for value in enum.values:
    lines.append(f'    {enum.dart_name}.{value.dart_name} => bindings.{enum.spelling}.{value.spelling},')
  lines.append('  };')
  lines.append('')

  # fromNative
  lines.append(f'  static {enum.dart_name} fromNative(bindings.{enum.spelling} v) => switch (v) {{')
  for value in enum.values:
    lines.append(f'    bindings.{enum.spelling}.{value.spelling} => {enum.dart_name}.{value.dart_name},')
  lines.append(f'    _ => throw ArgumentError(\'Invalid native value for {enum.dart_name}: $v\'),')
  lines.append('  };')
  lines.append('')

  # fromValue
  lines.append(f'  static {enum.dart_name} fromValue(int value) => switch (value) {{')
  for value in enum.values:
    lines.append(f'    {value.value} => {enum.dart_name}.{value.dart_name},')
  lines.append(f'    _ => throw ArgumentError(\'Invalid value for {enum.dart_name}: $value\'),')
  lines.append('  };')

  lines.append('}')

  return lines


########################################################################################################
# Structs
########################################################################################################


@dataclass
class WGPUStructField:
  cursor: clang.cindex.Cursor
  field_name: str
  dart_name: str
  classified: ClassifiedType
  array_element: ClassifiedType | None
  array_count_field_name: str | None
  nullable: bool

  @property
  def spelling(self) -> str: return self.cursor.spelling

  @property
  def is_array(self) -> bool: return self.array_element is not None

  @property
  def dart_type(self) -> str: return dart_type_name(self.array_element if self.is_array else self.classified)

  @property
  def is_nullable(self) -> bool:
    if self.is_array: return False

    t = self.classified
    if t.is_string or t.base_name == 'WGPUStringView': return True
    if t.is_struct and not t.is_pointer: return True

    is_pointer_typed = (
      t.is_opaque or t.is_callback or
      (t.is_struct and t.is_pointer) or
      (t.is_pointer and t.category == TypeCategory.RAW_PTR) or
      t.is_void_ptr
    )

    return is_pointer_typed and self.nullable

  def _sentinel(self, struct_name: str) -> str | None:
    return SENTINEL_FIELDS.get((struct_name, self.field_name))


@dataclass
class WGPUStruct:
  cursor: clang.cindex.Cursor
  name: str
  dart_name: str
  fields: list[WGPUStructField]
  chain_stype: str | None = None

  @property
  def spelling(self) -> str: return self.cursor.spelling


def _has_wgpu_nullable(field_cursor: clang.cindex.Cursor) -> bool:
  for child in field_cursor.get_children():
    if child.kind == CursorKind.ANNOTATE_ATTR and 'nullable' in child.spelling.lower():
      return True
  return False


def _detect_chain_stype(cursor: clang.cindex.Cursor) -> str | None:
  raw_fields = [f for f in cursor.get_children() if f.kind == CursorKind.FIELD_DECL]
  if not raw_fields: return None
  first = raw_fields[0]
  if first.spelling != 'chain': return None
  if first.type.kind != TypeKind.ELABORATED and first.type.spelling != 'WGPUChainedStruct':
    if first.type.get_canonical().spelling != 'WGPUChainedStruct': return None

  c_short = cursor.spelling[4:]
  return f'WGPUSType_{c_short}'


def parse_struct(cursor: clang.cindex.Cursor) -> WGPUStruct:
  c_name = cursor.spelling

  dart_name = c_name
  if dart_name.startswith('WGPU'): dart_name = dart_name[4:]
  dart_name = to_upper_camel_case(dart_name)
  if dart_name in RENAMED: dart_name = RENAMED[dart_name]

  chain_stype = _detect_chain_stype(cursor)

  raw_fields = [f for f in cursor.get_children() if f.kind == CursorKind.FIELD_DECL]

  array_counts = {}
  for f in raw_fields:
    if f.type.kind == TypeKind.POINTER:
      candidates = []
      name = f.spelling

      if name.endswith('ies'): candidates.append(name[:-3] + 'yCount')
      if name.endswith('s'): candidates.append(name[:-1] + 'Count')
      candidates.append(name + 'Count')

      for cand in candidates:
        if any(other.spelling == cand for other in raw_fields):
          array_counts[cand] = f.spelling
          break

  fields = []
  for f in raw_fields:
    c_field_name = f.spelling
    if chain_stype is not None and c_field_name == 'chain': continue

    # special case for head chained structs
    if c_field_name == 'nextInChain':
      fields.append(
        WGPUStructField(
          cursor=f,
          field_name='nextInChain',
          dart_name='next',
          classified=ClassifiedType(TypeCategory.STRUCT, 'WGPUChainedStruct', 'WGPUChainedStruct', True),
          array_element=None,
          array_count_field_name=None,
          nullable=True,
        )
      )

      continue

    if c_field_name in array_counts: continue

    dart_field_name = to_lower_camel_case(c_field_name)

    is_array = False
    array_count_field_name = None

    for count_name, ptr_name in array_counts.items():
      if ptr_name == c_field_name:
        is_array = True
        array_count_field_name = count_name
        break

    classified = classify_type(f.type)
    array_element = classify_type(f.type.get_pointee()) if is_array else None

    fields.append(
      WGPUStructField(
        cursor=f,
        field_name=c_field_name,
        dart_name=dart_field_name,
        classified=classified,
        array_element=array_element,
        array_count_field_name=array_count_field_name,
        nullable=_has_wgpu_nullable(f),
      )
    )

  return WGPUStruct(cursor, c_name, dart_name, fields, chain_stype)


def generate_struct_code(struct: WGPUStruct) -> list[str]:
  if struct.chain_stype:
    lines = [f'class {struct.dart_name} extends ChainedStruct {{']
  else:
    lines = [f'class {struct.dart_name} {{']

  # Detect userdata fields
  userdatas = []
  for f in reversed(struct.fields):
    if f.classified.is_void_ptr and f.field_name.lower().startswith('userdata'):
      userdatas.append(f)
    else:
      break

  userdatas = list(reversed(userdatas))
  visible_fields = [f for f in struct.fields if f not in userdatas]

  constructor_lines = []
  field_lines = []
  to_native_lines = []
  from_native_lines = []

  # Constructor
  constructor_lines.append(f'  const {struct.dart_name}({{')

  for f in visible_fields:
    t = f.array_element if f.is_array else f.classified
    sentinel = f._sentinel(struct.name)

    default_value = None

    if sentinel is not None: default_value = f'bindings.{sentinel}'
    elif f.is_array: default_value = 'const []'
    elif t.is_bool: default_value = 'false'
    elif t.is_int or t.is_float: default_value = '0'
    elif t.is_enum:
      enum_values = enums[f.cursor.type.spelling].values
      default_value = f'{f.dart_type}.{enum_values[0].dart_name}'
    elif t.is_flag: default_value = f'const {f.dart_type}(0)'

    if default_value is not None: constructor_lines.append(f'    this.{f.dart_name} = {default_value},')
    elif f.is_nullable: constructor_lines.append(f'    this.{f.dart_name},')
    else: constructor_lines.append(f'    required this.{f.dart_name},')

  if struct.chain_stype:
    constructor_lines.append(f'    super.next,')

  constructor_lines.append('  });')

  # Fields
  for f in visible_fields:
    t = f.array_element if f.is_array else f.classified
    if f.is_array:
      field_lines.append(f'  final List<{f.dart_type}> {f.dart_name};')
    elif f.is_nullable or t.is_callback:
      field_lines.append(f'  final {f.dart_type}? {f.dart_name};')
    else:
      field_lines.append(f'  final {f.dart_type} {f.dart_name};')

  # toNative
  if struct.chain_stype: to_native_lines.append(f'  @override')
  to_native_lines.append(f'  Pointer<bindings.{struct.name}> toNative(Allocator allocator) {{')
  to_native_lines.append(f'    final ptr = allocator<bindings.{struct.name}>();')

  if struct.chain_stype:
    to_native_lines.append(f'    ptr.ref.chain.sTypeAsInt = sType.value;')
    to_native_lines.append(f'    ptr.ref.chain.next = next?.toNative(allocator).cast() ?? nullptr;')

  for f in visible_fields:
    l = []

    # nextInChain handling
    if f.field_name == 'nextInChain':
      l.append(f'ptr.ref.nextInChain = next?.toNative(allocator).cast() ?? nullptr;')

    # Array handling
    elif f.is_array:
      elem = f.array_element

      c_arr_type = ''
      if elem.is_enum or elem.is_flag: c_arr_type = 'UnsignedInt'
      else: c_arr_type = ffi_native_type(elem)

      l.append(f'if ({f.dart_name}.isNotEmpty) {{')
      l.append(f'  final arrayPtr = allocator<{c_arr_type}>({f.dart_name}.length);')
      l.append(f'  for (var i = 0; i < {f.dart_name}.length; i++) {{')
      l.append(f'    arrayPtr[i] = {to_native_expr(elem, f"{f.dart_name}[i]")};')
      l.append(f'  }}')

      if (elem.is_string): l.append(f'  ptr.ref.{f.field_name} = arrayPtr.cast();')
      else: l.append(f'  ptr.ref.{f.field_name} = arrayPtr;')

      l.append(f'  ptr.ref.{f.array_count_field_name} = {f.dart_name}.length;')
      l.append(f'}} else {{')
      l.append(f'  ptr.ref.{f.field_name} = nullptr;')
      l.append(f'  ptr.ref.{f.array_count_field_name} = 0;')
      l.append(f'}}')
      l.append('')
    else:
      t = f.classified

      if t.is_callback:
        # Special handling for callbacks.
        cb = callbacks.get(t.base_name)
        registry_name = f'_{cb.dart_name}Registry'
        repeating = cb.is_repeating
        if len(userdatas) > 0:
          ud, *extras = userdatas
          l.append(f'if ({f.dart_name} != null) {{')

          if repeating:
            l.append(f'  ptr.ref.{f.field_name} = {f.dart_name}!._nativeFunction;')
            l.append(f'  ptr.ref.{ud.field_name} = {f.dart_name}!._userdata;')
          else:
            l.append(f'  ptr.ref.{f.field_name} = {to_native_expr(t, f"{f.dart_name}!")};')
            l.append(f'  ptr.ref.{ud.field_name} = {registry_name}.register({f.dart_name}!);')

          l.append(f'}}')
          l.append(f'else {{')
          l.append(f'  ptr.ref.{f.field_name} = nullptr;')
          l.append(f'  ptr.ref.{ud.field_name} = nullptr;')
          l.append(f'}}')
        else:
          print(f'warning: callback field {f.field_name} in struct {struct.name} has no associated userdata field')
      else:
        suffix = 'AsInt' if t.is_enum else ''
        nullable = f.is_nullable

        if t.is_struct and not t.is_pointer:
          if f.is_nullable:
            l.append(f'if ({f.dart_name} != null) ptr.ref.{f.field_name} = {to_native_expr(t, f"{f.dart_name}!")};')
          else:
            l.append(f'ptr.ref.{f.field_name} = {to_native_expr(t, f"{f.dart_name}")};')
        else:
          l.append(f'ptr.ref.{f.field_name}{suffix} = {to_native_expr(t, f.dart_name, nullable=nullable)};')

    to_native_lines.extend(indent(l, 2))

  if to_native_lines[-1].strip() != '': to_native_lines.append('')

  to_native_lines.append(f'    return ptr;')
  to_native_lines.append(f'  }}')

  # fromNative
  from_native_ctor_args = []
  from_native_lines.append(f'factory {struct.dart_name}.fromNative(bindings.{struct.name} v) {{')
  for idx, f in enumerate(visible_fields):
    t = f.classified
    l = []

    if f.field_name == 'nextInChain':
      from_native_ctor_args.append(f'next: ChainedStruct.fromNative(v.nextInChain)')

    elif f.is_array:
      elem = f.array_element
      arr_var = f'_{f.dart_name}'
      l.append(f'final {arr_var} = <{f.dart_type}>[];')
      l.append(f'if (v.{f.field_name} != nullptr && v.{f.array_count_field_name} > 0) {{')
      l.append(f'  for (var i = 0; i < v.{f.array_count_field_name}; i++) {{')
      l.append(f'    {arr_var}.add({from_native_expr(elem, f"v.{f.field_name}[i]")});')
      l.append(f'  }}')
      l.append(f'}}')
      from_native_ctor_args.append(f'{f.dart_name}: {arr_var}')
    elif t.is_callback:
      from_native_ctor_args.append(f'{f.dart_name}: null')
    else:
      suffix = 'AsInt' if t.is_enum else ''
      nullable = f.is_nullable
      if t.is_struct and not t.is_pointer: nullable = False

      expr = from_native_expr(t, f'v.{f.field_name}{suffix}', nullable=nullable)
      from_native_ctor_args.append(f'{f.dart_name}: {expr}')

    from_native_lines.extend(indent(l))

  from_native_lines.append(f'  return {struct.dart_name}(')
  for arg in from_native_ctor_args: from_native_lines.append(f'    {arg},')
  from_native_lines.append(f'  );')
  from_native_lines.append(f'}}')

  if len(struct.fields) > 0:
    lines.extend(constructor_lines)
    lines.append('')
    lines.extend(field_lines)
    lines.append('')
  else:
    lines.append(f'  {struct.dart_name}();')
    lines.append('')

  lines.extend(to_native_lines)
  lines.append('')
  lines.extend(indent(from_native_lines))

  if struct.chain_stype:
    lines.append('')
    lines.append(f'  @override')

    stype = struct.chain_stype[len('WGPUSType_'):]
    stype = to_lower_camel_case(stype)
    lines.append(f'  SType get sType => .{stype};')

  lines.append('}')
  return lines


def generate_chained_struct_from_native() -> list[str]:
  chain_extensions = [s for s in structs.values() if s.chain_stype]
  lines = [
    f'ChainedStruct? _chainedStructFromNative(Pointer<bindings.WGPUChainedStruct> ptr) {{',
    f'  if (ptr == nullptr) return null;',
    f'  final stype = SType.fromNative(ptr.ref.sType);',
    f'  return switch (stype) {{',
  ]

  for s in chain_extensions:
    if s.name in IGNORED_STRUCTS: continue
    stype_short = s.chain_stype[len('WGPUSType_'):]
    stype_dart_value = to_lower_camel_case(stype_short)

    lines.append(f'    .{stype_dart_value} => {s.dart_name}.fromNative(ptr.cast<bindings.{s.name}>().ref),')
  lines.append(f'    _ => throw ArgumentError(\'Unknown chained struct type: $stype\'),')
  lines.append(f'  }};')
  lines.append(f'}}')

  return lines

########################################################################################################
# Callbacks
########################################################################################################


@dataclass
class WGPUCallbackArg:
  c_name: str
  classified: ClassifiedType


@dataclass
class WGPUCallback:
  cursor: clang.cindex.Cursor
  c_name: str
  dart_name: str
  ret: ClassifiedType
  args: list[WGPUCallbackArg]

  @property
  def spelling(self) -> str: return self.cursor.spelling

  @property
  def is_repeating(self) -> bool: return self.c_name in REPEATING_STRUCT_CALLBACKS


def parse_callback(cursor: clang.cindex.Cursor) -> WGPUCallback:
  c_name = cursor.spelling
  dart_name = to_upper_camel_case(c_name[4:] if c_name.startswith('WGPU') else c_name)
  proto = cursor.underlying_typedef_type.get_pointee()

  ret = classify_type(proto.get_result())
  args = []

  for i, arg_type in enumerate(proto.argument_types()):
    arg_name = f'arg{i}'
    classified = classify_type(arg_type)
    args.append(
      WGPUCallbackArg(
        c_name=arg_name,
        classified=classified,
      )
    )

  return WGPUCallback(cursor, c_name, dart_name, ret, args)


def generate_callback_code(callback: WGPUCallback) -> list[str]:
  lines = []

  trailing = 0
  for arg in reversed(callback.args):
    if arg.classified.category == TypeCategory.VOID_PTR: trailing += 1
    else: break

  if trailing == 0:
    print(f'Warning (generate_callback_code): callback {callback.c_name} has no trailing void* userdata; skipping registry generation')
    return [f'// {callback.c_name}: no trailing userdata']

  visible_args = callback.args[:len(callback.args) - trailing]

  registry_arg_idx = len(callback.args) - trailing
  registry_arg_name = callback.args[registry_arg_idx].c_name

  trampoline_name = '_' + to_lower_camel_case(callback.dart_name) + 'Trampoline'
  registry_name = f'_{callback.dart_name}Registry'

  high_level_args = ', '.join(f'{dart_type_name(arg.classified)} {arg.c_name}' for arg in visible_args)
  native_args = ', '.join(f'{ffi_native_type(arg.classified)} {arg.c_name}' for arg in callback.args)

  lines.append(f'typedef {callback.dart_name} = {dart_type_name(callback.ret)} Function({high_level_args});')
  lines.append(f'typedef {callback.dart_name}Native = {ffi_native_type(callback.ret)} Function({native_args});')

  # Trampoline
  trampoline_args = ', '.join(f'{ffi_dart_type(a.classified)} {a.c_name}' for a in callback.args)
  trampoline_ret = ffi_dart_type(callback.ret)
  lines.append(f'{trampoline_ret} {trampoline_name}({trampoline_args}) {{')
  lines.append(f'  final handler = {registry_name}._lookup({registry_arg_name});')

  null_default = ''
  if callback.ret.category == TypeCategory.VOID:
    lines.append('  if (handler == null) return;')
    null_default = ''
  else:
    if callback.ret.category in (TypeCategory.BOOL, TypeCategory.INT, TypeCategory.ENUM, TypeCategory.FLAG): null_default = '0'
    elif callback.ret.category == TypeCategory.FLOAT: null_default = '0.0'
    else: null_default = 'nullptr'
    lines.append(f'  if (handler == null) return {null_default};')

  # Marshalling
  m_l = []
  for i, a in enumerate(visible_args):
    t = a.classified
    cv = a.c_name
    nullable = t.is_string
    owned = a.c_name in OWNED_CALLBACK_HANDLES.get(callback.c_name, set())
    m_l.append(f'final $arg{i} = {from_native_expr(t, cv, nullable=nullable, opaque_borrow=not owned)};')

  lines.extend(indent(m_l))

  call_args = ', '.join(f'$arg{i}' for i in range(len(visible_args)))

  if callback.ret.category == TypeCategory.VOID:
    lines.append(f'  handler({call_args});')
  else:
    lines.append(f'  final result = handler({call_args});')
    lines.append(f'  return {to_native_expr(callback.ret, "result")};')

  lines.append('}')
  lines.append('')

  exception_arg = ''
  if not callback.ret.is_void:
    exception_arg = f', {null_default}'

  is_listener = callback.ret.is_void

  lines.extend([
    f'class {registry_name} {{',
    f'  static int _nextId = 1;',
    f'  static final _singleShot = <int, {callback.dart_name}>{{}};',
    f'  static final _repeating = <int, {callback.dart_name}>{{}};',
    '',
    f'  static Pointer<Void> register({callback.dart_name} handler) {{',
    f'    final id = _nextId++;',
    f'    _singleShot[id] = handler;',
    f'    return Pointer.fromAddress(id);',
    f'  }}',
    '',
    f'  static void unregister(Pointer<Void> handle) {{',
    f'    final id = handle.address;',
    f'    _singleShot.remove(id);',
    f'    _repeating.remove(id);',
    f'  }}',
    '',
    f'  static {callback.dart_name}? _lookup(Pointer<Void> handle) {{',
    f'    final id = handle.address;',
    f'    final ss = _singleShot.remove(id);',
    f'    if (ss != null) return ss;',
    f'    return _repeating[id];',
    f'  }}',
    '',
  ])

  if is_listener:
    lines.extend([
      f'  static final NativeCallable<{callback.dart_name}Native> _callable = NativeCallable<{callback.dart_name}Native>.listener({trampoline_name});',
      f'  static Pointer<NativeFunction<{callback.dart_name}Native>> get _nativeFunction => _callable.nativeFunction;',
    ])
  else:
    lines.append(f'  static final Pointer<NativeFunction<{callback.dart_name}Native>> _nativeFunction = Pointer.fromFunction<{callback.dart_name}Native>({trampoline_name}{exception_arg});')

  lines.append(f'}}')

  if callback.is_repeating:
    listener_name = f'{callback.dart_name}Listener'
    lines.extend([
      f'',
      f'class {listener_name} {{',
      f'  {listener_name}({callback.dart_name} handler): _id = {registry_name}._nextId++ {{',
      f'    {registry_name}._repeating[_id] = handler;',
      f'  }}',
      f'',
      f'  final int _id;',
      f'  bool _cancelled = false;',
      f'',
      f'  Pointer<NativeFunction<{callback.dart_name}Native>> get _nativeFunction => {registry_name}._nativeFunction;',
      f'  Pointer<Void> get _userdata => Pointer.fromAddress(_id);',
      f'',
      f'  void cancel() {{',
      f'    if (_cancelled) return;',
      f'    _cancelled = true;',
      f'    {registry_name}._repeating.remove(_id);',
      f'  }}',
      f'}}',
    ])

  return lines


##########################################################################################################
# Methods
##########################################################################################################

_METHOD_NAME_SKIP_SUFFIXES = ('AddRef', 'Release')
_STATUS_NAME = 'WGPUStatus'


@dataclass
class WGPUMethodArg:
  c_name: str
  classified: ClassifiedType
  nullable: bool
  array_count_arg_name: Optional[str] = None
  array_element: Optional[ClassifiedType] = None
  pointee_is_const: bool = False

  @property
  def is_array(self) -> bool: return self.array_element is not None


@dataclass
class WGPUMethod:
  cursor: clang.cindex.Cursor
  c_name: str
  dart_name: str
  receiver: ClassifiedType | None
  args: list[WGPUMethodArg]
  hidden_arg_names: set[str]
  ret: ClassifiedType
  ret_nullable: bool

  @property
  def spelling(self) -> str: return self.cursor.spelling


def _split_function_name(c_name: str) -> tuple[Optional[str], str]:
  if not c_name.startswith('wgpu'): return None, c_name
  rest = c_name[4:]

  candidates = sorted(opaque_types.keys(), key=len, reverse=True)
  for opaque in candidates:
    name = opaque[4:] if opaque.startswith('WGPU') else opaque
    if rest.startswith(name): return opaque, rest[len(name):]

  return None, rest


def parse_method(cursor: clang.cindex.Cursor) -> Optional[WGPUMethod]:
  c_name = cursor.spelling
  if any(c_name.endswith(suffix) for suffix in _METHOD_NAME_SKIP_SUFFIXES): return None
  if c_name in IGNORED_METHODS: return None

  opaque_name, method_part = _split_function_name(c_name)
  if not method_part: return None

  dart_name = ''
  if opaque_name is not None:
    receiver_short = opaque_name[4:] if opaque_name.startswith('WGPU') else opaque_name
    dart_name = f'_{to_lower_camel_case(receiver_short)}{method_part}'
  else:
    dart_name = f'_{to_lower_camel_case(method_part)}'

  raw_arg_cursors = list(cursor.get_arguments())
  pointer_to_count: dict[str, str] = {}

  for ac in raw_arg_cursors:
    if ac.type.kind != TypeKind.POINTER: continue
    name = ac.spelling
    candidates = []

    if name.endswith('ies'): candidates.append(name[:-3] + 'yCount')
    if name.endswith('s'): candidates.append(name[:-1] + 'Count')
    candidates.append(name + 'Count')

    for cand in candidates:
      if any(other.spelling == cand for other in raw_arg_cursors):
        pointer_to_count[name] = cand
        break

  count_arg_names = set(pointer_to_count.values())

  args = []
  for arg_cursor in raw_arg_cursors:
    classified = classify_type(arg_cursor.type)
    name = arg_cursor.spelling

    array_count_arg_name = pointer_to_count.get(name)
    is_array = array_count_arg_name is not None
    array_element = classify_type(arg_cursor.type.get_pointee()) if is_array else None

    pointee_is_const = False
    if arg_cursor.type.kind == TypeKind.POINTER:
      pointee_is_const = arg_cursor.type.get_pointee().is_const_qualified()

    args.append(
      WGPUMethodArg(
        name,
        classified,
        _has_wgpu_nullable(arg_cursor),
        array_count_arg_name,
        array_element,
        pointee_is_const,
      )
    )

  ret = classify_type(cursor.result_type)
  ret_nullable = _has_wgpu_nullable(cursor)

  receiver = args[0].classified if (args and opaque_name is not None and args[0].classified.is_opaque) else None
  return WGPUMethod(
    cursor,
    c_name,
    dart_name,
    receiver,
    args,
    count_arg_names,
    ret,
    ret_nullable,
  )


class MethodShape(Enum):
  ASYNC = auto()  # takes callback at the end
  STATUS_OUTPARAM = auto()  # return status
  VOID_OUTPARAM = auto()  # returns void but has an outparam at the end
  SYNC = auto()


def _classify_method_shape(m: WGPUMethod) -> MethodShape:
  if m.ret.is_struct and m.ret.base_name == 'WGPUFuture':
    if m.args:
      last_t = m.args[-1].classified
      if last_t.is_struct and last_t.base_name.endswith('CallbackInfo'): return MethodShape.ASYNC

  has_outparam = (
    m.args and
    m.args[-1].classified.is_struct and
    m.args[-1].classified.is_pointer and
    not m.args[-1].pointee_is_const
  )

  if has_outparam:
    if m.ret.is_enum and m.ret.base_name == _STATUS_NAME: return MethodShape.STATUS_OUTPARAM
    if m.ret.is_void: return MethodShape.VOID_OUTPARAM

  return MethodShape.SYNC


def _callback_info_listener_type(struct_name: str) -> str | None:
  s = structs.get(struct_name)
  if s is None: return None

  cb_field = next((f for f in s.fields if f.classified.is_callback), None)
  if cb_field is None: return None

  cb = callbacks.get(cb_field.classified.base_name)
  if cb is None: return None

  return f'{cb.dart_name}Listener'


def _is_callback_info_arg(arg: WGPUMethodArg) -> bool:
  t = arg.classified
  return t.is_struct and t.base_name.endswith('CallbackInfo')


def _to_native_arg(arg: WGPUMethodArg) -> str:
  if _is_callback_info_arg(arg):
    listener_type = _callback_info_listener_type(arg.classified.base_name)
    if listener_type is not None:
      info_struct = structs[arg.classified.base_name]
      info_dart_name = structs[arg.classified.base_name].dart_name
      has_mode = any(f.field_name == 'mode' for f in info_struct.fields)

      if has_mode: return f'{info_dart_name}(mode: .allowSpontaneous, callback: {arg.c_name}).toNative(allocator).ref'
      return f'{info_dart_name}(callback: {arg.c_name}).toNative(allocator).ref'

  return to_native_expr(arg.classified, arg.c_name, nullable=arg.nullable, enum_as_int=False)


def _high_level_arg_type(arg: WGPUMethodArg) -> str:
  if arg.is_array: return f'List<{dart_type_name(arg.array_element)}>'

  if _is_callback_info_arg(arg):
    listener_type = _callback_info_listener_type(arg.classified.base_name)
    if listener_type is not None:
      return f'{listener_type}?' if arg.nullable else listener_type

  t = arg.classified
  base = dart_type_name(t)
  return f'{base}?' if arg.nullable else base


def _generate_sync_method(m: WGPUMethod) -> list[str]:
  visible_args = [a for a in m.args if a.c_name not in m.hidden_arg_names]
  sig_args = ', '.join(f'{_high_level_arg_type(arg)} {arg.c_name}' for arg in visible_args)
  ret_type = dart_type_name(m.ret)
  if m.ret_nullable: ret_type += '?'
  if m.ret.is_void: ret_type = 'void'

  lines = [f'{ret_type} {m.dart_name}({sig_args}) => ffi.using((allocator) {{']

  arg_expr: dict[str, str] = {}
  for a in m.args:
    if not a.is_array: continue
    elem = a.array_element
    elem_native = ffi_native_type(elem)
    ptr_var = f'_{a.c_name}Ptr'
    lines.append(f'  final {ptr_var} = allocator<{elem_native}>({a.c_name}.length);')
    lines.append(f'  for (var i = 0; i < {a.c_name}.length; i++) {{')
    lines.append(f'    {ptr_var}[i] = {to_native_expr(elem, f"{a.c_name}[i]")};')
    lines.append(f'  }}')
    arg_expr[a.c_name] = ptr_var
    if a.array_count_arg_name is not None:
      arg_expr[a.array_count_arg_name] = f'{a.c_name}.length'

  call_arg_strs = []
  for a in m.args:
    if a.c_name in arg_expr: continue
    arg_expr[a.c_name] = _to_native_arg(a)

  call_args = ', '.join(arg_expr[a.c_name] for a in m.args)
  call = f'bindings.{m.c_name}({call_args})'

  if m.ret.is_void:
    lines.append(f'  {call};')
  else:
    lines.append(f'  final result = {call};')
    expr = from_native_expr(m.ret, "result", nullable=m.ret_nullable, enum_as_int=False)
    lines.append(f'  return {expr};')

  lines.append('});')
  return lines


def _generate_status_outparam_method(m: WGPUMethod, with_status: bool) -> list[str]:
  out = m.args[-1]
  in_args = [a for a in m.args[:-1] if a.c_name not in m.hidden_arg_names]
  out_struct_name = out.classified.base_name
  out_dart_name = structs[out_struct_name].dart_name

  sig_args = ', '.join(f'{_high_level_arg_type(arg)} {arg.c_name}' for arg in in_args)
  lines = [f'{out_dart_name} {m.dart_name}({sig_args}) => ffi.using((allocator) {{']
  lines.append(f'  final outPtr = allocator<bindings.{out_struct_name}>();')

  arg_expr: dict[str, str] = {}
  for a in m.args[:-1]:
    if a.is_array: raise NotImplementedError('status outparam methods with array arguments are not supported')
    arg_expr[a.c_name] = _to_native_arg(a)

  arg_expr[out.c_name] = 'outPtr'
  call_args = ', '.join(arg_expr[a.c_name] for a in m.args)
  call = f'bindings.{m.c_name}({call_args})'

  if with_status:
    lines.append(f'  final status = {call};')
    lines.append(f'  if (status != .WGPUStatus_Success) throw StateError(\'{m.c_name} failed: $status\');')
  else:
    lines.append(f'  {call};')

  out_type = ClassifiedType(TypeCategory.STRUCT, out_struct_name, out_struct_name, False)
  lines.append(f'  final result = {from_native_expr(out_type, "outPtr.ref")};')

  free_members_fn = f'wgpu{out_struct_name[4:]}FreeMembers'
  if free_members_fn in method_names:
    lines.append(f'  bindings.{free_members_fn}(outPtr.ref);')
  lines.append(f'  return result;')
  lines.append('});')

  return lines


def _generate_async_method(m: WGPUMethod) -> list[str]:
  callback_info_arg = m.args[-1]
  in_args = [a for a in m.args[:-1] if a.c_name not in m.hidden_arg_names]
  for a in m.args:
    if a.is_array: raise NotImplementedError('async methods with array arguments are not supported')

  callback_info_struct_name = callback_info_arg.classified.base_name
  cb_info_struct = structs[callback_info_struct_name]
  cb_field = next((f for f in cb_info_struct.fields if f.classified.is_callback), None)
  if cb_field is None: raise ValueError(f'async method {m.c_name} has callback info struct {callback_info_struct_name} with no callback field')

  cb = callbacks[cb_field.classified.base_name]

  result_arg = None
  status_arg = None
  for a in cb.args:
    t = a.classified
    if t.is_enum and 'Status' in t.base_name: status_arg = a
    elif t.is_opaque or (t.is_struct and t.base_name != 'WGPUStringView') or t.is_enum or t.is_flag:
      if result_arg is None: result_arg = a

  if status_arg is None: raise ValueError(f'async method {m.c_name} has callback with no status argument')

  sig_args = ', '.join(f'{_high_level_arg_type(arg)} {arg.c_name}' for arg in in_args)
  future_type = 'void'
  if result_arg is not None: future_type = dart_type_name(result_arg.classified)

  lines = [f'Future<{future_type}> {m.dart_name}({sig_args}) {{']
  lines.append(f'  final completer = Completer<{future_type}>();')
  lines.append(f'  ffi.using((allocator) {{')

  lines.append(f'    final callbackInfo = {cb_info_struct.dart_name}(')
  lines.append(f'      mode: .allowSpontaneous,')

  cb_visible = []
  trailing_userdatas = 0
  for arg in reversed(cb.args):
    if arg.classified.is_void_ptr: trailing_userdatas += 1
    else: break

  cb_visible = cb.args[:len(cb.args) - trailing_userdatas]
  visible_arg_names = ', '.join(a.c_name for a in cb_visible)
  lines.append(f'      callback: ({visible_arg_names}) {{')
  lines.append(f'        if ({status_arg.c_name} == {dart_type_name(status_arg.classified)}.success) {{')
  if result_arg is not None:
    lines.append(f'          completer.complete({result_arg.c_name});')
  else:
    lines.append(f'          completer.complete();')
  lines.append(f'        }} else {{')

  message_arg = next((a for a in cb.args if a.classified.base_name == 'WGPUStringView'), None)
  if message_arg is not None:
    lines.append(f'          completer.completeError(StateError(\'{m.c_name} failed (${status_arg.c_name}): ${message_arg.c_name}\'));')
  else:
    lines.append(f'          completer.completeError(StateError(\'{m.c_name} failed (${status_arg.c_name})\'));')
  lines.append(f'        }}')
  lines.append(f'      }},')
  lines.append(f'    );')

  call_args = [_to_native_arg(a) for a in m.args[:-1] if a.c_name not in m.hidden_arg_names]
  call_args.append('callbackInfo.toNative(allocator).ref')

  lines.append(f'    bindings.{m.c_name}({", ".join(call_args)});')
  lines.append(f'  }});')
  lines.append(f'  return completer.future;')
  lines.append(f'}}')
  return lines


def generate_method_code(method: WGPUMethod) -> list[str]:
  shape = _classify_method_shape(method)

  if shape == MethodShape.SYNC: return _generate_sync_method(method)
  if shape == MethodShape.STATUS_OUTPARAM: return _generate_status_outparam_method(method, with_status=True)
  if shape == MethodShape.VOID_OUTPARAM: return _generate_status_outparam_method(method, with_status=False)
  if shape == MethodShape.ASYNC: return _generate_async_method(method)
  return []


##########################################################################################################
# Clang
##########################################################################################################


# Returns the path to the macOS SDK.
def get_sdk_path() -> str:
  return subprocess.check_output(['xcrun', '--show-sdk-path']).decode().strip()


# Returns a list of system include directories used by clang on this system.
def get_system_include_dirs() -> list[pathlib.Path]:
  output = subprocess.check_output(['clang++', '-std=c++20', '-stdlib=libc++', '-E', '-x', 'c++', '-', '-v'], input=b'', stderr=subprocess.STDOUT).decode()
  include_dirs = []
  capture = False
  for line in output.splitlines():
    if line.strip() == '#include <...> search starts here:':
      capture = True
      continue
    if line.strip() == 'End of search list.':
      break
    if capture:
      dir_path = line.strip()
      include_dirs.append(pathlib.Path(dir_path))

  return include_dirs


# Parses a translation unit at the given file path (with provided include dirs).
def parse_translation_unit(file_path: pathlib.Path, include_dirs: list[pathlib.Path]) -> clang.cindex.TranslationUnit:
  index = clang.cindex.Index.create()
  sdk_path = get_sdk_path()
  tu = index.parse(
    file_path,
    args=[
      *(f'-I{inc}' for inc in include_dirs),
      '-std=c++20',
      '-x',
      'c++',
      '-stdlib=libc++',
      *(f'-isystem{inc}' for inc in get_system_include_dirs()),
      f'-isysroot{sdk_path}',
      '-DWGPU_NULLABLE=__attribute__((annotate("wgpu_nullable")))',
    ],
    options=clang.cindex.TranslationUnit.PARSE_SKIP_FUNCTION_BODIES,
  )

  # print diagnostics
  for diag in tu.diagnostics:
    if diag.severity >= clang.cindex.Diagnostic.Warning:
      print(d.spelling, d.location)

  return tu


##########################################################################################################
# Main
##########################################################################################################


def main():
  # Configures libclang. Currently only set up for macOS with Homebrew LLVM.
  clang.cindex.Config.set_library_file('/opt/homebrew/opt/llvm/lib/libclang.dylib')

  index = clang.cindex.Index.create()
  header_path = root / 'include' / 'dawn' / 'webgpu.h'

  system_include_dirs = get_system_include_dirs()
  tu = parse_translation_unit(header_path, include_dirs=[root / 'include'] + system_include_dirs)

  struct_cursors = []
  callback_cursors = []
  method_cursors = []

  for node in tu.cursor.walk_preorder():
    if not node.spelling.lower().startswith('wgpu'): continue

    # Opaque types, flag typedefs, and callbacks
    if node.kind == CursorKind.TYPEDEF_DECL:
      underlying_type = node.underlying_typedef_type

      # Opaque type or callback
      if underlying_type.kind == clang.cindex.TypeKind.POINTER:
        pointee = underlying_type.get_pointee()

        if pointee.kind == clang.cindex.TypeKind.FUNCTIONPROTO and not node.spelling.startswith('WGPUProc'):
          callback_cursors.append(node)
          callback_names.add(node.spelling)

        elif pointee.spelling.endswith('Impl'):
          opaque_type = parse_opaque_type(node)
          opaque_types[opaque_type.spelling] = opaque_type

      if underlying_type.spelling == 'WGPUFlags':
        flag = parse_flag_typedef(node)
        flags[flag.spelling] = flag

    # Enums
    if node.kind == CursorKind.ENUM_DECL:
      enum = parse_enum(node)
      enums[enum.spelling] = enum

    # Flag values
    if node.kind == CursorKind.VAR_DECL:
      parse_append_flag_value(node)

    # Structs
    if node.kind == CursorKind.STRUCT_DECL and node.is_definition():
      struct_cursors.append(node)

    # Methods
    if node.kind == CursorKind.FUNCTION_DECL and node.spelling.startswith('wgpu'):
      method_names.add(node.spelling)
      method_cursors.append(node)

  # Parse structs
  for struct_cursor in struct_cursors:
    struct = parse_struct(struct_cursor)
    structs[struct.spelling] = struct

  # Parse callbacks
  for callback_cursor in callback_cursors:
    callback = parse_callback(callback_cursor)
    callbacks[callback.spelling] = callback

  # Parse methods
  for method_cursor in method_cursors:
    method = parse_method(method_cursor)
    if method is not None: methods[method.spelling] = method

  header = [
    '// GENERATED CODE - DO NOT MODIFY BY HAND',
    '//',
    '// Generated by tool/webgpu_gen.py',
    '//',
    '// ignore_for_file: unused_element, unused_field, unreachable_switch_case',
    '',
    'part of \'../src.dart\';',
    '',
  ]

  opaque_types_code = []
  for opaque_type in opaque_types.values():
    code = generate_opaque_type_code(opaque_type)
    opaque_types_code.extend(code)
    opaque_types_code.append('')

  enums_code = []
  for enum in enums.values():
    code = generate_enum_code(enum)
    enums_code.extend(code)
    enums_code.append('')

  flags_code = []
  for flag in flags.values():
    code = generate_flag_code(flag)
    flags_code.extend(code)
    flags_code.append('')

  structs_code = []
  for struct in structs.values():
    if struct.name in IGNORED_STRUCTS: continue
    code = generate_struct_code(struct)
    structs_code.extend(code)
    structs_code.append('')

  structs_code.extend(generate_chained_struct_from_native())
  structs_code.append('')

  callbacks_code = []
  for callback in callbacks.values():
    code = generate_callback_code(callback)
    callbacks_code.extend(code)
    callbacks_code.append('')

  methods_code = []
  for method in methods.values():
    code = generate_method_code(method)
    methods_code.extend(code)
    methods_code.append('')

  with open(output_types, 'w') as f: f.write('\n'.join(header + opaque_types_code))
  with open(output_enums, 'w') as f: f.write('\n'.join(header + enums_code))
  with open(output_flags, 'w') as f: f.write('\n'.join(header + flags_code))
  with open(output_structs, 'w') as f: f.write('\n'.join(header + structs_code))
  with open(output_callbacks, 'w') as f: f.write('\n'.join(header + callbacks_code))
  with open(output_methods, 'w') as f: f.write('\n'.join(header + methods_code))


if __name__ == '__main__': main()
