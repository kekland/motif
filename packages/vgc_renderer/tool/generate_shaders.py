#!/usr/bin/env python3

import os
import pathlib
import subprocess

ROOT = pathlib.Path(__file__).parent.parent
print(ROOT)

SHADERS_DIR = ROOT / 'shaders'
OUT_DIR = ROOT / 'lib' / 'src' / 'shaders'

processes = []
for shader_path in SHADERS_DIR.glob('*.wgsl'):
  shader_name = shader_path.stem
  out_path = OUT_DIR / f'{shader_name}.g.dart'

  shader_code = shader_path.read_text()
  # Only generate shader code if it has an entry point.
  if not any(k in shader_code for k in ['@vertex', '@fragment', '@compute']): continue

  print(f'generating {out_path} from {shader_path}...')
  p = subprocess.Popen(f'fvm dart run wgslgen {shader_path} -o {out_path}', shell=True)
  processes.append(p)

for p in processes:
  p.wait()
