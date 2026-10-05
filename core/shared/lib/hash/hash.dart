import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:shared/shared.dart';

extension type const Hash._(String value) {
  const Hash.raw(String value) : this._(value);

  static Hash compute(Uint8List data) {
    return ._(crypto.sha256.convert(data).toString());
  }

  static Hash combine(String kind, Iterable<Hash> hashes) {
    final combined = [kind, ...hashes.map((h) => h.value)..sorted()];
    final joined = combined.join('\n');
    return compute(utf8.encode(joined));
  }

  String get shortHash => value.substring(0, 8);
}
