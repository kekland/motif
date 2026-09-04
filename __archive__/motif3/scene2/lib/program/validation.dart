part of 'program.dart';

final class ProgramIssue(
  final StatementId statement,
  final String message,
) implements Exception {
  @override
  String toString() => 'statement $statement: $message';
}

extension ProgramValidation on Program {
  bool _assertValidate() {
    assert(validate().isEmpty, 'program validation failed');
    return true;
  }

  List<ProgramIssue> validate() {
    final issues = <ProgramIssue>[];
    final indices = {for (var i = 0; i < length; i++) this[i].id: i};

    final owners = <Ref, StatementId>{};
    for (final s in statements) {
      for (final arg in s.args) {
        if (arg is! Own) continue;
        final prev = owners[arg.ref];
        if (prev != null && prev != s.id) {
          issues.add(.new(s.id, 'owns ${arg.ref} but it is already owned by $prev'));
        } else {
          owners[arg.ref] = s.id;
        }
      }
    }

    for (var i = 0; i < length; i++) {
      final s = this[i];
      for (final arg in s.args) {
        final ref = arg.ref;
        if (ref.statement == s.id) continue;

        final p = indices[ref.statement];
        if (p == null) {
          issues.add(.new(s.id, 'arg $ref references unknown statement'));
          continue;
        }

        if (p >= i) {
          issues.add(.new(s.id, 'arg $ref references statement that comes after it'));
          continue;
        }

        if (arg is Borrow) {
          final owner = owners[ref];
          if (owner != null && owner != s.id) {
            final w = indices[owner];
            if (w != null && w < i) {
              issues.add(.new(s.id, 'arg $ref is borrowed after consumption by $owner'));
            }
          }
        }
      }
    }

    return issues;
  }
}
