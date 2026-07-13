import 'package:flutter/foundation.dart';
import 'package:stack/stack.dart';

abstract interface class Node implements ChangeNotifier {}

abstract class ImmutableNodeBase<TI extends ImmutableNodeBase<TI, TM>, TM extends MutableNodeBase<TI, TM>>
    with StaticNotifier
    implements Node {
  ImmutableNodeBase();

  TI copyWith();
}

abstract class MutableNodeBase<TI extends ImmutableNodeBase<TI, TM>, TM extends MutableNodeBase<TI, TM>>
    with ChangeNotifier, ChangeNotifierDisposable
    implements Node {
  MutableNodeBase();
}
