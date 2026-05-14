#!/usr/bin/env python3

from _common import ROOT

OUT_FILE = ROOT / 'lib' / 'src' / 'wgsl' / 'types.g.dart'

output: list[str] = []
output.append(f'// ignore_for_file: non_constant_identifier_names, unused_element')
output.append('')
output.append(f'part of \'wgsl.dart\';')
output.append('')
output.append('// dart format off')

_prefer_inline = '@pragma(\'vm:prefer-inline\')'

def get_type_dart_type(type: str) -> str:
  if type == 'f32': return 'double'
  if type == 'f16': return 'double'
  if type == 'i32': return 'int'
  if type == 'u32': return 'int'

def get_type_short(type: str) -> str:
  if type == 'f32': return 'f'
  if type == 'f16': return 'h'
  if type == 'i32': return 'i'
  if type == 'u32': return 'u'

def get_type_byte_data_type(type: str) -> str:
  if type == 'f32': return 'Float32'
  if type == 'f16': return 'Float16'
  if type == 'i32': return 'Int32'
  if type == 'u32': return 'Uint32'

# scalars
SCALAR_TYPES = ['f32', 'i32', 'u32', 'f16']
for i in range(len(SCALAR_TYPES)):
  type = SCALAR_TYPES[i]
  type_short = get_type_short(type)
  dart_type = get_type_dart_type(type)
  byte_data_type = get_type_byte_data_type(type)

  output.append(f'extension type const {type.upper()}({dart_type} _) implements {dart_type} {{')
  output.append(f'  static const {type.upper()} zero = {type.upper()}(0);')
  output.append(f'')
  output.append(f'  {_prefer_inline}')
  output.append(f'  {type.upper()}.from({dart_type} v): this(v);')
  output.append(f'')
  output.append(f'  {_prefer_inline}')
  output.append(f'  {type.upper()}.read(ByteData data, int offset): this(data.get{byte_data_type}(offset, .little));')
  output.append('')
  output.append(f'  {_prefer_inline}')
  output.append(f'  void write(ByteData data, int offset) => data.set{byte_data_type}(offset, _, .little);')
  output.append(f'}}')
  output.append(f'')


# vec types
VEC_LEN = [2, 3, 4]
VEC_TYPES = ['f32', 'i32', 'u32', 'f16']
VEC_ACCESSORS = ['x', 'y', 'z', 'w']

for i in range(len(VEC_TYPES)):
  type = VEC_TYPES[i]
  type_short = get_type_short(type)
  dart_type = get_type_dart_type(type)
  byte_data_type = get_type_byte_data_type(type)
  scalar = type.upper()

  for vec_len in VEC_LEN:
    vm_type = f'Vector{vec_len}'

    tuple = ', '.join([dart_type] * vec_len)
    type_name = f'Vec{vec_len}{type_short}'
    output.append(f'extension type const {type_name}(({tuple}) _) {{')

    zero_tuple = ', '.join(['0'] * vec_len)

    # zero
    output.append(f'  static const {type_name} zero = {type_name}(({zero_tuple}));')
    output.append('')

    # accessor
    for j in range(vec_len):
      output.append(f'  {scalar} get {VEC_ACCESSORS[j]} => {scalar}(_.${j + 1});')
    output.append('')

    # from vector_math
    output.append(f'  {_prefer_inline}')
    output.append(f'  {type_name}.fromVector32(vm32.{vm_type} v): this((')
    for j in range(vec_len):
      cast = '.toInt()' if type in ['i32', 'u32'] else ''
      output.append(f'    v.{VEC_ACCESSORS[j]}{cast},')
    output.append(f'  ));')
    output.append(f'')
    output.append(f'  {_prefer_inline}')
    output.append(f'  {type_name}.fromVector64(vm64.{vm_type} v): this((')
    for j in range(vec_len):
      cast = '.toInt()' if type in ['i32', 'u32'] else ''
      output.append(f'    v.{VEC_ACCESSORS[j]}{cast},')
    output.append(f'  ));')
    output.append(f'')

    # to vector_math
    output.append(f'  {_prefer_inline}')
    output.append(f'  vm32.{vm_type} toVector32() => vm32.{vm_type}(')
    for j in range(vec_len):
      cast = '.toDouble()' if type in ['i32', 'u32'] else ''
      output.append(f'    _.${j + 1}{cast},')
    output.append(f'  );')
    output.append(f'')
    output.append(f'  {_prefer_inline}')
    output.append(f'  vm64.{vm_type} toVector64() => vm64.{vm_type}(')
    for j in range(vec_len):
      cast = '.toDouble()' if type in ['i32', 'u32'] else ''
      output.append(f'    _.${j + 1}{cast},')
    output.append(f'  );')
    output.append(f'')

    # read
    output.append(f'  {_prefer_inline}')
    output.append(f'  {type_name}.read(ByteData data, int offset): this((')
    for j in range(vec_len):
      output.append(f'    data.get{byte_data_type}(offset + {j * 4}, .little),')
    output.append(f'  ));')
    output.append(f'')

    # write
    output.append(f'  {_prefer_inline}')
    output.append(f'  void write(ByteData data, int offset) {{')
    for j in range(vec_len):
      output.append(f'    data.set{byte_data_type}(offset + {j * 4}, _.${j + 1}, .little);')
    output.append(f'  }}')
    output.append(f'}}')
    output.append(f'')

