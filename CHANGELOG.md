# 0.1.9

* Added support for rendering the current scene using different frames as the root frame.
* Added the prefabs panel, which shows the current prefabs in the scene.
* Prefabs: improved support for overrides in prefab instances. Instances can now have nested overrides, as well as top-level overrides (to the produced container).
* Moved the object tree into the evaluation layer, since it's needed for proper prefab management.
* Paste action: now pastes statements into the selected containers.

# 0.1.8

* Rework tool options placement. Now global options (e.g. snap to pixel) are located in the canvas options panel, while per-tool options replace the selection panel entirely.
* Expanded the auto layout props. Now everything is supported for both stack/flex layouts.
* Prefabs: added support for prefab origins and instances. Prefabs represent reusable components that can be instantiated multiple times, and changes to the origin are reflected in all instances.
* Prefabs: added override support for instances. Instances can now have their own and children properties overridden independently of the origin.
* Reparent router: fixed edge-cases where it's possible to create circular prefab references (e.g. instance into its own origin, directly or transitively), and disallowed reparenting into generated statement frames.
* Scene tree: only show `PlacedStatement`s in the hierarchy.

# 0.1.7

* Tree panel, statement panel: added name text fields
* Move activity: fix container reparenting
* Paste: fixed handling of pasted content to ensure proper positioning
* Transform session: statement dependents are automatically ignored if those are included
* Cell handles: moving a group now correctly updates the overlay position
* Canvas: added top-level container name labels
* Modifiers: replaced `List<Modifier> modifiers` field with a `ModifierStack` object, similar to `Decorations`/`List<Decoration>`.
* Modifiers: added an input field for a fillet modifier.
* Dissolution/deletion: fix handling of owning statements after filtering

# 0.1.6

* Props: simplify the core, making it easier to use in other places
* Tool options: moved into the tab bar, opens as a window. WIP.
* Prop widgets: adjusted spacing, padding, etc.
* Cell handles: fixed incorrect frame bbox transformation
* Tool options: edge/face styles now automatically resolve the fill/stroke color based on the color of the tap position, unless the color is set manually.
* Tooltip: display logic adjusted to account for nested tooltips. If the child is currently queued to be displayed, the parent will not be displayed.
* Statements: added support for an optional name field
* Tree panel: added support for multi-selection, toggle selection, collapsing, reordering
* Actions: added tab and enter-based navigation

# 0.1.5

* Selection: parented cells are now selectable only if its parent is selected.
* Selection handles: now supports tap up callbacks to handle events when the user tapped on the selection overlay without dragging.
* `DragActivityRecognizer.onlyAcceptDragOnThreshold` is added to allow drag activities which should not fire immediately to wait until a threshold drag is reached.
* Hover: show frame boundaries for frames without any cells (e.g. text).
* Dissolution router: properly handle reorder statements (those die with the attached cells). Fixes a bug where if a reorder is applied to a cell, it will never be removed.
* Pen tool: fixed `embedVertex` logic for when the vertex is embedded into a leaf frame, and compute the local position properly.

# 0.1.4

* Alpha release!