part of 'core.dart';

abstract class Socket<T> {
  Socket({required this.name});

  final String name;
  Symbol get category;
  Type get type => T;

  late final Node node;
  late final int index;
  SocketRef get ref => .new(node.id, index);

  bool get isList => this is ListInputSocket;
  bool get isConstant => this is ConstantSocket<T>;
  bool get isDynamic => this is DynamicSocket<T>;

  void _attach(Node node, int index) {
    this.node = node;
    this.index = index;
  }
}

mixin InputSocket<T> on Socket<T> {
  T get defaultValue;

  late final T inlineValue;

  bool accepts(OutputSocket o) => o.type == (this is ListInputSocket ? (this as ListInputSocket).elementType : type);

  // Node withInline(T value) => node.withInline(index, value);
}

mixin OutputSocket<T> on Socket<T> {}

mixin ListInputSocket<I, T extends List<I>> on InputSocket<T> {
  Type get elementType => I;

  @override
  T get defaultValue => <I>[] as T;
}

mixin ConstantSocket<T> on Socket<T> {}

mixin DynamicSocket<T> on Socket<T> {}
