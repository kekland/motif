#!/usr/bin/env python3

from _common import ROOT, to_upper_camel_case, to_lower_camel_case, indent

import yaml
from dataclasses import dataclass, field
from enum import Enum, auto
from typing import Optional, Any

SPEC_PATH = ROOT / 'build' / 'webgpu.yml'
OUT_PATH = ROOT / 'lib' / 'src' / 'webgpu' / 'webgpu.g.dart'
UTILS_TEMPLATE = ROOT / 'tool' / 'utils.dart.template'

# region Globals

PREFIX = 'WGPU'
PREFIX_L = 'wgpu'

CONSTANTS: dict[str, 'WGPUConstant'] = {}
ENUMS: dict[str, 'WGPUEnum'] = {}
FLAGS: dict[str, 'WGPUFlag'] = {}
GLOBAL_FUNCTIONS: dict[str, 'WGPUFunction'] = {}
STRUCTS: dict[str, 'WGPUStruct'] = {}
OBJECTS: dict[str, 'WGPUObject'] = {}
CALLBACKS: dict[str, 'WGPUCallback'] = {}
EXTERNAL: bool = False

SKIP_OBJECT_CLASS_GEN: set[str] = {
  'instance'
}

STRUCT_DEFAULTS_OVERRIDES: dict[str, Any] = {
  'bind_group_layout_entry.binding_array_size': 0,
  'bind_group_entry.offset': 0,
}

# endregion

# region Utilities

def parse_doc(doc: Optional[str]) -> list[str]:
  if not doc: return []
  _doc = doc.strip()
  if _doc == 'TODO': return []

  _lines: list[str] = []

  for line in _doc.splitlines():
    if line.strip() == 'TODO': continue
    _lines.append(line.strip())

  while _lines and not _lines[0]: _lines.pop(0)
  while _lines and not _lines[-1]: _lines.pop()

  return _lines


def generate_doc_code(doc: list[str], indent: int = 0) -> list[str]:
  if not doc: return []
  indent_str = '  ' * indent
  lines = []
  for line in doc: lines.append(f'{indent_str}/// {line}')
  return lines


def _clean_dart_name(name: str):
  if name in ('null', 'true', 'false'): return f'{name}_'

  DIGITS = {'0': 'zero', '1': 'one', '2': 'two', '3': 'three', '4': 'four', '5': 'five', '6': 'six', '7': 'seven', '8': 'eight', '9': 'nine'}
  if name[0].isdigit(): return DIGITS[name[0]] + '_' + name[1:]

  return name


def to_dart_top_level_name(name: str) -> str:
  cleaned = _clean_dart_name(name)
  return _c_to_pascal_case(cleaned)


def to_dart_member_name(name: str) -> str:
  if name.startswith('_'): return name
  cleaned = _clean_dart_name(name)
  return _c_to_camel_case(cleaned)


def _c_capitalize_segment(seg: str) -> str:
  if not seg: return '_'
  if seg[0].isupper() or seg[0].isdigit(): return seg
  return seg[0].upper() + seg[1:]


def _c_to_pascal_case(s: str) -> str:
  return ''.join(_c_capitalize_segment(seg) for seg in s.split('_'))


def _c_to_camel_case(s: str) -> str:
  parts = s.split('_')
  if not parts: return s

  first = parts[0].lower() if parts[0] and parts[0][0].islower() else parts[0]
  rest = ''.join(_c_capitalize_segment(seg) for seg in parts[1:])
  return first + rest


def _array_count_field(s: str) -> str:
  if s.endswith('ies'): return f'{s[:-3]}yCount'
  if s.endswith('s'): return f'{s[:-1]}Count'
  return f'{s}Count'


# endregion

# region Type

class WGPUTypeKind(Enum):
  UNKNOWN = auto()
  VOID = auto()

  UINT8 = auto()
  UINT16 = auto()
  UINT32 = auto()
  UINT64 = auto()
  INT8 = auto()
  INT16 = auto()
  INT32 = auto()
  INT64 = auto()
  USIZE = auto()
  FLOAT32 = auto()
  FLOAT32_NULLABLE = auto()
  FLOAT64 = auto()
  FLOAT64_NULLABLE = auto()
  FLOAT64_SUPERTYPE = auto()
  BOOL = auto()

  STR_OUT = auto()
  STR_WITH_DEFAULT_EMPTY = auto()
  STR_NULLABLE = auto()

  ENUM = auto()
  FLAG = auto()
  STRUCT = auto()
  OBJECT = auto()
  CALLBACK = auto()

  ARRAY = auto()


_INT_TYPES = (WGPUTypeKind.UINT8, WGPUTypeKind.UINT16, WGPUTypeKind.UINT32, WGPUTypeKind.UINT64, WGPUTypeKind.INT8, WGPUTypeKind.INT16, WGPUTypeKind.INT32, WGPUTypeKind.INT64, WGPUTypeKind.USIZE)
_FLOAT_TYPES = (WGPUTypeKind.FLOAT32, WGPUTypeKind.FLOAT64, WGPUTypeKind.FLOAT64_SUPERTYPE)
_NULLABLE_FLOAT_TYPES = (WGPUTypeKind.FLOAT32_NULLABLE, WGPUTypeKind.FLOAT64_NULLABLE)
_STR_TYPES = (WGPUTypeKind.STR_OUT, WGPUTypeKind.STR_WITH_DEFAULT_EMPTY, WGPUTypeKind.STR_NULLABLE)


class WGPUPointerKind(Enum):
  MUTABLE = auto()
  IMMUTABLE = auto()


def parse_pointer_kind(spec: Optional[str]) -> Optional[WGPUPointerKind]:
  if not spec: return None
  if spec == 'mutable': return WGPUPointerKind.MUTABLE
  if spec == 'immutable': return WGPUPointerKind.IMMUTABLE
  raise ValueError(f'invalid pointer kind spec "{spec}"')


@dataclass
class WGPUType:
  kind: WGPUTypeKind
  name: Optional[str] = None
  array_inner: Optional['WGPUType'] = None

  @property
  def is_primitive(self) -> bool:
    return self.is_void or self.is_int or self.is_float or self.is_nullable_float or self.is_bool or self.is_str

  @property
  def is_void(self) -> bool: return self.kind == WGPUTypeKind.VOID

  @property
  def is_int(self) -> bool: return self.kind in _INT_TYPES

  @property
  def is_float(self) -> bool: return self.kind in _FLOAT_TYPES

  @property
  def is_nullable_float(self) -> bool: return self.kind in _NULLABLE_FLOAT_TYPES

  @property
  def is_bool(self) -> bool: return self.kind == WGPUTypeKind.BOOL

  @property
  def is_str(self) -> bool: return self.kind in _STR_TYPES

  @property
  def is_enum(self) -> bool: return self.kind == WGPUTypeKind.ENUM

  @property
  def is_flag(self) -> bool: return self.kind == WGPUTypeKind.FLAG

  @property
  def is_struct(self) -> bool: return self.kind == WGPUTypeKind.STRUCT

  @property
  def is_object(self) -> bool: return self.kind == WGPUTypeKind.OBJECT

  @property
  def is_callback(self) -> bool: return self.kind == WGPUTypeKind.CALLBACK

  @property
  def is_array(self) -> bool: return self.kind == WGPUTypeKind.ARRAY

  @property
  def is_future(self) -> bool: return self.is_struct and self.struct_def.name == 'future'

  @property
  def enum_def(self) -> 'WGPUEnum': return ENUMS[self.name]

  @property
  def flag_def(self) -> 'WGPUFlag': return FLAGS[self.name]

  @property
  def struct_def(self) -> 'WGPUStruct': return STRUCTS[self.name]

  @property
  def object_def(self) -> 'WGPUObject': return OBJECTS[self.name]

  @property
  def callback_def(self) -> 'WGPUCallback': return CALLBACKS[self.name]

  def dart_type(self, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, force_nonnull: Optional[bool] = None) -> str:
    return type_to_dart_type(self, pointer, optional, force_nonnull)

  def c_type(self, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, enum_as_int: bool = False) -> str:
    return type_to_c_type(self, pointer, optional, enum_as_int=enum_as_int)

  def binding_type(self, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None) -> str:
    return type_to_binding_type(self, pointer, optional)

  def to_native(self, expr: str, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, enum_as_int: bool = True, _force_unopt: Optional[bool] = None) -> str:
    return type_to_native(expr, self, pointer, optional, enum_as_int=enum_as_int, _force_unopt=_force_unopt)

  def from_native(self, expr: str, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, passed_with_ownership: Optional[bool] = None, enum_as_int: bool = False) -> str:
    return type_from_native(expr, self, pointer, optional, passed_with_ownership, enum_as_int=enum_as_int)

  def set_native(self, dest: str, expr: str, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, enum_as_int=False, _force_unopt: Optional[bool] = None, non_null_promotion_needed: bool = True) -> str:
    return type_set_native(dest, expr, self, pointer, optional, enum_as_int=enum_as_int, _force_unopt=_force_unopt, non_null_promotion_needed=non_null_promotion_needed)

  def set_dart(self, dest: str, expr: str, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, passed_with_ownership: Optional[bool] = None) -> str:
    return type_set_dart(dest, expr, self, pointer, optional, passed_with_ownership)

  def zero_value(self, pointer: Optional[WGPUPointerKind] = None) -> str:
    return type_zero_value(self, pointer)


