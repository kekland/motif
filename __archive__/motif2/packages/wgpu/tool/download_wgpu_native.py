#!/usr/bin/env python3

from _common import ROOT

import argparse
import os
import shutil
import subprocess
import sys
import time
import urllib.request
import zipfile
from pathlib import Path

# region Config

WGPU_NATIVE_REPO = "https://github.com/gfx-rs/wgpu-native"
WGPU_NATIVE_TAG = "v29.0.0.0"
RELEASE = True
PLATFORMS = {
  'macos-arm64': 'macos-aarch64',
  'macos-x64': 'macos-x86_64',
  'iphoneos-arm64': 'ios-aarch64',
  'iphonesimulator-arm64': 'ios-aarch64-simulator',
}

CONFIG = 'release' if RELEASE else 'debug'
RELEASE_BASE = f'https://github.com/gfx-rs/wgpu-native/releases/download/{WGPU_NATIVE_TAG}'

BUILD = ROOT / 'build'
WEBGPU_SPEC = BUILD / 'webgpu.yml'
WEBGPU_INCLUDES = BUILD / 'include'

# endregion

# region Utils


def download(url: str, dst: Path):
  if dst.exists():
    print(f'  cached: {dst.relative_to(ROOT)}')
    return

  tmp = dst.with_suffix(dst.suffix + '.tmp')
  print(f'  downloading: {url} -> {dst.relative_to(ROOT)}')
  with urllib.request.urlopen(url) as r, open(tmp, 'wb') as f:
    shutil.copyfileobj(r, f)
  tmp.rename(dst)


def extract_archive(zip_path: Path, dst: Path):
  if dst.exists(): shutil.rmtree(dst)
  dst.mkdir(parents=True)
  print(f'  extracting: {zip_path.name} -> {dst.relative_to(ROOT)}')
  with zipfile.ZipFile(zip_path) as z: z.extractall(dst)

# endregion

# region Main


def main():
  BUILD.mkdir(exist_ok=True)
  archives_dir = BUILD / '_archives'
  archives_dir.mkdir(exist_ok=True)

  first_platform_dir = None

  for name, remote_name in PLATFORMS.items():
    print(f'processing {name} ({remote_name})')
    archive_name = f'wgpu-{remote_name}-{CONFIG}.zip'
    archive_path = archives_dir / archive_name
    download(f'{RELEASE_BASE}/{archive_name}', archive_path)

    archive_unzipped_dir = archives_dir / archive_name.split('.')[0]
    extract_archive(archive_path, archive_unzipped_dir)
    if first_platform_dir is None: first_platform_dir = archive_unzipped_dir

    # Copy the libraries
    libraries_dir = archive_unzipped_dir / 'lib'
    platform_dir = BUILD / f'{name}-{CONFIG}'
    if platform_dir.exists(): shutil.rmtree(platform_dir)
    shutil.copytree(libraries_dir, platform_dir)
    print(f'  copied libraries -> {platform_dir.relative_to(ROOT)}')

  if first_platform_dir is None:
    print('no platforms processed')
    sys.exit(1)

  # Copy includes
  src_include = first_platform_dir / 'include' / 'webgpu'
  if WEBGPU_INCLUDES.exists(): shutil.rmtree(WEBGPU_INCLUDES)
  shutil.copytree(src_include, WEBGPU_INCLUDES)
  print(f'  copied includes -> {WEBGPU_INCLUDES.relative_to(ROOT)}')

  # Copy spec
  src_spec = first_platform_dir / 'wgpu-native-meta' / 'webgpu.yml'
  if WEBGPU_SPEC.exists(): WEBGPU_SPEC.unlink()
  shutil.copy(src_spec, WEBGPU_SPEC)
  print(f'  copied spec -> {WEBGPU_SPEC.relative_to(ROOT)}')


def clean():
  if BUILD.exists(): shutil.rmtree(BUILD)
  print(f'cleaned {BUILD.relative_to(ROOT)}')

# endregion


if __name__ == '__main__':
  ap = argparse.ArgumentParser()
  ap.add_argument('--clean', action='store_true')

  args = ap.parse_args()
  if args.clean:
    clean()
  else:
    main()
