#!/usr/bin/env python3

import argparse
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path


###################################
# Configurations
###################################

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / "build"
DEPOT_TOOLS = BUILD / "depot_tools"
DAWN_SRC = BUILD / "dawn"
INCLUDE_DIR = ROOT / "include"

# repo urls
DEPOT_TOOLS_URL = "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
DAWN_GIT_URL = "https://dawn.googlesource.com/dawn.git"


# symbol_level=0 for production?
# use_lld=false to ensure that we produce proper archives
COMMON_GN_ARGS = '''
is_official_build = false
is_debug = {is_debug}
 
dawn_complete_static_libs = true
use_lld = false
use_custom_libcxx=false
use_allocator_shim=false
 
dawn_enable_d3d11 = false
dawn_enable_d3d12 = false
dawn_enable_desktop_gl = false
dawn_enable_opengles = false
dawn_enable_vulkan = false
dawn_enable_null = false
dawn_enable_metal = true
 
dawn_use_swiftshader = false
dawn_use_x11 = false
dawn_use_wayland = false
'''


MACOS_GN_ARGS = '''
target_os = "mac"
target_cpu = "arm64"
'''

IOS_DEVICE_GN_ARGS = '''
target_os = "ios"
target_cpu = "arm64"
ios_use_simulator = false
ios_min_target = "12.0"
'''

IOS_SIMULATOR_GN_ARGS = '''
target_os = "ios"
target_cpu = "arm64"
ios_use_simulator = true
ios_min_target = "12.0"
'''

PLATFORMS = {
  'macos': {
    'out_name': 'macos-arm64',
    'gn_args': MACOS_GN_ARGS,
  },
  'iphoneos': {
    'out_name': 'iphoneos-arm64',
    'gn_args': IOS_DEVICE_GN_ARGS,
  },
  'iphonesimulator': {
    'out_name': 'iphonesimulator-arm64',
    'gn_args': IOS_SIMULATOR_GN_ARGS,
  },
}

NINJA_TARGETS = [
  'src/dawn/native:native',
  'src/dawn:proc',
  'src/dawn/platform:platform',
]

PUBLIC_HEADER_DIRS = [
  'include',
]

GEN_INCLUDE_SUBDIR = 'gen/include'

###################################
# Build process
###################################


def tmp_dir(platform: str, config: str) -> Path: return BUILD / 'tmp' / f'{PLATFORMS[platform]["out_name"]}-{config}'
def lib_dir(platform: str, config: str) -> Path: return BUILD / PLATFORMS[platform]['out_name'] / config


def _file_human_size(p: Path) -> str:
  size = p.stat().st_size
  for u in ['B', 'KB', 'MB', 'GB']:
    if size < 1024: return f'{size:.1f}{u}'
    size /= 1024
  return f'{size:.1f}TB'


def setup_depot_tools():
  if DEPOT_TOOLS.exists():
    print('depot_tools already exists, checking for updates...')
    # subprocess.run(['git', '-C', str(DEPOT_TOOLS), 'pull'], check=False)
  else:
    print('cloning depot_tools...')
    BUILD.mkdir(parents=True, exist_ok=True)
    subprocess.run(['git', 'clone', DEPOT_TOOLS_URL, str(DEPOT_TOOLS)], check=True)

  os.environ['PATH'] = str(DEPOT_TOOLS) + os.pathsep + os.environ['PATH']
  if not (DEPOT_TOOLS / 'python3_bin_reldir.txt').exists():
    print('bootstrapping depot_tools...')
    subprocess.run(['gclient', '--version'], check=False)


def setup_dawn(branch: str, shallow: bool):
  if DAWN_SRC.exists():
    print(f'dawn source ({branch}) already exists, checking for updates...')
    subprocess.run(['git', '-C', str(DAWN_SRC), 'fetch', 'origin', branch], check=True)
    subprocess.run(['git', '-C', str(DAWN_SRC), 'checkout', branch], check=True)
    subprocess.run(['git', '-C', str(DAWN_SRC), 'reset', '--hard', f'origin/{branch}'], check=True)
  else:
    print(f'cloning dawn ({branch})...')
    cmd = ['git', 'clone']
    if shallow: cmd += ['--depth', '1']
    cmd += ['--branch', branch, DAWN_GIT_URL, str(DAWN_SRC)]
    subprocess.run(cmd, check=True)


def sync_deps(max_retries=8, base_backoff=20):
  print('syncing dawn deps...')
  
  # Copy dawn/scripts/standalone.gclient to dawn/.gclient
  gclient_file = DAWN_SRC / '.gclient'
  if not gclient_file.exists():
    src_gclient = DAWN_SRC / 'scripts' / 'standalone.gclient'
    shutil.copy2(src_gclient, gclient_file)

  for attempt in range(1, max_retries + 1):
    print(f'  attempt {attempt} of {max_retries}...')
    result = subprocess.run(['gclient', 'sync', '--no-history'], cwd=DAWN_SRC)
    if result.returncode == 0: return
 
    if attempt == max_retries:
      print('Error: failed to sync deps after maximum retries')
      sys.exit(1)
 
    wait = base_backoff * attempt
    print(f'  sync failed, retrying in {wait} seconds...')
    time.sleep(wait)