# mat types
MAT_LEN = [2, 3, 4]
MAT_TYPES = ['f32', 'f16']

for i in range(len(MAT_TYPES)):
  type = MAT_TYPES[i]
  type_short = get_type_short(type)
  dart_type = get_type_dart_type(type)
  byte_data_type = get_type_byte_data_type(type)
  scalar = type.upper()

  for w in MAT_LEN:
    for h in MAT_LEN:
      if w == h: vm_type = f'Matrix{w}'
      else: vm_type = None
    
      mat_len = w * h
      tuple = ', '.join([dart_type] * mat_len)
      type_name = f'Mat{w}x{h}{type_short}'
      output.append(f'extension type const {type_name}(({tuple}) _) {{')

      # identity
      identity_tuple = []
      for x in range(w):
        for y in range(h):
          identity_tuple.append('1' if x == y else '0')
      identity_tuple_str = ', '.join(identity_tuple)
      output.append(f'  static const {type_name} identity = {type_name}(({identity_tuple_str}));')
      output.append('')

      # accessor
      for x in range(w):
        for y in range(h):
          output.append(f'  {scalar} get m{x}{y} => {scalar}(_.${x * h + y + 1});')
      output.append('')

      # array-style accessor
      output.append(f'  {_prefer_inline}')
      output.append(f'  {scalar} operator [](int index) => switch (index) {{')
      for i in range(mat_len):
        output.append(f'    {i} => {scalar}(_.${i + 1}),')
      output.append(f'    _ => throw RangeError.index(index, this, \'index\'),')
      output.append(f'  }};')
      output.append('')

      if vm_type is not None:
        # from vector_math
        output.append(f'  {_prefer_inline}')
        output.append(f'  {type_name}.fromMatrix32(vm32.{vm_type} v): this((')
        for j in range(mat_len):
          cast = '.toInt()' if type in ['i32', 'u32'] else ''
          output.append(f'    v[{j}]{cast},')
        output.append(f'  ));')
        output.append(f'')
        output.append(f'  {_prefer_inline}')
        output.append(f'  {type_name}.fromMatrix64(vm64.{vm_type} v): this((')
        for j in range(mat_len):
          cast = '.toInt()' if type in ['i32', 'u32'] else ''
          output.append(f'    v[{j}]{cast},')
        output.append(f'  ));')
        output.append(f'')

        # to vector_math
        output.append(f'  {_prefer_inline}')
        output.append(f'  vm32.{vm_type} toMatrix32() => vm32.{vm_type}(')
        for j in range(mat_len):
          cast = '.toDouble()' if type in ['i32', 'u32'] else ''
          output.append(f'    _.${j + 1}{cast},')
        output.append(f'  );')
        output.append(f'')
        output.append(f'  {_prefer_inline}')
        output.append(f'  vm64.{vm_type} toMatrix64() => vm64.{vm_type}(')
        for j in range(mat_len):
          cast = '.toDouble()' if type in ['i32', 'u32'] else ''
          output.append(f'    _.${j + 1}{cast},')
        output.append(f'  );')
        output.append(f'')

      # read
      output.append(f'  {_prefer_inline}')
      output.append(f'  {type_name}.read(ByteData data, int offset): this((')
      for i in range(mat_len):
        output.append(f'    data.get{byte_data_type}(offset + {i * 4}, .little),')
      output.append(f'  ));')
      output.append(f'')

      # write
      output.append(f'  {_prefer_inline}')
      output.append(f'  void write(ByteData data, int offset) {{')
      for i in range(mat_len):
        output.append(f'    data.set{byte_data_type}(offset + {i * 4}, _.${i + 1}, .little);')
      output.append(f'  }}')
      output.append(f'}}')
      output.append(f'')

with open(OUT_FILE, 'w') as f:  f.write('\n'.join(output))