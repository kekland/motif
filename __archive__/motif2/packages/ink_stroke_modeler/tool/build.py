#!/usr/bin/env python3

import argparse
import multiprocessing
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / 'build'
INK_SRC = BUILD / 'ink-stroke-modeler'
INCLUDE_DIR = ROOT / 'include' / 'ink_stroke_modeler'
ABSL_INCLUDE_DIR = ROOT / 'include' / 'absl'

INK_GIT_URL = 'https://github.com/google/ink-stroke-modeler.git'

COMMON_CMAKE_ARGS = [
  '-DBUILD_SHARED_LIBS=OFF',
  '-DINK_STROKE_MODELER_BUILD_TESTING=OFF',
  '-DINK_STROKE_MODELER_ENABLE_INSTALL=OFF',
  '-DINK_STROKE_MODELER_FIND_DEPENDENCIES=OFF',
]

PLATFORMS = {
  'macos': {
    'out_name': 'macos-arm64',
    'cmake_args': [
      '-DCMAKE_OSX_ARCHITECTURES=arm64',
      '-DCMAKE_OSX_DEPLOYMENT_TARGET=13.0',
    ],
  },
  'iphoneos': {
    'out_name': 'iphoneos-arm64',
    'cmake_args': [
      '-DCMAKE_SYSTEM_NAME=iOS',
      '-DCMAKE_OSX_ARCHITECTURES=arm64',
      '-DCMAKE_OSX_DEPLOYMENT_TARGET=12.0',
    ],
  },
  'iphonesimulator': {
    'out_name': 'iphonesimulator-arm64',
    'cmake_args': [
      '-DCMAKE_SYSTEM_NAME=iOS',
      '-DCMAKE_OSX_ARCHITECTURES=arm64',
      '-DCMAKE_OSX_SYSROOT=iphonesimulator',
      '-DCMAKE_OSX_DEPLOYMENT_TARGET=12.0',
    ],
  },
}


def tmp_dir(platform: str, config: str) -> Path:
  return BUILD / 'tmp' / f'{PLATFORMS[platform]["out_name"]}-{config}'


def lib_dir(platform: str, config: str) -> Path:
  return BUILD / 'lib' / f'{PLATFORMS[platform]["out_name"]}' / config


def _file_human_size(p: Path) -> str:
  size = p.stat().st_size
  for u in ['B', 'KB', 'MB', 'GB']:
    if size < 1024: return f'{size:.1f}{u}'
    size /= 1024
  return f'{size:.1f}TB'


def setup_ink(branch: str, shallow: bool):
  if INK_SRC.exists():
    print(f'ink-stroke-modeler source ({branch}) already exists, checking for updates...')
    subprocess.run(['git', '-C', str(INK_SRC), 'fetch', 'origin', branch], check=True)
    subprocess.run(['git', '-C', str(INK_SRC), 'checkout', branch], check=True)
    subprocess.run(['git', '-C', str(INK_SRC), 'reset', '--hard', f'origin/{branch}'], check=True)
  else:
    print(f'cloning ink-stroke-modeler ({branch})...')
    BUILD.mkdir(parents=True, exist_ok=True)
    cmd = ['git', 'clone']
    if shallow: cmd += ['--depth', '1']
    cmd += ['--branch', branch, INK_GIT_URL, str(INK_SRC)]
    subprocess.run(cmd, check=True)


def cmake_config(platform: str, config: str):
  out = tmp_dir(platform, config)
  print(f'generating cmake files for {platform}/{config}')
  out.mkdir(parents=True, exist_ok=True)

  cmake_cmd = ['cmake', '-S', str(INK_SRC), '-B', str(out)]
  args = COMMON_CMAKE_ARGS.copy()
  args.append(f'-DCMAKE_BUILD_TYPE={config}')
  args.extend(PLATFORMS[platform]['cmake_args'])

  # TODO: android/wasm

  subprocess.run([*cmake_cmd, *args], check=True)


def cmake_build(platform: str, config: str):
  out = tmp_dir(platform, config)
  print(f'building ink-stroke-modeler for {platform}/{config}')
  cpu_count = str(multiprocessing.cpu_count())

  subprocess.run(
    ['cmake', '--build', str(out), '--config', config, '-j', cpu_count],
    check=True,
  )

  print(f'ink-stroke-modeler build for {platform}/{config} complete')