def type_to_dart_type(type: WGPUType, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, force_nonnull: Optional[bool] = None) -> str:
  _type = None
  kind = type.kind

  if pointer:
    if kind == WGPUTypeKind.VOID: _type = 'ffi.Pointer<ffi.Void>'
    if kind == WGPUTypeKind.INT8: _type = 'Int8List'
    if kind == WGPUTypeKind.UINT8: _type = 'Uint8List'
    if kind == WGPUTypeKind.INT16: _type = 'Int16List'
    if kind == WGPUTypeKind.UINT16: _type = 'Uint16List'
    if kind == WGPUTypeKind.INT32: _type = 'Int32List'
    if kind == WGPUTypeKind.UINT32: _type = 'Uint32List'
    if kind == WGPUTypeKind.INT64: _type = 'Int64List'
    if kind == WGPUTypeKind.UINT64: _type = 'Uint64List'
    if kind == WGPUTypeKind.USIZE: _type = 'Uint64List'
    if kind == WGPUTypeKind.FLOAT32: _type = 'Float32List'
    if kind == WGPUTypeKind.FLOAT32_NULLABLE: _type = 'Float32List'
    if kind == WGPUTypeKind.FLOAT64: _type = 'Float64List'
    if kind == WGPUTypeKind.FLOAT64_NULLABLE: _type = 'Float64List'
    if kind == WGPUTypeKind.FLOAT64_SUPERTYPE: _type = 'Float64List'

    if optional: _type = f'{_type}?'
  else:
    if kind == WGPUTypeKind.VOID: _type = 'void'
    if kind in _INT_TYPES: _type = 'int'
    if kind in _FLOAT_TYPES: _type = 'double'
    if kind in _NULLABLE_FLOAT_TYPES: _type = 'double?'
    if kind == WGPUTypeKind.BOOL: _type = 'bool'
    if kind == WGPUTypeKind.STR_OUT: _type = 'String'
    if kind == WGPUTypeKind.STR_WITH_DEFAULT_EMPTY: _type = 'String'
    if kind == WGPUTypeKind.STR_NULLABLE: _type = 'String?'

    if not force_nonnull and pointer != None: _type = f'ffi.Pointer<{_type}>?'

  if kind == WGPUTypeKind.ENUM: _type = type.enum_def.dart_name
  if kind == WGPUTypeKind.FLAG: _type = type.flag_def.dart_name
  if kind == WGPUTypeKind.STRUCT: _type = type.struct_def.dart_name
  if kind == WGPUTypeKind.OBJECT: _type = type.object_def.dart_name
  if kind == WGPUTypeKind.CALLBACK:
    callback = type.callback_def
    if callback.is_listener: _type = callback.listener_name
    else: _type = callback.dart_name
    _type = f'{_type}?'

  if kind == WGPUTypeKind.ARRAY:
    inner_dart_type = type_to_dart_type(type.array_inner)
    _type = f'List<{inner_dart_type}>'

  if _type is None:
    print(f'warning (type_to_dart_type): unknown type kind: {type.kind}')
    _type = 'dynamic'

  if optional and not _type.endswith('?'): _type += '?'

  return _type


def type_to_c_type(type: WGPUType, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, enum_as_int: bool = False) -> str:
  _type = None
  kind = type.kind

  if kind == WGPUTypeKind.VOID: _type = 'ffi.Void'
  if kind == WGPUTypeKind.UINT8: _type = 'ffi.Uint8'
  if kind == WGPUTypeKind.UINT16: _type = 'ffi.Uint16'
  if kind == WGPUTypeKind.UINT32: _type = 'ffi.Uint32'
  if kind == WGPUTypeKind.UINT64: _type = 'ffi.Uint64'
  if kind == WGPUTypeKind.INT8: _type = 'ffi.Int8'
  if kind == WGPUTypeKind.INT16: _type = 'ffi.Int16'
  if kind == WGPUTypeKind.INT32: _type = 'ffi.Int32'
  if kind == WGPUTypeKind.INT64: _type = 'ffi.Int64'
  if kind == WGPUTypeKind.USIZE: _type = 'ffi.Size'
  if kind == WGPUTypeKind.FLOAT32: _type = 'ffi.Float'
  if kind == WGPUTypeKind.FLOAT32_NULLABLE: _type = 'ffi.Float'
  if kind == WGPUTypeKind.FLOAT64: _type = 'ffi.Double'
  if kind == WGPUTypeKind.FLOAT64_NULLABLE: _type = 'ffi.Double'
  if kind == WGPUTypeKind.FLOAT64_SUPERTYPE: _type = 'ffi.Double'
  if kind == WGPUTypeKind.BOOL: _type = 'ffi.Bool'
  if kind == WGPUTypeKind.STR_OUT: _type = 'bindings.WGPUStringView'
  if kind == WGPUTypeKind.STR_WITH_DEFAULT_EMPTY: _type = 'bindings.WGPUStringView'
  if kind == WGPUTypeKind.STR_NULLABLE: _type = 'bindings.WGPUStringView'

  if kind == WGPUTypeKind.ENUM:
    if enum_as_int: _type = 'int'
    else: _type = type.enum_def.c_name
  if kind == WGPUTypeKind.FLAG: _type = type.flag_def.c_name
  if kind == WGPUTypeKind.STRUCT: _type = f'{type.struct_def.c_name}'
  if kind == WGPUTypeKind.OBJECT: _type = f'{type.object_def.c_name}'
  if kind == WGPUTypeKind.CALLBACK: _type = type.callback_def.name

  if kind == WGPUTypeKind.ARRAY:
    inner_c_type = type_to_c_type(type.array_inner)
    _type = f'ffi.Pointer<{inner_c_type}>'

  if _type is None:
    print(f'warning (type_to_c_type): unknown type kind: {type.kind}')
    _type = 'ffi.Void'

  if pointer != None: _type = f'ffi.Pointer<{_type}>'
  if optional: _type = f'ffi.Pointer<{_type}>'

  return _type


def type_to_binding_type(type: WGPUType, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None) -> str:
  _type = None
  kind = type.kind

  if kind == WGPUTypeKind.VOID: _type = 'ffi.Void'

  if not pointer:
    if type.is_int: _type = 'int'
    if type.is_float: _type = 'double'
  else:
    if type.is_int or type.is_float: _type = type_to_c_type(type, None, None)

  if type.is_str: _type = 'bindings.WGPUStringView'

  if kind == WGPUTypeKind.ENUM: _type = type.enum_def.c_name
  if kind == WGPUTypeKind.FLAG: _type = type.flag_def.c_name
  if kind == WGPUTypeKind.STRUCT: _type = f'{type.struct_def.c_name}'
  if kind == WGPUTypeKind.OBJECT: _type = f'{type.object_def.c_name}'
  if kind == WGPUTypeKind.CALLBACK: _type = type.callback_def.name

  if kind == WGPUTypeKind.ARRAY:
    inner_c_type = type_to_c_type(type.array_inner)
    return f'ffi.Pointer<{inner_c_type}>'

  if _type is None:
    print(f'warning (type_to_binding_type): unknown type kind: {type.kind}')
    _type = 'ffi.Void'

  if pointer != None: _type = f'ffi.Pointer<{_type}>'
  return _type


def type_zero_value(type: WGPUType, pointer: Optional[WGPUPointerKind] = None) -> str:
  kind = type.kind

  if type.is_primitive and pointer: return 'null'

  if kind == WGPUTypeKind.ARRAY: return 'const []'
  if kind == WGPUTypeKind.VOID: return 'null'
  if kind in _INT_TYPES: return '0'
  if kind in _FLOAT_TYPES: return '0.0'
  if kind in _NULLABLE_FLOAT_TYPES: return 'null'
  if kind == WGPUTypeKind.BOOL: return 'false'
  if kind == WGPUTypeKind.STR_NULLABLE: return 'null'
  if kind == WGPUTypeKind.STR_OUT: return '\'\''
  if kind == WGPUTypeKind.STR_WITH_DEFAULT_EMPTY: return '\'\''

  if kind == WGPUTypeKind.ENUM:
    entries = type.enum_def.entries
    zero_entry = next((e for e in entries if e.value == 0), None)
    if zero_entry: return f'.{zero_entry.dart_name}'
    else: raise ValueError(f'enum {type.enum_def.name} has no zero value entry')

  if kind == WGPUTypeKind.FLAG: return '.new(0)'
  if kind == WGPUTypeKind.STRUCT: return '._zero'
  if kind == WGPUTypeKind.OBJECT: return 'null'
  if kind == WGPUTypeKind.CALLBACK: return 'null'

  raise ValueError(f'no zero value for type kind {kind}')


def type_to_native(expr: str, type: WGPUType, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, _force_unopt: Optional[bool] = None, enum_as_int: bool = True) -> str:
  kind = type.kind

  if not pointer:
    if kind in _NULLABLE_FLOAT_TYPES: return f'{expr} ?? .nan'
    if type.is_int or type.is_float: return expr
    if type.is_bool: return f'{expr} ? 1 : 0'

  if type.is_str:
    if kind == WGPUTypeKind.STR_NULLABLE:
      if _force_unopt: return f'{expr}.toStringView(allocator)'
      return f'{expr} != null ? {expr}!.toStringView(allocator) : null'
    return f'{expr}.toStringView(allocator)'

  if pointer:
    if type.is_primitive and optional: return f'{expr} ?? ffi.nullptr'
    if kind == WGPUTypeKind.VOID: return f'{expr}'

  if kind == WGPUTypeKind.OBJECT:
    _ptr = '_ptr'
    if EXTERNAL: return f'internal{type.object_def.dart_name}GetPtr({expr}).cast()'

    if _force_unopt: return f'{expr}.{_ptr}'
    if expr.endswith('!'): return f'{expr}.{_ptr}'
    return f'{expr}!.{_ptr}'
  if kind == WGPUTypeKind.ENUM:
    if enum_as_int: return f'{expr}.value'
    else: return f'{expr}.toNative()'
  if kind == WGPUTypeKind.FLAG: return f'{expr}.value'
  if kind == WGPUTypeKind.STRUCT:
    _expr = expr
    if optional: _expr = f'{_expr}?'

    if pointer: _expr = f'{_expr}.toNative(allocator)'
    else: _expr = f'{_expr}.toNative(allocator).ref'

    if optional: _expr = f'{_expr} ?? ffi.nullptr'
    return _expr

  print(f'warning (type_to_native): no conversion implemented for type {type.kind} with pointer {pointer} and optional {optional}')
  return expr


