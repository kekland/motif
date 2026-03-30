import 'package:stack_theme/stack_theme.dart';

const _typographyColors = <TextColorDescription>[
  .new('primary', getter: 'display.primary'),
  .new('secondary', getter: 'display.secondary'),
  .new('tertiary', getter: 'display.tertiary'),
  .new('accent', getter: 'accent.primary'),
  .new('danger', getter: 'danger.primary'),
];

const _typographyWeights = <FontWeight>[.regular, .bold];

const themeDescription = ThemeDescription(
  platforms: ['material', 'cupertino'],
  colors: [
    .group('surface', children: [.actionable('primary'), .actionable('secondary'), .actionable('tertiary')]),
    .group('accent', children: [.actionable('primary'), .actionable('secondary'), .actionable('tertiary')]),
    .group('danger', children: [.actionable('primary'), .actionable('secondary')]),
    .group('display', children: [.leaf('primary'), .leaf('secondary'), .leaf('tertiary')]),
    .leaf('divider'),
    .leaf('scrim'),
    .leaf('gestureOverlay'),
    .leaf('normal'),
    .leaf('inverse'),
    .leaf('shadow'),
  ],
  typography: [
    .new('largeTitle', colors: _typographyColors),
    .new('title1', colors: _typographyColors, weights: _typographyWeights),
    .new('title2', colors: _typographyColors, weights: _typographyWeights),
    .new('subtitle1', colors: _typographyColors, weights: _typographyWeights),
    .new('body1', colors: _typographyColors, weights: _typographyWeights),
    .new('caption1', colors: _typographyColors, weights: _typographyWeights),
    .new('caption2', colors: _typographyColors, weights: _typographyWeights),
    .new('caption3', colors: _typographyColors, weights: _typographyWeights),
    .new('footnote', colors: _typographyColors, weights: _typographyWeights),
  ],
  animations: [
    .new('spatialFast'),
    .new('spatialDefault'),
    .new('spatialSlow'),
    .new('effectFast'),
    .new('effectDefault'),
    .new('effectSlow'),
  ],
  shadows: [
    .new('window'),
    .new('small'),
  ],
);
