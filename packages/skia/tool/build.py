#!/usr/bin/env python3

import subprocess
from pathlib import Path

TOOL = Path(__file__).resolve().parent

subprocess.run(['python3', TOOL / 'build_skia.py', 'macos'])
subprocess.run(['python3', TOOL / 'build_skia.py', 'wasm'])

subprocess.run(['python3', TOOL / 'build_web.py'])

subprocess.run(['dart', TOOL / 'generate_bindings.dart'])