def type_from_native(expr: str, type: WGPUType, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, passed_with_ownership: Optional[bool] = None, enum_as_int: bool = False) -> str:
  kind = type.kind

  if type.is_bool: return f'{expr} == 1'
  if not pointer and (type.is_int or type.is_float): return f'{expr}'
  if not pointer and kind in _NULLABLE_FLOAT_TYPES: return f'{expr} != .nan ? {expr} : null'

  if pointer:
    if kind == WGPUTypeKind.VOID: return expr
    if kind == WGPUTypeKind.UINT32: return f'{expr} != ffi.nullptr ? Uint32List.fromList({expr}.asTypedList({expr}Size)) : null'

  if type.is_object:
    ctor = '._borrowed' if passed_with_ownership == False else '._'
    _expr = f'{expr}.cast()' if passed_with_ownership == False else expr

    if EXTERNAL:
      prefix = f'internal{type.object_def.dart_name}'
      if passed_with_ownership == False: return f'{prefix}FromBorrowedPtr({expr}.cast())'
      else: return f'{prefix}FromPtr({expr}.cast())'

    if optional: return f'{expr} != ffi.nullptr ? {type.object_def.dart_name}{ctor}({_expr}) : null'
    else: return f'{type.object_def.dart_name}{ctor}({_expr})'

  if type.is_struct:
    _ref = f'{expr}.ref' if pointer else expr
    if optional: return f'{expr} != ffi.nullptr ? {type.struct_def.dart_name}.fromNative({_ref}) : null'
    else: return f'{type.struct_def.dart_name}.fromNative({_ref})'

  if type.is_enum:
    if enum_as_int: return f'{type.enum_def.dart_name}.fromValue({expr})'
    else: return f'{type.enum_def.dart_name}.fromNative({expr})'

  if type.is_flag: return f'{type.flag_def.dart_name}({expr})'

  if type.is_str:
    return f'{expr}.toDartString()'

  if type.is_callback: return 'null'

  print(f'warning (type_from_native): no conversion implemented for type {type.kind} with pointer {pointer} and optional {optional}')
  return expr


def type_set_native(dest: str, expr: str, type: WGPUType, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, _force_unopt: Optional[bool] = None, enum_as_int: bool = False, non_null_promotion_needed: bool = True) -> list[str]:
  kind = type.kind

  if kind == WGPUTypeKind.ARRAY:
    inner_type = type.array_inner
    c_arr_type = ''
    if inner_type.is_enum or inner_type.is_flag: c_arr_type = 'ffi.UnsignedInt'
    else: c_arr_type = type_to_c_type(inner_type)

    lines: list[str] = []
    lines.append(f'if ({expr}.isNotEmpty) {{')
    lines.append(f'  final arrayPtr = allocator<{c_arr_type}>({expr}.length);')
    lines.append(f'  for (var i = 0; i < {expr}.length; i++) {{')
    lines.append(f'    arrayPtr[i] = {type_to_native(f"{expr}[i]", inner_type, None, None, _force_unopt=True)};')
    lines.append('  }')
    lines.append(f'  {dest} = arrayPtr;')
    lines.append(f'  {_array_count_field(dest)} = {expr}.length;')
    lines.append('}')
    lines.append('else {')
    lines.append(f'  {dest} = ffi.nullptr;')
    lines.append(f'  {_array_count_field(dest)} = 0;')
    lines.append('}')
    return lines

  if not _force_unopt and (optional or kind == WGPUTypeKind.STR_NULLABLE) and not type.is_int and not type.is_float:
    inner_expr = f'{expr}!' if non_null_promotion_needed else expr
    inner = type_set_native(dest, inner_expr, type, pointer, False, _force_unopt=True)
    if len(inner) == 1: return [f'if ({expr} != null) {inner[0]}']

    lines: list[str] = [f'if ({expr} != null) {{']
    lines.extend([f'  {line}' for line in inner])
    lines.append('}')
    return lines

  if kind == WGPUTypeKind.ENUM:
    if enum_as_int: return [f'{dest}AsInt = {expr}.value;']
    else: return [f'{dest} = {expr}.toNative();']

  if pointer:
    if type.is_int or type.is_float:
      lines: list[str] = []
      _expr = f'{expr}!' if non_null_promotion_needed else expr
      lines.append(f'if ({expr} != null) {{')
      lines.append(f'  final _ptr = allocator<{type_to_c_type(type, None, None)}>({_expr}.length);')
      lines.append(f'  _ptr.asTypedList({_expr}.length).setAll(0, {_expr});')
      lines.append(f'  {dest} = _ptr;')
      lines.append('}')
      lines.append(f'else {{')
      lines.append(f'  {dest} = ffi.nullptr;')
      lines.append('}')

      return lines

  if type.is_callback:
    callback = type.callback_def

    lines: list[str] = []
    if _force_unopt:
      if callback.is_listener:
        lines.append(f'{dest}.callback = {expr}.nativeFunction;')
        lines.append(f'{dest}.userdata1 = {expr}.userdata;')
        if callback.style == WGPUCallbackStyle.CALLBACK_MODE:
          lines.append(f'{dest}.modeAsInt = {expr}.callbackMode.value;')
      else:
        lines.append(f'final registry = {callback.registry_name}.instance;')
        lines.append(f'{dest}.callback = registry.nativeFunction;')
        lines.append(f'{dest}.userdata1 = registry.register({expr});')
        if callback.style == WGPUCallbackStyle.CALLBACK_MODE:
          lines.append(f'{dest}.modeAsInt = registry.callbackMode.value;')
    else:
      lines.append(f'if ({expr} != null) {{')

      if callback.is_listener:
        lines.append(f'  {dest}.callback = {expr}!.nativeFunction;')
        lines.append(f'  {dest}.userdata1 = {expr}!.userdata;')
        if callback.style == WGPUCallbackStyle.CALLBACK_MODE:
          lines.append(f'  {dest}.modeAsInt = {expr}!.callbackMode.value;')
      else:
        lines.append(f'  final registry = {callback.registry_name}.instance;')
        lines.append(f'  {dest}.callback = registry.nativeFunction;')
        lines.append(f'  {dest}.userdata1 = registry.register({expr}!);')
        if callback.style == WGPUCallbackStyle.CALLBACK_MODE:
          lines.append(f'  {dest}.modeAsInt = registry.callbackMode.value;')

      lines.append('}')
    return lines

  return [f'{dest} = {type_to_native(expr, type, pointer, optional, _force_unopt)};']


def type_set_dart(dest: str, expr: str, type: WGPUType, pointer: Optional[WGPUPointerKind] = None, optional: Optional[bool] = None, passed_with_ownership: Optional[bool] = None) -> list[str]:
  kind = type.kind

  if kind == WGPUTypeKind.ARRAY:
    inner_type = type.array_inner
    count_field = _array_count_field(expr)

    lines: list[str] = []
    lines.append(f'final {dest} = <{inner_type.dart_type()}>[];')
    lines.append(f'if ({expr} != ffi.nullptr && {count_field} > 0) {{')
    lines.append(f'  for (var i = 0; i < {count_field}; i++) {{')
    lines.append(f'    {dest}.add({type_from_native(f"{expr}[i]", inner_type, None, passed_with_ownership, enum_as_int=True)});')
    lines.append('  }')
    lines.append('}')
    return lines

  return [
    f'final {dest} = {type_from_native(expr, type, pointer, optional)};'
  ]


def parse_type(spec: str) -> WGPUType:
  if spec == 'c_void': return WGPUType(WGPUTypeKind.VOID)
  if spec == 'uint8': return WGPUType(WGPUTypeKind.UINT8)
  if spec == 'uint16': return WGPUType(WGPUTypeKind.UINT16)
  if spec == 'uint32': return WGPUType(WGPUTypeKind.UINT32)
  if spec == 'uint64': return WGPUType(WGPUTypeKind.UINT64)
  if spec == 'int8': return WGPUType(WGPUTypeKind.INT8)
  if spec == 'int16': return WGPUType(WGPUTypeKind.INT16)
  if spec == 'int32': return WGPUType(WGPUTypeKind.INT32)
  if spec == 'int64': return WGPUType(WGPUTypeKind.INT64)
  if spec == 'usize': return WGPUType(WGPUTypeKind.USIZE)
  if spec == 'float32': return WGPUType(WGPUTypeKind.FLOAT32)
  if spec == 'nullable_float32': return WGPUType(WGPUTypeKind.FLOAT32_NULLABLE)
  if spec == 'float64': return WGPUType(WGPUTypeKind.FLOAT64)
  if spec == 'nullable_float64': return WGPUType(WGPUTypeKind.FLOAT64_NULLABLE)
  if spec == 'float64_supertype': return WGPUType(WGPUTypeKind.FLOAT64_SUPERTYPE)
  if spec == 'bool': return WGPUType(WGPUTypeKind.BOOL)
  if spec == 'out_string': return WGPUType(WGPUTypeKind.STR_OUT)
  if spec == 'string_with_default_empty': return WGPUType(WGPUTypeKind.STR_WITH_DEFAULT_EMPTY)
  if spec == 'nullable_string': return WGPUType(WGPUTypeKind.STR_NULLABLE)

  if spec.startswith('enum.'): return WGPUType(WGPUTypeKind.ENUM, name=spec[len('enum.'):])
  if spec.startswith('bitflag.'): return WGPUType(WGPUTypeKind.FLAG, name=spec[len('bitflag.'):])
  if spec.startswith('struct.'): return WGPUType(WGPUTypeKind.STRUCT, name=spec[len('struct.'):])
  if spec.startswith('object.'): return WGPUType(WGPUTypeKind.OBJECT, name=spec[len('object.'):])
  if spec.startswith('callback.'): return WGPUType(WGPUTypeKind.CALLBACK, name=spec[len('callback.'):])

  if spec.startswith('array<') and spec.endswith('>'):
    inner_spec = spec[len('array<'):-1]
    inner_type = parse_type(inner_spec)
    return WGPUType(WGPUTypeKind.ARRAY, array_inner=inner_type)

  print(f'warning: unknown type "{spec}"')
  return WGPUType(WGPUTypeKind.UNKNOWN)


# endregion

# region Constants


