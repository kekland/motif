part of 'serializer.dart';

final class _FunctionalConverter<S, T> extends Converter<S, T> {
  new(this._convert);
  final T Function(S input) _convert;

  @override
  T convert(S input) => _convert(input);
}

final class _FunctionalCodec<S, T> extends Codec<S, T> {
  new({required this.decoder, required this.encoder});

  _FunctionalCodec.from({required S Function(T input) decoder, required T Function(S input) encoder})
    : this(decoder: .new(decoder), encoder: .new(encoder));

  @override
  final _FunctionalConverter<T, S> decoder;

  @override
  final _FunctionalConverter<S, T> encoder;
}

_FunctionalCodec<S, T> _codec<S, T>({
  required S Function(T input) decoder,
  required T Function(S input) encoder,
}) => .from(decoder: decoder, encoder: encoder);
