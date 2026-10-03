#!/usr/bin/env python3

import subprocess
import shlex
import pathlib
import sys

package_root = pathlib.Path(__file__).parent.parent
root = package_root.parent.parent
proto_path = root
out = package_root / 'lib' / 'gen'

protos = [
  root / 'sync' / 'sync' / 'sync.proto',
  root / 'core' / 'program' / 'program.proto',
  root / 'core' / 'asset' / 'asset.proto',
  root / 'packages' / 'skia' / 'skia.proto',
]


def exec_cmd(cmd, cwd=None):
  try:
    subprocess.run(cmd, check=True, shell=True, cwd=cwd if cwd != None else root)
  except subprocess.CalledProcessError as e:
    print(f'Error running command: {cmd}')
    print(e)
    raise

exec_cmd(f'protoc --dart_out="{out}" --proto_path={proto_path} {" ".join(str(p) for p in protos)}')


# exec_cmd(f'protoc --dart_out="grpc:{out}" --proto_path={proto_path} program.proto server.proto')
# # exec_cmd(f'protoc --descriptor_set_out={out}/program.desc --proto_path={proto_path} program.proto')
