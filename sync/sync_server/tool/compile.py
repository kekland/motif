#!/usr/bin/env python3

import subprocess
import shlex
import pathlib
import sys
import yaml

PACKAGE_ROOT = pathlib.Path(__file__).parent.parent
DOCKERFILE = PACKAGE_ROOT / 'tool' / 'Dockerfile'
ROOT = PACKAGE_ROOT.parent.parent
PACKAGE_REL = PACKAGE_ROOT.relative_to(ROOT)

BUILD = PACKAGE_ROOT / 'build'
OUT = BUILD / 'linux_x64'

IMAGE = 'motif-server-build'
PLATFORM = 'linux/amd64'

subprocess.run([
  'docker', 'build', '--platform', PLATFORM, '-t', IMAGE,
  '-f', str(DOCKERFILE),
  str(PACKAGE_ROOT / 'tool')
], check=True)

OUT.mkdir(parents=True, exist_ok=True)

script = f'''
set -e
rsync -a --delete --exclude .dart_tool --exclude build --exclude .fvm /src/ /work/
cd /work
fvm install
cd {PACKAGE_REL}
fvm flutter pub get
fvm dart build cli --target bin/main.dart --output /build/linux_x64
'''

subprocess.run([
  'docker', 'run', '--rm', '--platform', PLATFORM,
  '-v', f'{ROOT}:/src:ro',
  '-v', f'{BUILD}:/build',
  '-v', f'motif-pub-cache:/root/.pub-cache',
  '-v', f'motif-fvm-cache:/fvm-cache',
  IMAGE, 'sh', '-c', script
], check=True)

print(f'Build {PLATFORM} completed in {OUT}')