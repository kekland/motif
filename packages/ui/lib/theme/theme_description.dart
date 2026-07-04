// ignore: depend_on_referenced_packages
import 'package:stack_theme/stack_theme.dart';

const _typographyColors = <TextColorDescription>[
  .new('primary', getter: 'display.primary'),
  .new('secondary', getter: 'display.secondary'),
  .new('tertiary', getter: 'display.tertiary'),
  .new('accent', getter: 'accent.primary'),
  .new('danger', getter: 'danger.primary'),
];

const themeDescription = ThemeDescription(
  platforms: ['material', 'cupertino'],
  variants: ['desktop', 'mobile'],
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
    .group(
      'blueprint',
      children: [
        .group(
          'data',
          children: [.leaf('int'), .leaf('float'), .leaf('vector'), .leaf('geometry'), .leaf('symbol')],
        ),
        .group(
          'node',
          children: [.leaf('math'), .leaf('geometry'), .leaf('primitive'), .leaf('instance'), .leaf('symbol')],
        ),
      ],
    ),
  ],
  typography: [
    .new('largeTitle', colors: _typographyColors),
    .new('title', colors: _typographyColors),
    .new('subtitle', colors: _typographyColors),
    .new('body', colors: _typographyColors),
    .new('footnote', colors: _typographyColors),
  ],
  animations: [
    .new('window'),
    .new('spatialFast'),
    .new('spatialDefault'),
    .new('spatialSlow'),
    .new('effectFast'),
    .new('effectDefault'),
    .new('effectSlow'),
  ],
  shadows: [
    .new('window'),
    .new('medium'),
    .new('small'),
  ],
  sizes: [
    .new('panel'),
  ],
);
