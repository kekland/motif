#!/usr/bin/env python3

import subprocess
import shlex
import pathlib
import sys
import yaml

ROOT = pathlib.Path(__file__).parent.parent

IGNORE_FILE = ROOT / '.ignore'

subprocess.run(  
  f"git ls-files | git check-attr --stdin linguist-vendored linguist-generated | grep -E '(set|true)$' | cut -d: -f1 | sort -u > {IGNORE_FILE}",
  shell=True,
  check=True,
  cwd=ROOT
)

# read pubspec.yaml
pubspec_file = ROOT / 'pubspec.yaml'
with open(pubspec_file, 'r') as f:
  pubspec = yaml.safe_load(f)

packages = pubspec.get('workspace')
for package in packages:
  print(f'=============================================')
  print(f'{package}')
  print(f'=============================================')
  print('')
  subprocess.run(
    f"loc {ROOT / package}",
    shell=True,
    check=True,
    cwd=ROOT
  )
  print('')

print('')
print(f'=============================================')
print(f'Total')
print(f'=============================================')
print('')
subprocess.run(
  f"loc",
  shell=True,
  check=True,
  cwd=ROOT
)
print('')

IGNORE_FILE.unlink(missing_ok=True)