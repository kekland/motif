import 'dart:convert';

final class FunctionalConverter<S, T> extends Converter<S, T> {
  new(this._convert);
  final T Function(S input) _convert;

  @override
  T convert(S input) => _convert(input);
}

final class FunctionalCodec<S, T> extends Codec<S, T> {
  new({required this.decoder, required this.encoder});

  FunctionalCodec.from({required S Function(T input) decoder, required T Function(S input) encoder})
    : this(decoder: .new(decoder), encoder: .new(encoder));

  @override
  final FunctionalConverter<T, S> decoder;

  @override
  final FunctionalConverter<S, T> encoder;
}

FunctionalCodec<S, T> $codec<S, T>({
  required S Function(T input) decoder,
  required T Function(S input) encoder,
}) => .from(decoder: decoder, encoder: encoder);

T? $opt<T>(bool Function() hasValue, T Function() value) => hasValue() ? value() : null;
List<R> $map<T, R>(Iterable<T> list, R Function(T) mapper) => list.map(mapper).toList();

Map<K, V> $mapFrom<P, K, V>(Iterable<P> list, K Function(P) keyMapper, V Function(P) valueMapper) {
  return .fromEntries(list.map((e) => .new(keyMapper(e), valueMapper(e))));
}

List<R> $fromMap<K, V, R>(Map<K, V> map, R Function(K key, V value) mapper) {
  return $map(map.entries, (e) => mapper(e.key, e.value));
}

Map<K2, V2> $mmap<K1, V1, K2, V2>(Map<K1, V1> map, K2 Function(K1) keyMapper, V2 Function(V1) valueMapper) {
  return map.map((k, v) => .new(keyMapper(k), valueMapper(v)));
}

T? decodeRaw<T>(T Function() decode) {
  try {
    return decode();
  } catch (e) {
    return null;
  }
}
