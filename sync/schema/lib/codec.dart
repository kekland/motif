export 'codec/asset_codec.dart';
export 'codec/program_codec.dart';
export 'codec/skia_codec.dart';

T? decodeRaw<T>(T Function() decode) {
  try {
    return decode();
  } catch (e) {
    return null;
  }
}
