# 0.1.6

* Props: simplify the core, making it easier to use in other places
* Tool options: moved into the tab bar, opens as a window. WIP.
* Prop widgets: adjusted spacing, padding, etc.
* Cell handles: fixed incorrect frame bbox transformation

# 0.1.5

* Selection: parented cells are now selectable only if its parent is selected.
* Selection handles: now supports tap up callbacks to handle events when the user tapped on the selection overlay without dragging.
* `DragActivityRecognizer.onlyAcceptDragOnThreshold` is added to allow drag activities which should not fire immediately to wait until a threshold drag is reached.
* Hover: show frame boundaries for frames without any cells (e.g. text).
* Dissolution router: properly handle reorder statements (those die with the attached cells). Fixes a bug where if a reorder is applied to a cell, it will never be removed.
* Pen tool: fixed `embedVertex` logic for when the vertex is embedded into a leaf frame, and compute the local position properly.

# 0.1.4

* Alpha release!