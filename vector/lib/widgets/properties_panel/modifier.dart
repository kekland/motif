part of '../properties_panel.dart';

class ModifierWidget extends StatelessWidget {
  const ModifierWidget({
    super.key,
    required this.modifier,
    this.onApply,
    this.onChanged,
  });

  final Modifier modifier;
  final ValueChanged<Modifier?>? onChanged;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final modifier = this.modifier;

    return switch (modifier) {
      SimplifyEdgeModifier() => SimplifyEdgeModifierWidget(
        modifier: modifier,
        onChanged: onChanged,
        onApply: onApply,
      ),
      MirrorModifier() => MirrorModifierWidget(
        modifier: modifier,
        onChanged: onChanged,
        onApply: onApply,
      ),
      GeneratorModifier() => GeneratorModifierWidget(
        modifier: modifier,
        onChanged: onChanged,
        onApply: onApply,
      ),
      _ => throw UnimplementedError('Modifier widget not implemented for ${modifier.runtimeType}'),
    };
  }
}

class ModifierWidgetBase extends StatelessWidget {
  const ModifierWidgetBase({
    super.key,
    this.icon,
    this.onRemove,
    this.isEnabled = true,
    this.onEnabledChanged,
    this.onApply,
    required this.label,
    required this.children,
  });

  final Widget? icon;
  final Widget label;
  final List<Widget> children;
  final VoidCallback? onRemove;
  final VoidCallback? onApply;
  final bool isEnabled;
  final ValueChanged<bool>? onEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return Surface(
      borderRadius: .circular(4.0),
      color: context.colors.surface.secondary,
      borderSide: .new(color: context.colors.divider),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Subtitle(
            leading: icon,
            trailing: Row(
              mainAxisSize: .min,
              children: [
                IconButton(
                  size: 24.0,
                  onTap: onApply,
                  child: Icons.applyModifier(),
                ),
                const SizedBox(width: 4.0),
                IconButton(
                  size: 24.0,
                  onTap: () => onEnabledChanged?.call(!isEnabled),
                  child: isEnabled ? Icons.visibility() : Icons.visibilityOff(),
                ),
                const SizedBox(width: 4.0),
                IconButton(
                  size: 24.0,
                  onTap: onRemove,
                  child: Icons.delete(),
                ),
                const SizedBox(width: 4.0),
                Icons.dragHandle(color: context.colors.display.tertiary),
              ],
            ),
            child: label,
          ),
          Divider(),
          const SizedBox(height: 8.0),

          for (final child in children)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: child,
            ),
        ],
      ),
    );
  }
}

class SimplifyEdgeModifierWidget extends StatelessWidget {
  const SimplifyEdgeModifierWidget({
    super.key,
    required this.modifier,
    this.onApply,
    this.onChanged,
  });

  final SimplifyEdgeModifier modifier;
  final VoidCallback? onApply;
  final ValueChanged<SimplifyEdgeModifier?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ModifierWidgetBase(
      icon: Icons.squiggly(),
      label: Text('Simplify'),
      onApply: onApply,
      onRemove: () => onChanged?.call(null),
      isEnabled: modifier.isEnabled,
      onEnabledChanged: (v) => onChanged?.call(modifier.copyWith(isEnabled: v)),
      children: [
        Slider(
          label: Text('Spatial tolerance'),
          min: 0.01,
          max: 10.0,
          value: modifier.spatialTolerance,
          logScale: true,
          onChanged: (v) => onChanged?.call(modifier.copyWith(spatialTolerance: v)),
        ),
        Slider(
          label: Text('Velocity threshold'),
          min: 0.01,
          max: 20.0,
          value: modifier.velocityThreshold,
          logScale: true,
          onChanged: (v) => onChanged?.call(modifier.copyWith(velocityThreshold: v)),
        ),
        Slider(
          label: Text('Weight tolerance'),
          min: 0.01,
          max: 20.0,
          value: modifier.weightTolerance,
          logScale: true,
          onChanged: (v) => onChanged?.call(modifier.copyWith(weightTolerance: v)),
        ),
      ],
    );
  }
}

class MirrorModifierWidget extends StatelessWidget {
  const MirrorModifierWidget({
    super.key,
    required this.modifier,
    this.onApply,
    this.onChanged,
  });

  final MirrorModifier modifier;
  final VoidCallback? onApply;
  final ValueChanged<MirrorModifier?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ModifierWidgetBase(
      icon: Icons.mirror(),
      label: Text('Mirror'),
      onApply: onApply,
      onRemove: () => onChanged?.call(null),
      isEnabled: modifier.isEnabled,
      onEnabledChanged: (v) => onChanged?.call(modifier.copyWith(isEnabled: v)),
      children: [],
    );
  }
}

class GeneratorModifierWidget extends StatelessWidget {
  const GeneratorModifierWidget({
    super.key,
    required this.modifier,
    this.onApply,
    this.onChanged,
  });

  final GeneratorModifier modifier;
  final VoidCallback? onApply;
  final ValueChanged<GeneratorModifier?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ModifierWidgetBase(
      icon: Icons.generator(),
      label: Text('Generator'),
      onApply: onApply,
      onRemove: () => onChanged?.call(null),
      isEnabled: modifier.isEnabled,
      onEnabledChanged: (v) => onChanged?.call(modifier.copyWith(isEnabled: v)),
      children: [
        Tile(
          onTap: () async {
            final generator = await WindowNavigator.pushUnique(
              context,
              SelectGeneratorWindow.createEntry(
                context,
                manager: VectorController.of(context).generatorManager,
              ),
            );

            if (generator == null) return;
            onChanged?.call(modifier.copyWith(generatorId: generator.id));
          },
          title: Text('Generator'),
        ),
      ],
    );
  }
}
