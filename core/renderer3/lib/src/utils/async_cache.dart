import 'dart:async';

import 'package:state/state.dart';

int _defaultSizeOf(dynamic value) => 1;

final class LruAsyncCache<K, P, V> with ChangeNotifier, ChangeNotifierDisposable {
  LruAsyncCache(
    this.load, {
    this.compare = identityEquals,
    this.onResolve,
    this.onDispose,
    this.sizeOf = _defaultSizeOf,
    this.maxSize = -1,
    String? label,
  }) : _logger = .new(label != null ? 'LruAsyncCache<$label>' : 'LruAsyncCache');

  final Future<V?> Function(K, P) load;
  final bool Function(P, P) compare;
  final void Function(Object)? onResolve;
  final void Function(V)? onDispose;
  final int Function(V) sizeOf;
  final int maxSize;
  final Logger _logger;

  var _token = 0;
  var _currentSize = 0;
  final _inProgress = <K, (int, P, Future<V?>, Set<Object>)>{};
  final _cache = <K, (P, V?, int)>{};

  Iterable<V> get values => _cache.values.map((e) => e.$2).whereType<V>();

  V? get(K key, P param, {Object? updateToken}) {
    final cached = _cache[key];
    if (cached != null) {
      // move to top
      _cache.remove(key);
      _cache[key] = cached;

      final (oldParam, value, _) = cached;
      if (!compare(oldParam, param)) _schedule(key, param, updateToken);
      return value;
    }

    _schedule(key, param, updateToken);
    return null;
  }

  void _schedule(K key, P param, Object? updateToken) {
    final inProgress = _inProgress[key];
    if (inProgress != null) {
      final (_, oldParam, _, tokens) = inProgress;
      if (compare(oldParam, param)) {
        if (updateToken != null) tokens.add(updateToken);
        return;
      }
    }

    _perform(key, param, updateToken);
  }

  void _evict(K key) {
    final previous = _cache.remove(key);
    if (previous != null) {
      final (_, previousValue, previousSize) = previous;
      if (previousValue != null) onDispose?.call(previousValue);
      _currentSize -= previousSize;
    }
  }

  void _replace(K key, P param, V? value) {
    _evict(key);
    final newSize = value != null ? sizeOf(value) : 0;
    _currentSize += newSize;
    _cache[key] = (param, value, newSize);
  }

  Future<V?> _perform(K key, P param, Object? updateToken) async {
    final token = _token++;

    try {
      final future = load(key, param);
      _inProgress[key] = (token, param, future, {?updateToken});
      final value = await future;

      // another request has been made for this key with a different value
      // or disposed
      if (isDisposed || _inProgress[key]?.$1 != token) {
        if (value != null) onDispose?.call(value);
        return null;
      }

      final (_, _, _, updateTokens) = _inProgress.remove(key)!;
      _replace(key, param, value);
      _contract();
      
      for (final t in updateTokens) onResolve?.call(t);

      notifyListeners();
      return value;
    } catch (e, st) {
      _logger.warning('error performing load for $key/$param', e, st);
      if (_inProgress[key]?.$1 == token) _inProgress.remove(key);
      return null;
    }
  }

  bool _contract() {
    if (maxSize < 0) return false;
    if (_currentSize <= maxSize) return false;

    final toRemove = <K>[];
    var contractedSize = _currentSize;
    for (final key in _cache.keys) {
      final size = _cache[key]!.$3;
      if (size > 0) {
        toRemove.add(key);
        contractedSize -= size;
      }
      if (contractedSize <= maxSize) break;
    }

    _logger.fine('contracting cache, removing ${toRemove.length} keys ($_currentSize -> $contractedSize)');
    for (final key in toRemove) _evict(key);
    return true;
  }

  void contract() {
    if (_contract()) notifyListeners();
  }

  @override
  void dispose() {
    _inProgress.clear();
    for (final (_, value, _) in _cache.values) {
      if (value != null) onDispose?.call(value);
    }
    _cache.clear();
    super.dispose();
  }
}
