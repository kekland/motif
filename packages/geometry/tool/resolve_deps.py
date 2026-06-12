#!/usr/bin/env python3

import os
from pathlib import Path

ROOT = Path(__file__).parent.parent
EIGEN_OUT_DIR = ROOT / 'third_party' / 'eigen'

EIGEN_GIT_URL = 'https://gitlab.com/libeigen/eigen.git'
EIGEN_GIT_TAG = '5.0.1'

def download_eigen():
  if EIGEN_OUT_DIR.exists(): 
    print(f'Eigen already exists at {EIGEN_OUT_DIR}, skipping download.')
    return

  print(f'Cloning Eigen from {EIGEN_GIT_URL} (tag: {EIGEN_GIT_TAG})...')
  os.system(f'git clone --depth 1 --branch {EIGEN_GIT_TAG} {EIGEN_GIT_URL} {EIGEN_OUT_DIR}')

def main():
  download_eigen()

if __name__ == '__main__':
  main()