@dataclass
class WGPUConstant:
  name: str
  value: int
  doc: list[str] = field(default_factory=list)

  @property
  def dart_name(self) -> str: return self.name.upper()

  @property
  def c_name(self) -> str: return f'bindings.WGPU_{self.name.upper()}'


def parse_constant(spec: dict) -> WGPUConstant:
  name = spec['name']
  value = spec['value']
  doc = parse_doc(spec.get('doc'))
  return WGPUConstant(name, value, doc)


def generate_constant_code(constant: WGPUConstant) -> list[str]:
  lines: list[str] = []
  if constant.doc: lines.extend(generate_doc_code(constant.doc))

  type = 'double' if constant.value == 'nan' else 'int'

  lines.append(f'const {type} {constant.dart_name} = {constant.c_name};')
  return lines


# endregion

# region Enums


@dataclass
class WGPUEnumEntry:
  name: str
  value: int
  doc: list[str] = field(default_factory=list)
  enum: 'WGPUEnum' = None

  @property
  def dart_name(self) -> str: return to_dart_member_name(self.name)

  @property
  def c_name(self) -> str:
    if self.enum.name.endswith('s_type'): return f'WGPUSType_{_c_to_pascal_case(self.name)}'
    return f'{PREFIX}{_c_to_pascal_case(self.enum.name)}_{_c_to_pascal_case(self.name)}'


@dataclass
class WGPUEnum:
  name: str
  entries: list[WGPUEnumEntry]
  doc: list[str] = field(default_factory=list)
  extends: Optional[str] = None

  def __post_init__(self):
    for entry in self.entries: entry.enum = self

  @property
  def dart_name(self) -> str:
    if self.name.endswith('s_type'): return '_SType'
    return to_dart_top_level_name(self.name)

  @property
  def c_name(self) -> str: return f'bindings.{PREFIX}{_c_to_pascal_case(self.name)}'

  @property
  def zero_entry(self) -> Optional[WGPUEnumEntry]: return next((e for e in self.entries if e.value == 0), None)

  def entry(self, name: str) -> Optional[WGPUEnumEntry]: return next((e for e in self.entries if e.name == name), None)


def parse_enum_entry(spec: dict, value: int) -> WGPUEnumEntry:
  name = spec['name']
  doc = parse_doc(spec.get('doc'))
  return WGPUEnumEntry(name, value, doc)


def parse_enum(spec: dict) -> WGPUEnum:
  name = spec['name']
  entries: list[WGPUEnumEntry] = []

  for i, entry_spec in enumerate(spec['entries']):
    if entry_spec is None: entry = WGPUEnumEntry(f'_zero', 0, [])
    else: entry = parse_enum_entry(entry_spec, i)
    entries.append(entry)

  doc = parse_doc(spec.get('doc'))

  enum = WGPUEnum(name, entries, doc)
  for entry in entries: entry.enum = enum
  return enum


def generate_enum_code(enum: WGPUEnum) -> list[str]:
  lines: list[str] = []

  if enum.doc: lines.extend(generate_doc_code(enum.doc))
  has_zero = any(entry.name == '_zero' for entry in enum.entries)

  if enum.extends:
    lines.append(f'extension type const {enum.dart_name}._(int value) implements {to_dart_top_level_name(enum.extends)} {{')
  else:
    lines.append(f'extension type const {enum.dart_name}._(int value) {{')

  last_had_doc = False
  for i, entry in enumerate(enum.entries):
    if entry.doc:
      if i != 0: lines.append('')
      lines.extend(generate_doc_code(entry.doc, indent=1))
    lines.append(f'  static const {entry.dart_name} = {enum.dart_name}._({entry.value});')

  lines[-1] = lines[-1][:-1] + ';'
  lines.append('')

  # toNative
  lines.append(f'  {enum.c_name} toNative() => switch (this) {{')
  for entry in enum.entries:
    if entry.name == '_zero': continue
    lines.append(f'    .{entry.dart_name} => {enum.c_name}.{entry.c_name},')
  lines.append(f'    _ => throw ArgumentError.value(this, \'this\', \'unknown enum entry for {enum.dart_name}\'),')
  lines.append('  };')
  lines.append('')

  # name
  lines.append(f'  String get name => switch (this) {{')
  for entry in enum.entries:
    lines.append(f'    .{entry.dart_name} => \'{entry.name}\',')
  lines.append(f'    _ => throw ArgumentError.value(this, \'this\', \'unknown enum entry for {enum.dart_name}\'),')
  lines.append('  };')
  lines.append('')

  # fromNative
  lines.append(f'  static {enum.dart_name} fromNative({enum.c_name} value) => switch (value) {{')
  for entry in enum.entries:
    if entry.name == '_zero': continue
    lines.append(f'    {enum.c_name}.{entry.c_name} => {enum.dart_name}.{entry.dart_name},')
  lines.append(f'    _ => throw ArgumentError.value(value, \'value\', \'unknown value for {enum.dart_name}\'),')
  lines.append('  };')
  lines.append('')

  # fromValue
  lines.append(f'  static {enum.dart_name} fromValue(int value) => switch (value) {{')
  for entry in enum.entries:
    lines.append(f'    {entry.value} => .{entry.dart_name},')
  lines.append(f'    _ => throw ArgumentError.value(value, \'value\', \'unknown value for {enum.dart_name}\'),')
  lines.append('  };')

  lines.append('}')
  return lines


# endregion

# region Flags

@dataclass
class WGPUFlagEntry:
  name: str
  value: int
  doc: list[str] = field(default_factory=list)

  @property
  def dart_name(self) -> str:
    if self.name in ('default'): return f'{to_dart_member_name(self.name)}_'
    return to_dart_member_name(self.name)


@dataclass
class WGPUFlag:
  name: str
  entries: list[WGPUFlagEntry]
  doc: list[str] = field(default_factory=list)

  @property
  def dart_name(self) -> str: return to_dart_top_level_name(self.name)

  def entry(self, name: str) -> Optional[WGPUEnumEntry]: return next((e for e in self.entries if e.name == name), None)

  @property
  def zero_entry(self) -> Optional[WGPUFlagEntry]: return next((e for e in self.entries if e.value == 0), None)


def parse_flag_entry(spec: dict, value: int) -> WGPUFlagEntry:
  name = spec['name']
  doc = parse_doc(spec.get('doc'))
  return WGPUFlagEntry(name, value, doc)


def parse_flag(spec: dict) -> WGPUFlag:
  name = spec['name']
  entries: list[WGPUFlagEntry] = []

  value = 0
  values: dict[str, int] = {}
  for i, entry_spec in enumerate(spec['entries']):
    if entry_spec is None: continue

    if value == 0 and entry_spec.get('name') != 'none': value = 1
    entry_value = value

    if entry_spec.get('value_combination'):
      combination = entry_spec['value_combination']
      entry_value = 0
      for part in combination:
        if part not in values: raise ValueError(f'invalid value_combination part "{part}" for flag "{name}"')
        entry_value |= values[part]

    entry_name = entry_spec['name']
    entry = parse_flag_entry(entry_spec, entry_value)
    values[entry_name] = entry_value
    entries.append(entry)

    value <<= 1

  doc = parse_doc(spec.get('doc'))
  return WGPUFlag(name, entries, doc)


def generate_flag_code(flag: WGPUFlag) -> list[str]:
  lines: list[str] = []
  dart_name = flag.dart_name

  if flag.doc: lines.extend(generate_doc_code(flag.doc))
  lines.append(f'extension type const {dart_name}(int value) {{')

  for i, entry in enumerate(flag.entries):
    if entry.doc:
      if i != 0: lines.append('')
      lines.extend(generate_doc_code(entry.doc, indent=1))
    lines.append(f'  static const {entry.dart_name} = {dart_name}({entry.value});')

  lines.append('')
  if flag.entry('all') is None:
    all_values = ' | '.join(f'{entry.value}' for entry in flag.entries)
    lines.append(f'  static const all = {dart_name}({all_values});')
    lines.append('')
  
  lines.append(f'  static {dart_name} of(List<{dart_name}> flags) => {dart_name}(flags.fold(0, (v, f) => v | f.value));')
  lines.append('')
  lines.append(f'  bool contains({dart_name} flag) => (value & flag.value) == flag.value;')
  for entry in flag.entries:
    cap = entry.dart_name[0].upper() + entry.dart_name[1:]
    lines.append(f'  bool get has{cap} => contains(.{entry.dart_name});')

  lines.append('')
  lines.append(f'  {dart_name} operator |({dart_name} other) => {dart_name}(value | other.value);')
  lines.append(f'  {dart_name} operator &({dart_name} other) => {dart_name}(value & other.value);')
  lines.append(f'  {dart_name} operator ^({dart_name} other) => {dart_name}(value ^ other.value);')
  lines.append(f'  {dart_name} operator ~() => {dart_name}(~value);')

  lines.append('}')
  return lines


# endregion

# region Functions

@dataclass
class WGPUFunctionReturn:
  type: WGPUType
  doc: list[str] = field(default_factory=list)
  passed_with_ownership: Optional[bool] = None
  pointer: Optional[WGPUPointerKind] = None

  @property
  def dart_type(self) -> str: return self.type.dart_type(self.pointer, force_nonnull=True)

  @property
  def c_type(self) -> str: return self.type.c_type(self.pointer)

  @property
  def c_alloc_type(self) -> str: return self.type.c_type(None)

  def to_native(self, expr: str) -> str:
    return self.type.to_native(expr, self.pointer)

  def from_native(self, expr: str) -> str:
    return self.type.from_native(expr, self.pointer, passed_with_ownership=self.passed_with_ownership)

  def set_native(self, dest: str, expr: str) -> str:
    return self.type.set_native(dest, expr, self.pointer)

  def set_dart(self, dest: str, expr: str) -> str:
    return self.type.set_dart(dest, expr, self.pointer)


