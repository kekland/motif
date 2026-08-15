#!/usr/bin/env python3

import subprocess
import shlex
import pathlib
import sys

root = pathlib.Path(__file__).parent.parent


def exec_cmd(cmd, cwd=None):
  try:
    subprocess.run(cmd, check=True, shell=True, cwd=cwd if cwd != None else root)
  except subprocess.CalledProcessError as e:
    print(f'Error running command: {cmd}')
    print(e)
    raise


darwin_src = root / 'darwin' / 'native' / 'Sources' / 'native_darwin'
ios_src = root / 'darwin' / 'native' / 'Sources' / 'native_ios'
macos_src = root / 'darwin' / 'native' / 'Sources' / 'native_macos'


def get_src(platform: str):
  if platform == 'ios': return ios_src
  elif platform == 'macos': return macos_src
  elif platform == 'darwin': return darwin_src
  else: raise ValueError(f'Unknown platform: {platform}')


def compile_objc_headers(platform: str):
  src = get_src(platform)
  build_folder = root / 'build' / 'ffigen' / platform
  build_folder.mkdir(parents=True, exist_ok=True)

  output = build_folder / f'native_{platform}_Swift.h'

  files = list(src.glob('**/*.swift'))
  joined_files = ' '.join([file.as_posix() for file in files])

  if not files:
    print(f'No Swift files found for platform {platform} in {src}')
    return

  exec_cmd(f'swiftc -c {joined_files} -module-name native_{platform} -emit-objc-header-path {output}', cwd=build_folder)


compile_objc_headers('ios')
compile_objc_headers('macos')
compile_objc_headers('darwin')

exec_cmd('fvm dart run ffigen --config ffigen.ios.yaml')
exec_cmd('fvm dart run ffigen --config ffigen.macos.yaml')
exec_cmd('fvm dart run ffigen --config ffigen.darwin.yaml')
