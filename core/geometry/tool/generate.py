#!/usr/bin/env python3

import subprocess
import shlex
import pathlib
import sys
import re

ROOT = pathlib.Path(__file__).parent.parent
CODE_DIR = ROOT / 'lib' / 'core'
OUT_DIR = ROOT / 'lib' / 'gen'
OUT_32 = OUT_DIR / 'geometry_32.g.dart'
OUT_64 = OUT_DIR / 'geometry_64.g.dart'

prelude_32 = [
  f'import \'dart:math\' as math;',
  f'import \'dart:typed_data\';',
  f'',
  f'import \'package:shared/shared.dart\';',
  f'import \'package:geometry/geometry_32.dart\';',
]

prelude_64 = [
  f'import \'dart:math\' as math;',
  f'import \'dart:typed_data\';',
  f'',
  f'import \'package:shared/shared.dart\';',
  f'import \'package:geometry/geometry_64.dart\';',
]

# find all files ending in *_impl.dart
impl_files = list(CODE_DIR.rglob('*_impl.dart'))
impl_code: list[list[str]] = []

part_regex = re.compile(r'part\s+\'([^\']+)\';')
part_of_re = re.compile(r'part of\s+\'([^\']+)\';')

for impl_file in impl_files:
  impl_dir = impl_file.parent
  content = impl_file.read_text().splitlines()

  # strip all imports
  content = [line for line in content if not line.startswith('import ')]

  # include parts
  for line in content:
    match = part_regex.match(line)
    if not match: continue
    part_file = impl_dir / match.group(1)
    if part_file.exists():
      content.extend(part_file.read_text().splitlines())

  # remove part directives from content
  content = [line for line in content if not part_regex.match(line) and not part_of_re.match(line)]

  impl_code.append(content)

OUT_DIR.mkdir(parents=True, exist_ok=True)

impl_code_body = [l for content in impl_code for l in content]

out_32_content = prelude_32 + impl_code_body
out_64_content = prelude_64 + impl_code_body

OUT_32.write_text('\n'.join(out_32_content))
OUT_64.write_text('\n'.join(out_64_content))