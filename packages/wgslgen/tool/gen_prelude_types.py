#!/usr/bin/env python3

import sys
import pathlib

ROOT = pathlib.Path(__file__).parent.parent
PRELUDE = ROOT / 'bin' / '_prelude.g.dart'
AXES = ['x', 'y', 'z', 'w']

output: list[str] = []
output.append(f'// ignore_for_file: non_constant_identifier_names, unused_element')
output.append('')
output.append(f'import \'dart:typed_data\';')
output.append('')
output.append('// dart format off')

for i in range(2, 5):
  type = f'Vec{i}f'
  body = ', '.join([f'double {AXES[j]}' for j in range(i)])

  # typedef
  output.append(f'extension type const {type}(({body}) _) {{')
  for j in range(i):
    output.append(f'  double get {AXES[j]} => _.${j + 1};')
  output.append('}')
  output.append('')

  # setter
  output.append(f'@pragma("vm:prefer-inline")')
  output.append(f'void _set_{type.lower()}({type} value, int offset, ByteData data) {{')
  for j in range(i):
    output.append(f'  data.setFloat32(offset + {j * 4}, value.{AXES[j]});')
  output.append('}')
  output.append('')

  # getter
  output.append(f'@pragma("vm:prefer-inline")')
  output.append(f'{type} _get_{type.lower()}(int offset, ByteData data) {{')
  output.append(f'  return {type}((')
  for j in range(i):
    output.append(f'    data.getFloat32(offset + {j * 4}),')
  output.append(f'  ));')
  output.append('}')
  output.append('')

for w in range(2, 5):
  for h in range(2, 5):
    l = w * h
    type = f'Mat{w}x{h}f'
    body = ', '.join(f'double m{j // h}{j % h}' for j in range(l))

    # typedef
    output.append(f'extension type const {type}(({body}) _) {{')
    for j in range(l): 
      output.append(f'  double get m{j // h}{j % h} => _.${j + 1};')
    output.append(f'  double operator [](int index) => switch (index) {{')
    for j in range(l):
      output.append(f'    {j} => _.${j + 1},')
    output.append(f'    _ => throw RangeError.index(index, this, \'index\'),')
    output.append('  };')
    output.append('}')
    output.append('')

    # setter
    output.append(f'@pragma("vm:prefer-inline")')
    output.append(f'void _set_{type.lower()}({type} value, int offset, ByteData data) {{')
    for j in range(l):
      output.append(f'  data.setFloat32(offset + {j * 4}, value.m{j // h}{j % h});')
    output.append('}')
    output.append('')

    # getter
    output.append(f'@pragma("vm:prefer-inline")')
    output.append(f'{type} _get_{type.lower()}(int offset, ByteData data) {{')
    output.append(f'  return {type}((')
    for j in range(l):
      output.append(f'    data.getFloat32(offset + {j * 4}),')
    output.append(f'  ));')
    output.append('}')
    output.append('')

output.append('// dart format on')

with open(PRELUDE, 'w') as f:
  f.write('\n'.join(output))