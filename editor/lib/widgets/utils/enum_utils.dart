import 'package:editor/imports.dart';

extension TextFontWeightExtension on TextFontWeight {
  String resolveName(BuildContext context) => switch (this) {
    .thin => 'Thin',
    .extraLight => 'Extra Light',
    .light => 'Light',
    .regular => 'Regular',
    .medium => 'Medium',
    .semiBold => 'Semi Bold',
    .bold => 'Bold',
    .extraBold => 'Extra Bold',
    .black => 'Black',
  };
}

extension TextFontSlantExtension on TextFontSlant {
  String resolveName(BuildContext context) => switch (this) {
    .upright => 'Regular',
    .italic => 'Italic',
    .oblique => 'Oblique',
  };
}

extension TextFontWidthExtension on TextFontWidth {
  String resolveName(BuildContext context) => switch (this) {
    .ultraCondensed => 'Ultra Condensed',
    .extraCondensed => 'Extra Condensed',
    .condensed => 'Condensed',
    .semiCondensed => 'Semi Condensed',
    .normal => 'Normal',
    .semiExpanded => 'Semi Expanded',
    .expanded => 'Expanded',
    .extraExpanded => 'Extra Expanded',
    .ultraExpanded => 'Ultra Expanded',
  };
}
