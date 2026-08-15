import subprocess
import shlex
import pathlib
import sys
from typing import Union

ROOT = pathlib.Path(__file__).parent.parent


def exec_cmd(cmd, cwd=None):
  try:
    subprocess.run(cmd, check=True, shell=True, cwd=cwd if cwd != None else ROOT)
  except subprocess.CalledProcessError as e:
    print(f'Error running command: {cmd}')
    print(e)
    raise


def to_upper_camel_case(s: str) -> str:
  parts = s.split('_')
  camel_case = ''.join(part[0].upper() + part[1:].lower() if len(part) > 0 else '_' for part in parts)
  return camel_case


def to_lower_camel_case(s: str) -> str:
  camel_case = to_upper_camel_case(s)
  if camel_case: camel_case = camel_case[0].lower() + camel_case[1:]
  return camel_case


def indent(lines: Union[str, list[str]], level: int = 1, indent_str: str = '  ') -> Union[str, list[str]]:
  indent_prefix = indent_str * level
  if isinstance(lines, str): return indent_prefix + lines
  return [indent_prefix + line if line else '' for line in lines]
