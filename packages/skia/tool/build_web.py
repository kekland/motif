#!/usr/bin/env python3

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / 'build'
WASM_LIB_DIR = BUILD / 'wasm' / 'Release'
INCLUDE_DIRS = [ROOT / 'include', ROOT]
ICU_DATA = BUILD / 'share' / 'icudtl.dat'
WEB_OUT_DIR = BUILD / 'web'
WEB_OUT_DIR_APP = ROOT / '..' / '..' / 'app' / 'web'

PACKAGES = ['geometry', 'text']

SKIA_LIBS = [
  'skparagraph',
  'skshaper',
  'skia',
  'skunicode_icu',
  'skunicode_core'
]


def _file_human_size(p: Path) -> str:
  size = p.stat().st_size
  for u in ['B', 'KB', 'MB', 'GB']:
    if size < 1024: return f'{size:.1f}{u}'
    size /= 1024
  return f'{size:.1f}TB'


def find_emcc() -> str:
  skia_emsdk = BUILD / 'skia' / 'third_party' / 'externals' / 'emsdk'
  emcc = skia_emsdk / 'upstream' / 'emscripten' / 'emcc'
  if not emcc.exists(): raise Exception(f'emcc not found: {emcc}')
  return str(emcc)


def collect_package_sources() -> tuple[list[Path], list[Path], list[Path]]:
  sources: list[Path] = []
  headers: list[Path] = []
  include_dirs: list[Path] = []

  for package in PACKAGES:
    src_dir = (ROOT / '..' / package / 'src').resolve()
    include_dirs.append(src_dir)
    for p in src_dir.rglob('*'):
      if not p.is_file(): continue
      ext = p.suffix.lower()

      if ext in ('.cpp', '.c', '.cc'): sources.append(p)
      elif ext in ('.h', '.hpp'): headers.append(p)

  sources.sort()
  headers.sort()
  include_dirs.sort()
  return sources, headers, include_dirs


def parse_exports(headers: list[Path]) -> list[str]:
  exports = set()

  # FFI {return_type} {name}({args});
  ffi_pattern = re.compile(
    r'\bFFI\s+([\w\s\*&]+?)\s+(\w+)\s*\(([^)]*)\)\s*;',
    re.MULTILINE | re.DOTALL,
  )

  for h in headers:
    text = h.read_text()
    for match in ffi_pattern.finditer(text):
      return_type, name, args = match.groups()
      exports.add(name)

  exports.update({'malloc', 'free'})
  return sorted('_' + e for e in exports)


def run_emcc(emcc: str, sources: list[Path], include_dirs: list[Path], exports: list[str], debug: bool):
  if not WASM_LIB_DIR.exists():
    raise Exception(f'WASM library directory not found: {WASM_LIB_DIR}')

  for lib in SKIA_LIBS:
    p = WASM_LIB_DIR / f'lib{lib}.a'
    if not p.exists(): raise Exception(f'Library not found: {p}')

  WEB_OUT_DIR.mkdir(parents=True, exist_ok=True)
  out_js = WEB_OUT_DIR / 'skia.js'
  exportName = 'createSkiaModule'

  cmd: list[str] = [emcc]

  cmd += [
    '-std=c++17',
    '-fno-rtti',
    '-fvisibility=hidden',
    '-fvisibility-inlines-hidden',
  ]

  cmd += ['-O0', '-g3'] if debug else ['-O3']

  for d in INCLUDE_DIRS:
    if d.exists(): cmd += ['-I', str(d)]

  for d in include_dirs:
    cmd += ['-I', str(d)]

  cmd += [str(s) for s in sources]
  cmd += [str(WASM_LIB_DIR / f'lib{lib}.a') for lib in SKIA_LIBS]

  cmd += [
    '--no-entry',
    '-s', 'WASM=1',
    '-s', 'MODULARIZE=1',
    '-s', f'EXPORT_NAME={exportName}',
    '-s', 'ALLOW_MEMORY_GROWTH=1',
    '-s', 'ENVIRONMENT=web,worker',
    '-s', 'DYNAMIC_EXECUTION=0',
    '-s', 'EXPORTED_RUNTIME_METHODS=' + str([
      'ccall', 'cwrap',
      'HEAP8', 'HEAPU8',
      'HEAP16', 'HEAPU16',
      'HEAP32', 'HEAPU32',
      'HEAPF32', 'HEAPF64',
      'getValue', 'setValue',
      'lengthBytesUTF8', 'stringToUTF8', 'UTF8ToString',
    ]).replace("'", '"'),
    '-s', 'EXPORTED_FUNCTIONS=' + str(exports).replace("'", '"'),
  ]

  if debug: cmd += ['-s', 'ASSERTIONS=1', '-s', 'SAFE_HEAP=1']

  if ICU_DATA.exists():
    cmd += ['--embed-file', f'{ICU_DATA}@icudtl.dat']
  else:
    print(f'Warning: ICU data file not found: {ICU_DATA}')

  cmd += ['-o', str(out_js)]

  subprocess.run(cmd, check=True)
  out_wasm = out_js.with_suffix('.wasm')
  if out_wasm.exists(): print(f'WASM module generated: {out_wasm.relative_to(ROOT)} ({_file_human_size(out_wasm)})')
  if out_js.exists(): print(f'JS wrapper generated: {out_js.relative_to(ROOT)} ({_file_human_size(out_js)})')


def clean():
  if WEB_OUT_DIR.exists():
    shutil.rmtree(WEB_OUT_DIR)
    print(f'Cleaned web output directory: {WEB_OUT_DIR.relative_to(ROOT)}')


def main():
  ap = argparse.ArgumentParser()
  ap.add_argument('--debug', action='store_true')
  ap.add_argument('--clean', action='store_true')
  args = ap.parse_args()

  if args.clean:
    clean()
    return

  emcc = find_emcc()
  sources, headers, include_dirs = collect_package_sources()
  if not sources:
    print('No source files found. Nothing to build.')
    return

  exports = parse_exports(headers)
  run_emcc(emcc, sources, include_dirs, exports, args.debug)

  # copy to app/web
  shutil.copytree(WEB_OUT_DIR, WEB_OUT_DIR_APP, dirs_exist_ok=True)


if __name__ == '__main__':
  main()
