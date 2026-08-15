#!/usr/bin/env python3

import subprocess
import shlex
import pathlib
import sys

root = pathlib.Path(__file__).parent.parent
proto_path = root
out = root / 'lib' / 'gen'


def exec_cmd(cmd, cwd=None):
  try:
    subprocess.run(cmd, check=True, shell=True, cwd=cwd if cwd != None else root)
  except subprocess.CalledProcessError as e:
    print(f'Error running command: {cmd}')
    print(e)
    raise

exec_cmd(f'protoc --dart_out="grpc:{out}" --proto_path={proto_path} schema.proto scene.proto')