@dataclass
class WGPUFunctionArg:
  name: str
  type: WGPUType
  doc: list[str] = field(default_factory=list)
  pointer: Optional[WGPUPointerKind] = None
  optional: Optional[bool] = None
  passed_with_ownership: Optional[bool] = None

  @property
  def dart_name(self) -> str: return to_dart_member_name(self.name)

  @property
  def c_name(self) -> str: return f'_{to_dart_member_name(self.name)}'

  @property
  def dart_type(self) -> str: return self.type.dart_type(self.pointer, self.optional)

  @property
  def c_type(self) -> str: return self.type.c_type(self.pointer, self.optional, enum_as_int=True)

  @property
  def binding_type(self) -> str: return self.type.binding_type(self.pointer, self.optional)

  def to_native(self, expr: str) -> str:
    return self.type.to_native(expr, self.pointer, self.optional, enum_as_int=False, _force_unopt=(not self.optional))

  def from_native(self, expr: str) -> str:
    return self.type.from_native(expr, self.pointer, self.optional, passed_with_ownership=self.passed_with_ownership, enum_as_int=True)

  def set_native(self, dest: str, expr: str) -> str:
    return self.type.set_native(dest, expr, self.pointer, self.optional, enum_as_int=False, non_null_promotion_needed=False)

  @property
  def as_return_type(self) -> WGPUFunctionReturn:
    return WGPUFunctionReturn(self.type, self.doc, self.passed_with_ownership, self.pointer)


class WGPUFunctionShape(Enum):
  ASYNC = auto() # takes a callback
  STATUS_OUT_PARAM = auto() # returns a status and has an out param
  VOID_OUT_PARAM = auto() # has an out param
  SIZE_OUT_PARAM = auto() # returns a size and has an array out param
  SYNC = auto() # default


def classify_method_shape(func: 'WGPUFunction') -> WGPUFunctionShape:
  if func.callback: return WGPUFunctionShape.ASYNC

  has_outparam = (
    func.args and
    func.args[-1].type.is_struct and
    func.args[-1].pointer and
    not func.args[-1].pointer == WGPUPointerKind.IMMUTABLE
  )

  if has_outparam:
    if func.is_void: return WGPUFunctionShape.VOID_OUT_PARAM
    elif func.ret.type.is_enum and func.ret.type.name == 'status': return WGPUFunctionShape.STATUS_OUT_PARAM

  if func.args and func.args[-1].type.is_array and func.ret.type.kind == WGPUTypeKind.USIZE:
    return WGPUFunctionShape.SIZE_OUT_PARAM

  return WGPUFunctionShape.SYNC


@dataclass
class WGPUFunction:
  name: str
  ret: WGPUFunctionReturn
  doc: list[str] = field(default_factory=list)
  args: list[WGPUFunctionArg] = field(default_factory=list)
  callback: Optional[str] = None

  @property
  def dart_name(self) -> str: return to_dart_member_name(self.name)

  @property
  def c_name(self) -> str: return f'bindings.{PREFIX_L}{_c_to_pascal_case(self.name)}'

  @property
  def c_name_raw(self) -> str: return f'{PREFIX_L}{_c_to_pascal_case(self.name)}'

  @property
  def is_void(self) -> bool: return self.ret.type.is_void and not self.ret.pointer

  @property
  def shape(self) -> WGPUFunctionShape: return classify_method_shape(self)


def parse_function_return(spec: Optional[dict]) -> WGPUFunctionReturn:
  if not spec: return WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID))
  type = parse_type(spec['type'])
  doc = parse_doc(spec.get('doc'))
  passed_with_ownership = spec.get('passed_with_ownership')
  pointer = parse_pointer_kind(spec.get('pointer'))
  return WGPUFunctionReturn(type, doc, passed_with_ownership, pointer)


def parse_function_arg(spec: dict) -> WGPUFunctionArg:
  name = spec['name']
  type = parse_type(spec['type'])
  doc = parse_doc(spec.get('doc'))
  pointer = parse_pointer_kind(spec.get('pointer'))
  optional = spec.get('optional')
  passed_with_ownership = spec.get('passed_with_ownership')
  return WGPUFunctionArg(name, type, doc, pointer, optional, passed_with_ownership)


def parse_function(spec: dict) -> WGPUFunction:
  name = spec['name']
  doc = parse_doc(spec.get('doc'))
  ret = parse_function_return(spec.get('returns'))
  args = [parse_function_arg(arg_spec) for arg_spec in spec.get('args', [])]
  callback = spec.get('callback')
  return WGPUFunction(name, ret, doc, args, callback)


@dataclass
class _MethodOverrides:
  dart_name_override: Optional[str] = None
  c_name_override: Optional[str] = None
  injected_first_arg: Optional[str] = None


def generate_function_arg_list(args: list[WGPUFunctionArg]) -> str:
  return ', '.join(f'{arg.dart_type} {arg.dart_name}' for arg in args)


def generate_function_arg_marshalling(args: list[WGPUFunctionArg]) -> list[str]:
  lines: list[str] = []

  for i, arg in enumerate(args):
    setter = arg.set_native(arg.c_name, arg.dart_name)

    if len(setter) == 1: lines.append(f'final {arg.c_name} = {arg.to_native(arg.dart_name)};')
    else:
      if arg.type.is_array:
        lines.append(f'late final int {_array_count_field(arg.c_name)};')
      lines.append(f'late final {arg.binding_type} {arg.c_name};')
      lines.extend(setter)

  return lines


def generate_function_call_args(args: list[WGPUFunctionArg], injected_first_arg: Optional[str] = None, injected_last_arg: Optional[str] = None) -> str:
  call_args: list[str] = []

  if injected_first_arg: call_args.append(injected_first_arg)
  for arg in args:
    if arg.type.is_array: call_args.append(_array_count_field(arg.c_name))

    if EXTERNAL and arg.type.is_object: call_args.append(f'{arg.c_name}.cast()')
    else: call_args.append(arg.c_name)

  if injected_last_arg: call_args.append(injected_last_arg)
  return ', '.join(call_args)


def _generate_sync_function_code(func: WGPUFunction, overrides: _MethodOverrides) -> list[str]:
  c_name = overrides.c_name_override if overrides.c_name_override else func.c_name
  dart_name = overrides.dart_name_override if overrides.dart_name_override else func.dart_name
  injected_first_arg = overrides.injected_first_arg

  return_type = func.ret.dart_type
  func_signature = f'{return_type} {dart_name}({generate_function_arg_list(func.args)})'

  lines: list[str] = []
  lines.append(f'{func_signature} => using((allocator) {{')
  lines.extend(indent(generate_function_arg_marshalling(func.args)))

  call_args = generate_function_call_args(func.args, injected_first_arg)

  if not func.is_void:
    lines.append(f'  final result = {c_name}({call_args});')
    lines.append(f'  return {func.ret.from_native("result")};')
  else:
    lines.append(f'  {c_name}({call_args});')

  lines.append('});')
  return lines


def _generate_out_param_function_code(func: WGPUFunction, overrides: _MethodOverrides, ret_status: bool = False) -> list[str]:
  c_name = overrides.c_name_override if overrides.c_name_override else func.c_name
  dart_name = overrides.dart_name_override if overrides.dart_name_override else func.dart_name
  injected_first_arg = overrides.injected_first_arg

  raw_out = func.args[-1]
  in_args = func.args[:-1]
  out = WGPUFunctionReturn(raw_out.type, raw_out.doc, raw_out.passed_with_ownership, WGPUPointerKind.MUTABLE)

  return_type = out.dart_type
  func_signature = f'{return_type} {dart_name}({generate_function_arg_list(in_args)})'

  lines: list[str] = []
  lines.append(f'{func_signature} => using((allocator) {{')
  lines.append(f'  final outPtr = allocator<{out.c_alloc_type}>();')
  lines.extend(indent(generate_function_arg_marshalling(in_args)))

  call_args = generate_function_call_args(in_args, injected_first_arg, 'outPtr')

  if ret_status:
    lines.append(f'  final status = {c_name}({call_args});')
    lines.append(f'  if (status != .WGPUStatus_Success) throw StateError(\'{c_name.split("bindings.")[1]} failed: $status\');')
  else:
    lines.append(f'  {c_name}({call_args});')

  if out.type.is_struct and out.type.struct_def.free_members == True:
    lines.append(f'  final result = {out.from_native("outPtr")};')
    lines.append(f'  {out.type.struct_def.c_free_members_fn}(outPtr.ref);')
    lines.append(f'  return result;')
  else:
    lines.append(f'  return {out.from_native("outPtr")};')

  lines.append('});')
  return lines


def _generate_size_out_param_function_code(func: WGPUFunction, overrides: _MethodOverrides) -> list[str]:
  c_name = overrides.c_name_override if overrides.c_name_override else func.c_name
  dart_name = overrides.dart_name_override if overrides.dart_name_override else func.dart_name
  injected_first_arg = overrides.injected_first_arg

  raw_out = func.args[-1]
  in_args = func.args[:-1]
  out = WGPUFunctionReturn(raw_out.type, raw_out.doc, raw_out.passed_with_ownership, WGPUPointerKind.MUTABLE)

  return_type = out.dart_type
  func_signature = f'{return_type} {dart_name}({generate_function_arg_list(in_args)})'

  lines: list[str] = []
  lines.append(f'{func_signature} => using((allocator) {{')
  lines.append(f'  final outPtr = allocator<{out.type.array_inner.c_type()}>();')
  lines.extend(indent(generate_function_arg_marshalling(in_args)))

  call_args = generate_function_call_args(in_args, injected_first_arg, 'outPtr')
  lines.append(f'  final length = {c_name}({call_args});')
  lines.append(f'  final result = <{out.type.array_inner.dart_type()}>[];')

  lines.append(f'  for (var i = 0; i < length; i++) {{')
  lines.append(f'    result.add({out.type.array_inner.from_native(f"outPtr[i]", passed_with_ownership=out.passed_with_ownership)});')
  lines.append('  }')

  lines.append(f'  return result;')
  lines.append('});')
  return lines


def __generate_async_function(func: WGPUFunction, ret: WGPUType, signature: str, func_body: list[str], _async: bool = True) -> list[str]:
  lines: list[str] = []

  result_type = '_AsyncResult' if _async else '_SyncResult'
  driver = 'Instance.asyncDriver' if _async else 'Instance.syncDriver'

  lines.append(f'{signature} {{')
  lines.append(f'  final _result = {result_type}<{ret.dart_type}>();')
  lines.extend(indent(func_body))
  lines.append('')
  lines.append(f'  return _result.waitUntilDone({driver});')
  lines.append('}')
  return lines