def merge_libs(platform: str, config: str):
  dst_dir = lib_dir(platform, config)
  merged_out = dst_dir / 'libink_stroke_modeler.a'

  libs = [
    p for p in dst_dir.glob('*.a')
    if not p.name.startswith('libgtest')
    and not p.name.startswith('libgmock')
    and p.name != merged_out.name
  ]

  if not libs: return
  print(f'merging {len(libs)} static libraries into {merged_out.relative_to(ROOT)}')

  if sys.platform == 'darwin' and platform in ('macos', 'iphoneos', 'iphonesimulator'):
    cmd = ['libtool', '-static', '-o', str(merged_out)] + [str(p) for p in libs]
    subprocess.run(cmd, check=True)
    print(f'  merged {len(libs)} libs into {merged_out.name} ({_file_human_size(merged_out)})')

    for l in libs: l.unlink()
  else:
    # TODO: implement for other platforms
    raise NotImplementedError(f'merging static libraries is not implemented for platform {platform}')


def collect_libs(platform: str, config: str):
  out = tmp_dir(platform, config)
  dst_dir = lib_dir(platform, config)
  dst_dir.mkdir(parents=True, exist_ok=True)

  print(f'copying static libraries to {dst_dir.relative_to(ROOT)}')
  found = False
  for src in out.rglob('*.a'):
    dst = dst_dir / src.name
    if dst.exists(): dst.unlink()
    shutil.copy2(src, dst)
    print(f'  {src.name} ({_file_human_size(src)})')
    found = True

  if not found: print(f'Warning: no static libraries found for {platform}/{config}')


def collect_public_headers():
  dst_root = INCLUDE_DIR
  if dst_root.exists(): shutil.rmtree(dst_root)
  dst_root.mkdir(parents=True)

  print(f'collecting public headers to {dst_root.relative_to(ROOT)}')
  src_include = INK_SRC / 'ink_stroke_modeler'

  for root, _, files in os.walk(src_include):
    for f in files:
      if not f.endswith('.h'): continue
      p = Path(root) / f
      rel = p.relative_to(src_include)
      dst = dst_root / rel
      dst.parent.mkdir(parents=True, exist_ok=True)
      shutil.copy2(p, dst)
      print(f'  {rel}')


def collect_absl_headers(platform: str, config: str):
  dst_root = ABSL_INCLUDE_DIR
  if dst_root.exists(): shutil.rmtree(dst_root)
  dst_root.mkdir(parents=True)

  print(f'collecting absl headers to {dst_root.relative_to(ROOT)}')
  tmp = tmp_dir(platform, config)
  src_include = tmp / '_deps' / 'abseil-cpp-src' / 'absl'

  for root, _, files in os.walk(src_include):
    for f in files:
      if not f.endswith('.h') and not f.endswith('.inc'): continue
      p = Path(root) / f
      rel = p.relative_to(src_include)
      dst = dst_root / rel
      dst.parent.mkdir(parents=True, exist_ok=True)
      shutil.copy2(p, dst)
      print(f'  {rel}')


def clean():
  paths = [
    BUILD / 'tmp',
    INCLUDE_DIR
  ]

  for platform in PLATFORMS:
    for config in ['Debug', 'Release']:
      paths.append(lib_dir(platform, config))

  for p in paths:
    if p.exists():
      print(f'removing {p.relative_to(ROOT)}')
      shutil.rmtree(p)


def main():
  ap = argparse.ArgumentParser(description='Build ink-stroke-modeler for iOS/MacOS')
  ap.add_argument('platform', nargs='?', choices=list(PLATFORMS.keys()))
  ap.add_argument('--branch', default='main')
  ap.add_argument('--debug', action='store_true')
  ap.add_argument('--shallow', action='store_true')
  ap.add_argument('--clean', action='store_true')

  args = ap.parse_args()
  if args.clean:
    clean()
    return

  if not args.platform:
    ap.print_help()
    return

  macos_platforms = ['macos', 'iphoneos', 'iphonesimulator']
  if args.platform in macos_platforms and sys.platform != 'darwin':
    print(f'Error: platform {args.platform} can only be built on MacOS')
    return

  config = 'Debug' if args.debug else 'Release'
  start_time = time.time()

  setup_ink(args.branch, args.shallow)
  cmake_config(args.platform, config)
  cmake_build(args.platform, config)

  collect_libs(args.platform, config)
  merge_libs(args.platform, config)
  collect_public_headers()
  collect_absl_headers(args.platform, config)

  out_name = PLATFORMS[args.platform]['out_name']
  end_time = time.time()

  print(f'\n====')
  print(f'Build completed in {end_time - start_time:.1f} seconds')
  print(f'output: {BUILD.relative_to(ROOT)}/')
  print(f'  static libs:     build/{out_name}/{config}/lib*.a')
  print(f'  public headers:  include/ink_stroke_modeler/**/*.h')


if __name__ == '__main__':
  main()
