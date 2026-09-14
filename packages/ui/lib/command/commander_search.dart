part of 'command.dart';

// AI slop below
// Plan: clean the implementation, and add a pure fuzzy search if no subsequence match is found.

/// Score of [query] against [target], higher is better, null if the query isn't a subsequence.
/// Separators in the query are ignored; separators in the target are free to skip and mark the
/// next character as a word start.
int? searchScore(String query, String target) {
  final q = query.toLowerCase().replaceAll(_separators, '');
  if (q.isEmpty) return 0;
  final t = target.toLowerCase();
  final n = q.length, m = t.length;
  if (n > m) return null;

  // boundary[j]: t[j] starts a word — first char, after a separator, or a camel hump
  final boundary = List<bool>.filled(m, false);
  for (var j = 0; j < m; j++) {
    final prev = j == 0 ? null : target[j - 1];
    boundary[j] =
        j == 0 ||
        _separators.hasMatch(prev!) ||
        (prev.toLowerCase() == prev && target[j].toUpperCase() == target[j] && target[j] != t[j]);
  }

  const gap = -1, consecutive = 8, wordStart = 10, first = 4;
  // best[j]: best score with q[i] matched at t[j]; matched[j]: that match was consecutive
  var prevBest = List<int?>.filled(m, null);
  var prevMatched = List<int?>.filled(m, null);
  for (var i = 0; i < n; i++) {
    final best = List<int?>.filled(m, null);
    final matched = List<int?>.filled(m, null);
    int? carry; // best score for q[0..i-1] ending anywhere before j
    for (var j = i; j < m; j++) {
      if (i > 0 && prevBest[j - 1] != null) carry = carry == null ? prevBest[j - 1] : max(carry, prevBest[j - 1]!);
      if (t[j] != q[i] || _separators.hasMatch(t[j])) continue;
      final base = i == 0 ? 0 : carry;
      if (base == null) continue;
      var s = base + (boundary[j] ? wordStart : 0) + (i == 0 && j == 0 ? first : 0);
      if (i > 0 && prevMatched[j - 1] != null) s = max(s, prevMatched[j - 1]! + consecutive);
      s += gap * (i == 0 ? j : 0);
      matched[j] = i > 0 && prevMatched[j - 1] != null
          ? prevMatched[j - 1]! + consecutive + (boundary[j] ? wordStart : 0)
          : null;
      best[j] = s;
    }
    prevBest = best;
    prevMatched = matched;
    if (prevBest.every((v) => v == null)) return null;
  }
  return prevBest.whereType<int>().reduce(max);
}

final _separators = RegExp(r'[\s\-_/.:]');