def _generate_async_function_code(func: WGPUFunction, overrides: _MethodOverrides) -> list[str]:
  c_name = overrides.c_name_override if overrides.c_name_override else func.c_name
  dart_name = overrides.dart_name_override if overrides.dart_name_override else func.dart_name
  injected_first_arg = overrides.injected_first_arg

  callback = CALLBACKS[func.callback.split('.')[1]]
  if not callback: raise ValueError(f'async function {func.name} is missing callback')

  cb_status_arg: Optional[WGPUFunctionArg] = None
  cb_result_arg: Optional[WGPUFunctionArg] = None
  cb_message_arg: Optional[WGPUFunctionArg] = None

  for arg in callback.args:
    type = arg.type
    if type.is_enum and arg.name == 'status': cb_status_arg = arg
    elif type.is_object or (type.is_struct and not type.is_str) or type.is_enum or type.is_flag:
      if cb_result_arg is None: cb_result_arg = arg
    elif type.is_str and arg.name == 'message': cb_message_arg = arg

  lines: list[str] = []
  ret = cb_result_arg.as_return_type if cb_result_arg else WGPUFunctionReturn(WGPUType(WGPUTypeKind.VOID))

  func_arg_list = generate_function_arg_list(func.args)

  callback_type = WGPUType(WGPUTypeKind.CALLBACK, name=callback.name)

  callback_code: list[str] = []
  callback_code.append(f'final callback = ({generate_function_arg_list(callback.args)}) {{')
  callback_code.append(f'  if ({cb_status_arg.dart_name} == .success) {{')
  if cb_result_arg:
    callback_code.append(f'    _result.complete({cb_result_arg.dart_name});')
  else:
    callback_code.append(f'    _result.complete(null);')
  callback_code.append(f'  }}')
  callback_code.append(f'  else {{')
  if cb_message_arg:
    callback_code.append(f'    _result.completeError(StateError(\'{func.c_name_raw} failed (${cb_status_arg.dart_name}): ${cb_message_arg.dart_name}\'), StackTrace.current);')
  else:
    callback_code.append(f'    _result.completeError(StateError(\'{func.c_name_raw} failed: ${cb_status_arg.dart_name}\'), StackTrace.current);')
  callback_code.append(f'  }}')
  callback_code.append('};')

  func_body: list[str] = []
  func_body.append(f'using((allocator) {{')
  func_body.extend(indent(callback_code))
  func_body.append(f'')
  func_body.append(f'  final callbackInfo = allocator<{callback.c_callback_info_name}>();')
  func_body.extend(indent(callback_type.set_native('callbackInfo.ref', 'callback', _force_unopt=True)))
  func_body.append(f'')
  call_args = generate_function_call_args(func.args, injected_first_arg, 'callbackInfo.ref')
  func_body.extend(indent(generate_function_arg_marshalling(func.args)))
  func_body.append(f'  {c_name}({call_args});')
  func_body.append(f'}});')

  # Async version
  lines.extend(
    __generate_async_function(
      func,
      ret,
      f'Future<{ret.dart_type}> {dart_name}({func_arg_list})',
      func_body,
      _async=True,
    )
  )

  lines.append('')

  # Sync version
  _dart_name = dart_name
  name_wrappers: list[str] = []

  if _dart_name.endswith('Impl'):
    name_wrappers.append(_dart_name[-4:])
    _dart_name = _dart_name[:-4]

  if _dart_name.endswith('Async'):
    _dart_name = _dart_name[:-5]

  sync_name = f'{_dart_name}Sync'
  for w in reversed(name_wrappers): sync_name += w

  lines.extend(
    __generate_async_function(
      func,
      ret,
      f'{ret.dart_type} {sync_name}({func_arg_list})',
      func_body,
      _async=False,
    )
  )

  return lines


def generate_function_code(func: WGPUFunction, overrides: _MethodOverrides = _MethodOverrides()) -> list[str]:
  lines: list[str] = []
  if func.doc: lines.extend(generate_doc_code(func.doc))

  shape = func.shape
  if shape == WGPUFunctionShape.SYNC: lines.extend(_generate_sync_function_code(func, overrides))
  elif shape == WGPUFunctionShape.VOID_OUT_PARAM: lines.extend(_generate_out_param_function_code(func, overrides, ret_status=False))
  elif shape == WGPUFunctionShape.STATUS_OUT_PARAM: lines.extend(_generate_out_param_function_code(func, overrides, ret_status=True))
  elif shape == WGPUFunctionShape.SIZE_OUT_PARAM: lines.extend(_generate_size_out_param_function_code(func, overrides))
  elif shape == WGPUFunctionShape.ASYNC: lines.extend(_generate_async_function_code(func, overrides))
  else: raise ValueError(f'unsupported function shape {shape}')

  return lines


def generate_global_function_code(func: WGPUFunction) -> list[str]:
  overrides = _MethodOverrides(
    dart_name_override=f'_{func.dart_name}'
  )

  return generate_function_code(func, overrides)


# endregion

# region Structs

@dataclass
class WGPUStructMember:
  name: str
  type: WGPUType
  doc: list[str] = field(default_factory=list)
  pointer: Optional[WGPUPointerKind] = None
  optional: Optional[bool] = None
  default: Optional[str] = None
  struct: 'WGPUStruct' = None

  @property
  def dart_name(self) -> str:
    if self.type.is_callback:
      callback = self.type.callback_def
      _name = callback.dart_name
      if callback.is_listener: _name = callback.listener_name
      return _name[0].lower() + _name[1:]

    return to_dart_member_name(self.name)

  @property
  def c_name(self) -> str: return _c_to_camel_case(self.name)

  @property
  def dart_constructor_type(self) -> str: return self.type.dart_type(self.pointer, self.optional, force_nonnull=True)

  @property
  def dart_type(self) -> str: return self.type.dart_type(self.pointer, self.optional)

  @property
  def c_type(self) -> str: return self.type.c_type(self.pointer, self.optional)

  @property
  def zero_value(self) -> str: return self.type.zero_value(self.pointer)

  @property
  def resolve_default(self) -> Optional[str]:
    full_name = f'{self.struct.name}.{self.name}'
    if full_name in STRUCT_DEFAULTS_OVERRIDES: return STRUCT_DEFAULTS_OVERRIDES[full_name]
    if self.type.kind == WGPUTypeKind.STR_WITH_DEFAULT_EMPTY: return '\'\''
    if self.type.kind == WGPUTypeKind.ARRAY: return 'const []'
    if self.type.kind == WGPUTypeKind.BOOL:
      if self.default == True: return 'true'
      if self.default == False: return 'false'

    if self.default == 'zero': return self.zero_value

    if self.type.is_enum:
      enum = self.type.enum_def
      entry = enum.entry(self.default) if self.default else enum.zero_entry
      if entry: return f'.{entry.dart_name}'

    if self.type.is_flag:
      flag = self.type.flag_def
      entry = flag.entry(self.default) if self.default else flag.zero_entry
      if entry: return f'.{entry.dart_name}'

    if self.type.is_struct and not self.pointer:
      struct = self.type.struct_def
      if struct.all_members_initialized: return f'const {struct.dart_name}()'

    if isinstance(self.default, str) and self.default.startswith('constant.'):
      constant_name = self.default[len('constant.'):]
      if constant_name in CONSTANTS: return f'{CONSTANTS[constant_name].dart_name}'

    return self.default

  def to_native(self, expr: str) -> str:
    return self.type.to_native(expr, self.pointer, self.optional)

  def from_native(self, expr: str) -> str:
    return self.type.from_native(expr, self.pointer, self.optional)

  def set_native(self, dest: str, expr: str) -> str:
    optional = self.optional
    if self.type.is_primitive and self.pointer: optional = True
    return self.type.set_native(dest, expr, self.pointer, optional, enum_as_int=True)

  def set_dart(self, dest: str, expr: str) -> str:
    return self.type.set_dart(dest, expr, self.pointer, self.optional)


class WGPUStructType(Enum):
  EXTENSIBLE = auto()
  EXTENSIBLE_CALLBACK_ARG = auto()
  EXTENSION = auto()
  STANDALONE = auto()


@dataclass
class WGPUStruct:
  name: str
  type: WGPUStructType
  doc: list[str] = field(default_factory=list)
  extends: list[str] = field(default_factory=list)
  free_members: Optional[bool] = None
  members: list[WGPUStructMember] = field(default_factory=list)

  def __post_init__(self):
    for member in self.members: member.struct = self

  @property
  def dart_name(self) -> str:
    if self.name == 'future': return 'WGPUFuture'
    return to_dart_top_level_name(self.name)

  @property
  def c_name(self) -> str: return f'bindings.{PREFIX}{_c_to_pascal_case(self.name)}'

  @property
  def all_members_initialized(self) -> bool:
    return all(member.resolve_default is not None or member.optional for member in self.members)

  @property
  def is_extensible(self) -> bool: return self.type in (WGPUStructType.EXTENSIBLE, WGPUStructType.EXTENSIBLE_CALLBACK_ARG)

  @property
  def is_extension(self) -> bool: return self.type == WGPUStructType.EXTENSION

  @property
  def has_chain(self) -> bool: return self.is_extensible or self.is_extension

  @property
  def c_free_members_fn(self) -> str: return f'bindings.{PREFIX_L}{_c_to_pascal_case(self.name)}FreeMembers'


def parse_struct_member(spec: dict) -> WGPUStructMember:
  name = spec['name']
  doc = parse_doc(spec.get('doc'))
  type = parse_type(spec['type'])
  pointer = parse_pointer_kind(spec.get('pointer'))
  optional = spec.get('optional')
  default = spec.get('default')
  return WGPUStructMember(name, type, doc, pointer, optional, default)


