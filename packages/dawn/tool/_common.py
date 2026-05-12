import subprocess
import shlex
import pathlib
import sys

root = pathlib.Path(__file__).parent.parent

digits = {
  '0': 'zero',
  '1': 'one',
  '2': 'two',
  '3': 'three',
  '4': 'four',
  '5': 'five',
  '6': 'six',
  '7': 'seven',
  '8': 'eight',
  '9': 'nine',
}


def exec_cmd(cmd, cwd=None):
  try:
    subprocess.run(cmd, check=True, shell=True, cwd=cwd if cwd != None else root)
  except subprocess.CalledProcessError as e:
    print(f'Error running command: {cmd}')
    print(e)
    raise


def to_upper_camel_case(s: str) -> str:
  parts = s.split('_')
  camel_case = ''.join(part[0].upper() + part[1:] for part in parts)
  if camel_case and camel_case[0] in digits:
    camel_case = digits[camel_case[0]] + camel_case[1:]
  return camel_case


def to_lower_camel_case(s: str) -> str:
  camel_case = to_upper_camel_case(s)
  if camel_case: camel_case = camel_case[0].lower() + camel_case[1:]
  return camel_case