def force_export_symbols():
  print('patching GN config to force symbol exports')
  compiler_gn = DAWN_SRC / 'build' / 'config' / 'compiler' / 'BUILD.gn'
  content = compiler_gn.read_text()

  target = 'defines = []'
  replacement = 'defines = ["WGPU_SHARED_LIBRARY=1", "WGPU_IMPLEMENTATION=1"]'
  if target in content and replacement not in content:
    content = content.replace(target, replacement, count=1)
    compiler_gn.write_text(content)
    print('  patched compiler/BUILD.gn to export symbols')
  else:
    print('  config already patched or target not found, skipping')


def render_gn_args(platform: str, config: str) -> str:
  is_debug = config == 'Debug'
  common = COMMON_GN_ARGS.format(
    is_debug='true' if is_debug else 'false',
  )

  return common + '\n' + PLATFORMS[platform]['gn_args']


def gn_gen(platform: str, config: str):
  out = tmp_dir(platform, config)
  args = render_gn_args(platform, config)
  print(f'generating gn files for {platform}/{config}')
  out.parent.mkdir(parents=True, exist_ok=True)

  subprocess.run(
    ['gn', 'gen', str(out), f'--args={args}'],
    cwd=DAWN_SRC,
    check=True,
  )


def ninja_build(platform: str, config: str):
  out = tmp_dir(platform, config)
  print(f'building dawn for {platform}/{config}')
  subprocess.run(
    ['ninja', '-C', str(out), *NINJA_TARGETS],
    check=True,
  )
  print(f'dawn build for {platform}/{config} completed')


def collect_libs(platform: str, config: str):
  out = tmp_dir(platform, config)
  dst_dir = lib_dir(platform, config)
  dst_dir.mkdir(parents=True, exist_ok=True)
 
  print(f'collecting static libraries to {dst_dir.relative_to(ROOT)}...')
  archives = sorted({p for p in out.rglob('lib*_static.a')}, key=lambda p: p.name)
 
  if not archives:
    print(f'Warning: no *_static.a archives found in {out.relative_to(ROOT)}')
    print(f'  hint: gn ls {out.relative_to(ROOT)} | grep static')
    return
 
  for src in archives:
    dst = dst_dir / src.name
    if dst.exists(): dst.unlink()
    shutil.copy2(src, dst)
    print(f'  {src.name} ({_file_human_size(dst)})')



def collect_public_headers(platform: str, config: str):
  dst_root = INCLUDE_DIR
  if dst_root.exists(): shutil.rmtree(dst_root)
  dst_root.mkdir(parents=True)
 
  print(f'collecting public headers to {dst_root.relative_to(ROOT)}...')
  for d in PUBLIC_HEADER_DIRS:
    src = DAWN_SRC / d
    if not src.exists():
      print(f'Warning: header directory not found: {d}')
      continue
 
    for root, _, files in os.walk(src):
      for f in files:
        if not f.endswith('.h'): continue
        p = Path(root) / f
        rel = p.relative_to(src)
        dst = dst_root / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(p, dst)
        print(f'  {rel}')
 
  # generated headers
  out = tmp_dir(platform, config)
  gen_inc = out / GEN_INCLUDE_SUBDIR
  if not gen_inc.exists():
    print(f'Warning: generated include dir not found: {gen_inc.relative_to(ROOT)}')
    return
 
  print(f'  ...adding generated headers from {gen_inc.relative_to(ROOT)}')
  for root, _, files in os.walk(gen_inc):
    for f in files:
      if not f.endswith('.h'): continue
      p = Path(root) / f
      rel = p.relative_to(gen_inc)
      dst = dst_root / rel
      dst.parent.mkdir(parents=True, exist_ok=True)
      shutil.copy2(p, dst)
      print(f'  (gen) {rel}')
 

def clean():
  paths = [
    BUILD / 'tmp',
    INCLUDE_DIR,
  ]

  for platform in PLATFORMS:
    for config in ['Debug', 'Release']:
      paths.append(lib_dir(platform, config))

  for p in paths:
    if p.exists():
      print(f'removing {p.relative_to(ROOT)}...')
      shutil.rmtree(p)


def main():
  ap = argparse.ArgumentParser()
  ap.add_argument('platform', nargs='?', choices=list(PLATFORMS.keys()))
  ap.add_argument('--branch', default='main')
  ap.add_argument('--debug', action='store_true')
  ap.add_argument('--shallow', action='store_true')
  ap.add_argument('--clean', action='store_true')
  ap.add_argument('--skip-sync', action='store_true')

  args = ap.parse_args()
  if args.clean:
    clean()
    return

  if not args.platform:
    ap.print_help()
    return

  config = 'Debug' if args.debug else 'Release'
  start_time = time.time()

  setup_depot_tools()
  setup_dawn(args.branch, args.shallow)
  if not args.skip_sync: sync_deps()

  force_export_symbols()

  gn_gen(args.platform, config)
  ninja_build(args.platform, config)

  collect_libs(args.platform, config)
  collect_public_headers(args.platform, config)

  out_name = PLATFORMS[args.platform]['out_name']

  end_time = time.time()
  duration = end_time - start_time
  print(f'====')
  print(f'Build completed in {duration:.1f} seconds')
  print(f'output: {BUILD.relative_to(ROOT)}/')
  print(f'  static libs:     build/{out_name}/{config}/lib*.a')
  print(f'  public headers:  include/')
  print(f'  link with:       -framework Metal -framework Foundation -framework QuartzCore -framework IOSurface -framework CoreGraphics')


if __name__ == '__main__': main()
