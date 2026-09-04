part of '../program.dart';

final class BindingTable {
  final _keys = <Ref, CellKey>{};
  final _refs = <CellKey, Ref>{};

  final _producer = <Ref, Statement>{};
  final _products = <StatementId, Set<Ref>>{};

  CellKey<H>? keyOf<H extends CellHandle>(Ref<H> ref) => _keys[ref] as CellKey<H>?;
  Ref<H>? refOf<H extends CellHandle>(CellKey<H> key) => _refs[key] as Ref<H>?;
  S? statementOf<S extends Statement>(Ref ref) => _producer[ref] as S?;
  Iterable<Ref> productsOf(StatementId statementId) => _products[statementId] ?? const {};

  final _writes = <StatementId, List<(Ref, CellKey, Ref?)>>{};

  void bind(Ref ref, CellKey key, Statement producer) {
    assert(!_keys.containsKey(ref), 'ref $ref bound twice');
    _keys[ref] = key;
    _refs[key] = ref;
    _producer[ref] = producer;

    final id = producer.id;
    _products.putIfAbsent(id, () => {}).add(ref);
    _writes.putIfAbsent(id, () => []).add((ref, key, _refs[key]));
  }

  void unbind(StatementId id) {
    final write = _writes.remove(id);
    if (write == null) return;

    for (final (ref, key, prev) in write.reversed) {
      _keys.remove(ref);
      _producer.remove(ref);
      if (prev == null) {
        _refs.remove(key);
      } else {
        _refs[key] = prev;
      }
    }

    _products.remove(id);
  }
}
