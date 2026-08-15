#!/usr/bin/env python3

import subprocess
from pathlib import Path

ROOT = Path(__file__).parent.parent

subprocess.run(['dart', 'run', 'ffigen', '--config', 'ffigen.yaml'], check=True, cwd=ROOT)
