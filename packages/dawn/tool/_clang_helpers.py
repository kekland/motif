import clang.cindex


def has_doc_comment_lines(node: clang.cindex.Cursor) -> bool:
  return len(get_doc_comment_lines(node)) > 0


def get_doc_comment_lines(node: clang.cindex.Cursor) -> list[str]:
  doc_comment = node.raw_comment
  if not doc_comment: return []

  # Split the comment into lines and clean up comment markers.
  lines = doc_comment.splitlines()
  cleaned_lines = []

  for line in lines:
    line = line.strip()

    if line.startswith('//'): line = line[2:]
    elif line.startswith('/**'): line = line[3:]
    elif line.startswith('/*'): line = line[2:]
    elif line.endswith('*/'): line = line[:-2]
    elif line.startswith('*'): line = line[1:]

    line = line.strip()

    if line: cleaned_lines.append(line)
    elif cleaned_lines: cleaned_lines.append('')

  while cleaned_lines and cleaned_lines[-1] == '': cleaned_lines.pop()
  return cleaned_lines


def indent(lines: list[str], level: int = 1, indent_str: str = '  ') -> list[str]:
  indent_prefix = indent_str * level
  return [indent_prefix + line if line else '' for line in lines]


def get_dart_comment_lines(node: clang.cindex.Cursor) -> list[str]:
  doc_lines = get_doc_comment_lines(node)
  dart_lines = ['/// ' + line for line in doc_lines]
  return dart_lines