def parse_struct_type(spec: str) -> WGPUStructType:
  if spec == 'extensible': return WGPUStructType.EXTENSIBLE
  if spec == 'extensible_callback_arg': return WGPUStructType.EXTENSIBLE_CALLBACK_ARG
  if spec == 'extension': return WGPUStructType.EXTENSION
  if spec == 'standalone': return WGPUStructType.STANDALONE
  raise ValueError(f'invalid struct type spec "{spec}"')


def parse_struct(spec: dict) -> WGPUStruct:
  name = spec['name']
  doc = parse_doc(spec.get('doc'))
  type = parse_struct_type(spec['type'])
  extends = spec.get('extends', [])
  free_members = spec.get('free_members')
  members = [parse_struct_member(member_spec) for member_spec in spec.get('members', [])]
  return WGPUStruct(name, type, doc, extends, free_members, members)


def generate_struct_code(struct: WGPUStruct) -> list[str]:
  lines: list[str] = []
  if struct.doc: lines.extend(generate_doc_code(struct.doc))

  if struct.is_extension:
    lines.append(f'class {struct.dart_name} extends ChainedStruct {{')
  else:
    lines.append(f'class {struct.dart_name} {{')

  has_members = len(struct.members) > 0
  has_empty_constructor = not has_members and not struct.has_chain

  constructor_lines: list[str] = []
  private_constructor_lines: list[str] = []
  zero_init_constructor_lines: list[str] = []
  field_lines: list[str] = []
  to_native_lines: list[str] = []
  from_native_lines: list[str] = []

  # Constructor
  constructor_lines.append(f'const {struct.dart_name}({{')

  for member in struct.members:
    type = member.type
    dart_name = member.dart_name
    dart_type = member.dart_constructor_type
    dart_member_type = member.dart_type
    default = member.resolve_default

    specify_type = dart_type != dart_member_type or (type.is_object and not member.optional)

    if member.optional or type.kind == WGPUTypeKind.STR_NULLABLE or type.is_callback: constructor_lines.append(f'  this.{dart_name},')
    elif default is not None: constructor_lines.append(f'  this.{dart_name} = {default},')
    elif specify_type: constructor_lines.append(f'  required {dart_type} this.{dart_name},')
    else: constructor_lines.append(f'  required this.{dart_name},')

  if struct.is_extension: constructor_lines.append(f'  super.next,')
  elif struct.is_extensible: constructor_lines.append(f'  this.next,')

  constructor_lines.append(f'}});')
  if has_empty_constructor: constructor_lines = [f'const {struct.dart_name}();']

  # Private constructor
  private_constructor_lines.append(f'const {struct.dart_name}._({{')

  for member in struct.members:
    dart_name = member.dart_name
    private_constructor_lines.append(f'  required this.{dart_name},')

  if struct.is_extension: private_constructor_lines.append(f'  super.next,')
  elif struct.is_extensible: private_constructor_lines.append(f'  this.next,')

  private_constructor_lines.append(f'}});')
  if has_empty_constructor: private_constructor_lines = [f'const {struct.dart_name}._();']

  try:
    # Zero-init constructor
    zero_init_constructor_lines.append(f'static const {struct.dart_name} _zero = ._(')

    for i, member in enumerate(struct.members):
      dart_name = member.dart_name
      zero_value = member.zero_value.replace('const', '').strip()
      zero_init_constructor_lines.append(f'  {dart_name}: {zero_value},')

    if struct.has_chain: zero_init_constructor_lines.append(f'  next: null,')
    zero_init_constructor_lines.append(f');')
    if has_empty_constructor: zero_init_constructor_lines = [f'static const {struct.dart_name} _zero = ._();']
  except Exception as e:
    print(f'warning: failed generating zero-init constructor for struct {struct.name}: {e}')
    zero_init_constructor_lines = []

  # Fields
  for member in struct.members:
    dart_type = member.dart_type
    dart_name = member.dart_name

    if (member.type.is_object and not member.optional) or (member.type.is_primitive and member.pointer):
      field_lines.append(f'final {dart_type}? {dart_name};')
    else:
      field_lines.append(f'final {dart_type} {dart_name};')

  if struct.is_extensible:
    field_lines.append(f'final ChainedStruct? next;')

  # SType for chained structs
  if struct.is_extension:
    field_lines.append(f'')
    field_lines.append(f'@override')

    name = struct.dart_name
    name = name[0].lower() + name[1:]
    field_lines.append(f'int get sType => _SType.{name}.value;')

  # toNative
  if struct.is_extension: to_native_lines.append(f'@override')
  to_native_lines.append(f'ffi.Pointer<{struct.c_name}> toNative(ffi.Allocator allocator) {{')
  to_native_lines.append(f'  final ptr = allocator<{struct.c_name}>();')

  # chain
  if struct.is_extensible:
    to_native_lines.append(f'  ptr.ref.nextInChain = next?.toNative(allocator).cast() ?? ffi.nullptr;')
    to_native_lines.append(f'')
  elif struct.is_extension:
    to_native_lines.append(f'  ptr.ref.chain.sTypeAsInt = sType;')
    to_native_lines.append(f'  ptr.ref.chain.next = next?.toNative(allocator).cast() ?? ffi.nullptr;')
    to_native_lines.append(f'')

  for member in struct.members:
    dart_name = member.dart_name
    c_name = member.c_name

    to_native_lines.extend(indent(member.set_native(f'ptr.ref.{c_name}', dart_name)))

  to_native_lines.append(f'  return ptr;')
  to_native_lines.append('}')

  # fromNative
  from_native_lines.append(f'factory {struct.dart_name}.fromNative({struct.c_name} str) {{')

  for member in struct.members:
    dart_name = member.dart_name
    c_name = member.c_name
    from_native_lines.extend(indent(member.set_dart(dart_name, f'str.{c_name}')))

  from_native_lines.append(f'  return {struct.dart_name}._(')

  for member in struct.members:
    dart_name = member.dart_name
    from_native_lines.append(f'    {dart_name}: {dart_name},')

  if struct.is_extensible:
    from_native_lines.append(f'    next: ChainedStruct.fromNative(str.nextInChain),')
  elif struct.is_extension:
    from_native_lines.append(f'    next: ChainedStruct.fromNative(str.chain.next),')

  from_native_lines.append('  );')
  from_native_lines.append('}')

  lines.extend(indent(constructor_lines))
  if not has_empty_constructor: lines.append('')
  lines.extend(indent(private_constructor_lines))
  if not has_empty_constructor: lines.append('')
  if zero_init_constructor_lines:
    lines.extend(indent(zero_init_constructor_lines))
    lines.append('')

  if not has_empty_constructor:
    lines.extend(indent(field_lines))
    lines.append('')

  lines.extend(indent(to_native_lines))
  lines.append('')
  lines.extend(indent(from_native_lines))

  lines.append('}')
  return lines


def generate_chained_struct_from_native_code(structs: dict[str, WGPUStruct], prefix: str) -> list[str]:
  chain_extensions = [s for s in structs.values() if s.is_extension]

  lines = [
    f'ChainedStruct? {prefix}_ChainedStructFromNative(ffi.Pointer<bindings.WGPUChainedStruct> ptr) {{',
    f'  if (ptr == ffi.nullptr) return null;',
    f'  final stype = ptr.ref.sTypeAsInt;',
    f'  return switch (stype) {{',
  ]

  stype_enum = ENUMS['s_type']

  val_to_result: dict[int, str] = {}

  for s in chain_extensions:
    stype = stype_enum.entry(s.name)
    dart_name = s.dart_name

    val_to_result[stype.value] = f'{dart_name}.fromNative(ptr.cast<{s.c_name}>().ref)'

  vals_sorted = sorted(val_to_result.keys())
  for val in vals_sorted:
    result = val_to_result[val]
    lines.append(f'    {val} => {result},')

  lines.append(f'    _ => throw ArgumentError(\'Unknown chained struct type: $stype\'),')
  lines.append(f'  }};')
  lines.append(f'}}')

  return lines


# endregion

# region Objects


@dataclass
class WGPUObject:
  name: str
  doc: list[str] = field(default_factory=list)
  methods: list['WGPUFunction'] = field(default_factory=list)

  @property
  def dart_name(self) -> str: return to_dart_top_level_name(self.name)

  @property
  def c_name(self) -> str: return f'bindings.{PREFIX}{_c_to_pascal_case(self.name)}'

  @property
  def c_release_raw_name(self) -> str: return f'{PREFIX_L}{self.dart_name}Release'


def parse_object(spec: dict) -> WGPUObject:
  name = spec['name']
  doc = parse_doc(spec.get('doc'))
  methods = [parse_function(method_spec) for method_spec in spec.get('methods', [])]
  return WGPUObject(name, doc, methods)


def generate_object_code(obj: WGPUObject) -> list[str]:
  lines: list[str] = []
  if obj.doc: lines.extend(generate_doc_code(obj.doc))

  base_name = f'_{obj.dart_name}Base'

  lines.append(f'class {base_name} extends _Opaque<{obj.c_name}Impl> {{')
  lines.append(f'  {base_name}._(super.ptr): super._();')
  lines.append(f'  {base_name}._borrowed(super.ptr): super._borrowed();')
  lines.append(f'')
  lines.append(f'  @override')
  lines.append(f'  ffi.NativeFinalizer get _finalizer => __finalizer;')
  lines.append(f'  static final __finalizer = ffi.NativeFinalizer(bindings.addresses.{obj.c_release_raw_name}.cast());')
  lines.append(f'')
  lines.append(f'  @override')
  lines.append(f'  void dispose() => _dispose(bindings.{obj.c_release_raw_name});')

  for method in obj.methods:
    overrides = _MethodOverrides(
      c_name_override=f'bindings.{PREFIX_L}{obj.dart_name}{_c_to_pascal_case(method.name)}',
      dart_name_override=f'_{to_dart_member_name(method.name)}Impl',
      injected_first_arg='_ptr',
    )

    method_lines = generate_function_code(method, overrides=overrides)

    if method_lines:
      lines.append('')
      lines.extend(indent(method_lines))

  lines.append('}')

  skipped = obj.name in SKIP_OBJECT_CLASS_GEN

  if not skipped:
    lines.append('')
    lines.append(f'class {obj.dart_name} extends _{obj.dart_name}Base with _{obj.dart_name}Impl {{')
    lines.append(f'  {obj.dart_name}._(super.ptr): super._();')
    lines.append(f'  {obj.dart_name}._borrowed(super.ptr): super._borrowed();')
    lines.append('}')

  # generate external helpers
  lines.append(f'')
  lines.append(f'ffi.Pointer<{obj.c_name}Impl> internal{obj.dart_name}GetPtr({obj.dart_name} obj) => obj._ptr;')
  lines.append(f'{obj.dart_name} internal{obj.dart_name}FromPtr(ffi.Pointer<{obj.c_name}Impl> ptr) => ._(ptr);')
  lines.append(f'{obj.dart_name} internal{obj.dart_name}FromBorrowedPtr(ffi.Pointer<{obj.c_name}Impl> ptr) => ._borrowed(ptr);')

  return lines

