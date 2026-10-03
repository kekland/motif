part of 'asset.dart';

final class const AssetLicense({
  required final Hash hash,
  required final String descriptor,
  required final String kind,
  required final String body,
}) {
  factory decode(gen.AssetLicense asset) => asset.decode();
  static AssetLicense? decodeRaw(Uint8List data) => codec.decodeRaw(() => .decode(.fromBuffer(data)));
}

final class const LicenseBundle({
  required final Map<Hash, AssetLicense> licenses,
}) {
  factory decode(gen.LicenseBundle bundle) => bundle.decode();
  static LicenseBundle? decodeRaw(Uint8List data) => codec.decodeRaw(() => .decode(.fromBuffer(data)));
}
