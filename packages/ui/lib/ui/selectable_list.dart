import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchableSelectableList<T> extends StatefulWidget {
  const new({
    super.key,
    required this.focusNode,
    required this.items,
    required this.builder,
    this.onSubmit,
    this.query,
    this.filter,
    this.selection,
  });

  final T? selection;
  final FocusNode focusNode;
  final List<T> items;
  final void Function(T?)? onSubmit;
  final String? query;
  final List<T> Function(String query)? filter;
  final Widget Function(BuildContext context, List<T> items) builder;

  @override
  State<SearchableSelectableList<T>> createState() => SearchableSelectableListState<T>();
}

class SearchableSelectableListState<T> extends State<SearchableSelectableList<T>> {
  var _items = <T>[];
  final _children = <T, SelectableListItemState<T>>{};
  final _selectionNotifier = ValueNotifier<T?>(null);
  T? get selectedValue => _selectionNotifier.value;

  void _attach(SelectableListItemState<T> child) => _children[child.widget.value] = child;
  void _detach(SelectableListItemState<T> child) => _children.remove(child.widget.value);

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKey);
    _selectionNotifier.value = widget.selection;
  }

  @override
  void dispose() {
    _selectionNotifier.dispose();
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchableSelectableList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selection != oldWidget.selection) {
      _selectionNotifier.value = widget.selection;
    }

    if (widget.items != oldWidget.items) {
      _onQueryChanged(widget.query);
    }

    if (widget.query != oldWidget.query) {
      _onQueryChanged(widget.query);
    }
  }

  void _onQueryChanged(String? query) {
    if (query == null || query.isEmpty) {
      _items = widget.items;
      return;
    }

    _items = widget.filter!.call(query);
    if (selectedValue != null) {
      if (!_items.contains(selectedValue)) {
        _selectionNotifier.value = null;
      }
    }

    setState(() {});
  }

  void _selectItem(T? item) {
    _selectionNotifier.value = item;
  }

  bool _handleKey(KeyEvent event) {
    if (!widget.focusNode.hasFocus) return false;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == .enter) {
        widget.onSubmit?.call(selectedValue);
        return true;
      }

      final indexOffset = switch (event.logicalKey) {
        .arrowUp => -1,
        .arrowDown => 1,
        _ => 0,
      };

      if (indexOffset == 0) return false;
      final selected = selectedValue;
      if (selected == null) {
        final item = _items.first;
        _selectItem(item);
        return true;
      }

      final selectedIndex = widget.items.indexOf(selected);
      var nextIndex = selectedIndex + indexOffset;
      nextIndex = nextIndex.clamp(0, widget.items.length - 1);

      _selectItem(widget.items[nextIndex]);
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _items);
  }
}

class SelectableListItem<T> extends StatefulWidget {
  const new({
    super.key,
    required this.value,
    required this.builder,
  });

  final T value;
  final Widget Function(BuildContext context, bool isSelected) builder;

  @override
  State<SelectableListItem<T>> createState() => SelectableListItemState<T>();
}

class SelectableListItemState<T> extends State<SelectableListItem<T>> {
  var _isSelected = false;
  SearchableSelectableListState<T>? _parentState;

  T get value => widget.value;

  void _updateSelected() {
    final newValue = _parentState?.selectedValue == value;
    if (_isSelected != newValue) setState(() => _isSelected = newValue);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newParent = context.findAncestorStateOfType<SearchableSelectableListState<T>>();
    if (_parentState != newParent) {
      _parentState?._selectionNotifier.removeListener(_updateSelected);
      _parentState?._detach(this);
      _parentState = newParent;
      _parentState?._attach(this);
      _parentState?._selectionNotifier.addListener(_updateSelected);
      _updateSelected();
    }
  }

  @override
  void dispose() {
    _parentState?._selectionNotifier.removeListener(_updateSelected);
    _parentState?._detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _isSelected);
  }
}
