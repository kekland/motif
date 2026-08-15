// ignore_for_file: depend_on_referenced_packages, unused_element, unused_element_parameter

import 'package:flutter/widgets.dart';
import 'package:vector_graphics/vector_graphics.dart';

enum _BaseIconMode {
  vg,
  iconData,
}

class _BaseIcon extends StatelessWidget {
  const _BaseIcon.vgSelector({
    super.key,
    required BytesLoader Function(BuildContext) loader,
    BytesLoader Function(BuildContext)? filledLoader,
    this.size,
    this.color,
    this.autocolor = true,
  }) : mode = .vg,
       icon = null,
       loader = null,
       filledLoader = null,
       loaderFn = loader,
       filledLoaderFn = filledLoader,
       isSelectorBased = true;

  const _BaseIcon.vgBasic({
    super.key,
    required this.loader,
    this.filledLoader,
    this.size,
    this.color,
    this.autocolor = true,
  }) : mode = .vg,
       icon = null,
       loaderFn = null,
       filledLoaderFn = null,
       isSelectorBased = false;

  const _BaseIcon.iconData({
    super.key,
    required IconData this.icon,
    this.size,
    this.color,
  }) : mode = .iconData,
       loader = null,
       loaderFn = null,
       filledLoader = null,
       filledLoaderFn = null,
       isSelectorBased = false,
       autocolor = true;

  final _BaseIconMode mode;
  final IconData? icon;
  final BytesLoader Function(BuildContext)? loaderFn;
  final BytesLoader Function(BuildContext)? filledLoaderFn;
  final BytesLoader? loader;
  final BytesLoader? filledLoader;
  final bool isSelectorBased;
  final double? size;
  final Color? color;
  final bool autocolor;

  Widget _buildVgIcon(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    final color = this.color ?? iconTheme.color ?? Surface.maybeColorOf(context)?.foreground;
    final size = this.size ?? iconTheme.size ?? 24.0;
    final fill = iconTheme.fill ?? 0.0;

    Widget _buildIcon(BytesLoader loader, [double? opacity]) {
      return VectorGraphic(
        key: ValueKey((loader, opacity)),
        loader: loader,
        colorFilter: color != null && autocolor ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        width: size,
        height: size,
        opacity: opacity != null ? AlwaysStoppedAnimation(opacity) : null,
      );
    }

    final loader = isSelectorBased ? loaderFn!(context) : this.loader!;
    final filledLoader = isSelectorBased ? filledLoaderFn?.call(context) : this.filledLoader;

    if (filledLoader != null) {
      return Stack(
        children: [
          _buildIcon(loader, 1.0 - fill),
          _buildIcon(filledLoader, fill),
        ],
      );
    } else {
      return _buildIcon(loader);
    }
  }

  Widget _buildIconDataIcon(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return switch (mode) {
      .vg => _buildVgIcon(context),
      .iconData => _buildIconDataIcon(context),
    };
  }
}