# endregion

# region Callbacks


class WGPUCallbackStyle(Enum):
  CALLBACK_MODE = auto()
  IMMEDIATE = auto()


def parse_callback_style(spec: str) -> WGPUCallbackStyle:
  if spec == 'callback_mode': return WGPUCallbackStyle.CALLBACK_MODE
  if spec == 'immediate': return WGPUCallbackStyle.IMMEDIATE
  raise ValueError(f'invalid callback style spec "{spec}"')


@dataclass
class WGPUCallback:
  name: str
  style: WGPUCallbackStyle
  doc: list[str] = field(default_factory=list)
  args: list[WGPUFunctionArg] = field(default_factory=list)
  userdatas: int = 2

  @property
  def is_listener(self) -> bool: return self.style == WGPUCallbackStyle.IMMEDIATE

  @property
  def dart_name(self) -> str: return f'{to_dart_top_level_name(self.name)}Callback'

  @property
  def c_name(self) -> str: return f'bindings.{PREFIX}{to_dart_top_level_name(self.name)}CallbackFunction'

  @property
  def c_callback_info_name(self) -> str: return f'bindings.{PREFIX}{to_dart_top_level_name(self.name)}CallbackInfo'

  @property
  def trampoline_name(self) -> str: return f'_{to_dart_member_name(self.name)}CallbackTrampoline'

  @property
  def registry_name(self) -> str: return f'_{to_dart_top_level_name(self.name)}CallbackRegistry'

  @property
  def listener_name(self) -> str: return f'{to_dart_top_level_name(self.name)}Listener'


def parse_callback(spec: dict) -> WGPUCallback:
  name = spec['name']
  style = parse_callback_style(spec['style'])
  doc = parse_doc(spec.get('doc'))
  args = [parse_function_arg(arg_spec) for arg_spec in spec.get('args', [])]
  return WGPUCallback(name, style, doc, args)


def generate_callback_code(callback: WGPUCallback) -> list[str]:
  lines: list[str] = []

  dart_args = ', '.join(f'{arg.dart_type} {arg.dart_name}' for arg in callback.args)

  c_args = [*(f'{arg.c_type} {arg.c_name}' for arg in callback.args)]
  c_args += [f'ffi.Pointer<ffi.Void> userdata{i}' for i in range(1, callback.userdatas + 1)]
  c_args = ', '.join(c_args)

  # Typedefs
  lines.append(f'typedef {callback.dart_name} = void Function({dart_args});')

  # Trampoline
  lines.append(f'void {callback.trampoline_name}({c_args}) {{')
  lines.append(f'  final handler = {callback.registry_name}.instance.lookup(userdata1);')
  lines.append(f'  if (handler == null) return;')

  for arg in callback.args:
    lines.append(f'  final {arg.dart_name} = {arg.from_native(arg.c_name)};')

  handler_call_args = ', '.join(arg.dart_name for arg in callback.args)
  lines.append(f'  handler({handler_call_args});')
  lines.append('}')
  lines.append('')

  # Registry
  lines.extend([
    f'class {callback.registry_name} extends _CallbackRegistry<{callback.dart_name}, ffi.NativeFunction<{callback.c_name}>> {{',
    f'  static final instance = {callback.registry_name}();',
    f'',
  ])

  lines.extend([
    f'  @override',
    f'  ffi.Pointer<ffi.NativeFunction<{callback.c_name}>> get nativeFunction => _callable.nativeFunction;',
    f'  final ffi.NativeCallable<{callback.c_name}> _callable = .isolateLocal({callback.trampoline_name});',
    f'}}',
  ])

  # Listener
  if callback.is_listener:
    lines.append('')
    lines.extend([
      f'class {callback.listener_name} extends _CallbackListener<{callback.dart_name}, ffi.NativeFunction<{callback.c_name}>> {{',
      f'  {callback.listener_name}({callback.dart_name} handler): super(handler, {callback.registry_name}.instance);',
      f'}}',
    ])

  return lines


# endregion

# region Main


def parse() -> None:
  with open(SPEC_PATH) as f: spec = yaml.safe_load(f)

  print('starting webgpu codegen...')

  for constant_spec in spec['constants']:
    constant = parse_constant(constant_spec)
    CONSTANTS[constant.name] = constant
  print(f'  discovered {len(CONSTANTS)} constants')

  for enum_spec in spec['enums']:
    enum = parse_enum(enum_spec)
    ENUMS[enum.name] = enum
  print(f'  discovered {len(ENUMS)} enums')

  for flag_spec in spec['bitflags']:
    flag = parse_flag(flag_spec)
    FLAGS[flag.name] = flag
  print(f'  discovered {len(FLAGS)} flags')

  for function_spec in spec['functions']:
    function = parse_function(function_spec)
    GLOBAL_FUNCTIONS[function.name] = function
  print(f'  discovered {len(GLOBAL_FUNCTIONS)} global functions')

  for struct_spec in spec['structs']:
    struct = parse_struct(struct_spec)
    STRUCTS[struct.name] = struct
  print(f'  discovered {len(STRUCTS)} structs')

  for object_spec in spec['objects']:
    obj = parse_object(object_spec)
    OBJECTS[obj.name] = obj
  print(f'  discovered {len(OBJECTS)} objects')

  for callback_spec in spec['callbacks']:
    callback = parse_callback(callback_spec)
    CALLBACKS[callback.name] = callback
  print(f'  discovered {len(CALLBACKS)} callbacks')


def _get_gen(own, other):
  if other is not None:
    own.update(other)
    return other

  return own


def generate(
  out_path: Path,
  external: bool = False,
  chained_struct_prefix: Optional[str] = None,
  preludes: Optional[list[str]] = None,
  enums: Optional[dict[str, WGPUEnum]] = None,
  flags: Optional[dict[str, WGPUFlag]] = None,
  constants: Optional[dict[str, WGPUConstant]] = None,
  global_functions: Optional[dict[str, WGPUFunction]] = None,
  structs: Optional[dict[str, WGPUStruct]] = None,
  objects: Optional[dict[str, WGPUObject]] = None,
  callbacks: Optional[dict[str, WGPUCallback]] = None,
):
  global ENUMS, FLAGS, CONSTANTS, GLOBAL_FUNCTIONS, STRUCTS, OBJECTS, CALLBACKS, EXTERNAL

  gen_enums = _get_gen(ENUMS, enums)
  gen_flags = _get_gen(FLAGS, flags)
  gen_constants = _get_gen(CONSTANTS, constants)
  gen_global_functions = _get_gen(GLOBAL_FUNCTIONS, global_functions)
  gen_structs = _get_gen(STRUCTS, structs)
  gen_objects = _get_gen(OBJECTS, objects)
  gen_callbacks = _get_gen(CALLBACKS, callbacks)
  EXTERNAL = external

  code: list[str] = [
    f'// GENERATED CODE - DO NOT MODIFY BY HAND',
    f'//',
    f'// Generated by tool/webgpu_gen.py',
    f'// Spec source: {SPEC_PATH.relative_to(ROOT)}',
    f'//',
    f'// ignore_for_file: unused_element, unused_field, constant_identifier_names, prefer_function_declarations_over_variables, non_constant_identifier_names',
    f'',
    f'import \'dart:async\';',
    f'import \'dart:ffi\' as ffi;',
    f'import \'dart:typed_data\';',
    f'',
    f'import \'package:ffi/ffi.dart\';',
    f'',
    f'import \'bindings.g.dart\' as bindings;',
    f'import \'../utils/chained_struct.dart\';',
  ]

  if not external:
    code.extend([
      f'import \'platform/native.dart\' if (dart.library.js_interop) \'platform/web.dart\';',
    ])

  code.extend([
    '',
    f'// dart format off',
  ])

  if preludes:
    code.extend(preludes)
    code.append('')

  for object in gen_objects.values():
    code.append(f'part \'types/{object.name}.dart\';')
  if gen_objects: code.append('')

  for constant in gen_constants.values():
    code.extend(generate_constant_code(constant))
    code.append('')

  for function in gen_global_functions.values():
    code.extend(generate_global_function_code(function))
    code.append('')

  for enum in gen_enums.values():
    code.extend(generate_enum_code(enum))
    code.append('')

  for flag in gen_flags.values():
    code.extend(generate_flag_code(flag))
    code.append('')

  for struct in gen_structs.values():
    code.extend(generate_struct_code(struct))
    code.append('')

  for object in gen_objects.values():
    code.extend(generate_object_code(object))
    code.append('')

  for callback in gen_callbacks.values():
    code.extend(generate_callback_code(callback))
    code.append('')

  CHAINED_STRUCT_PREFIX = chained_struct_prefix if chained_struct_prefix else PREFIX
  code.extend(generate_chained_struct_from_native_code(gen_structs, CHAINED_STRUCT_PREFIX))
  code.append('')

  with open(UTILS_TEMPLATE, 'r') as f: utils_template = f.read()
  code.append(utils_template)

  code.append(f'// dart format on')

  out_path.write_text('\n'.join(code))


def main():
  parse()
  generate(OUT_PATH)

# endregion


if __name__ == '__main__': main()
