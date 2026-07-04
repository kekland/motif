part of 'core.dart';

abstract class Socket<T> {
  Socket({required this.name});

  final String name;
  Type get type => T;

  bool get isList => this is ListInputSocket;
  bool get isConstant => this is ConstantSocket<T>;
  bool get isDynamic => this is DynamicSocket<T>;
  bool get isConnected;
  Color? resolveColor(BuildContext context) => null;

  Node? _node;
  Blueprint? get _blueprint => _node?._blueprint;

  ReadonlySignal<Socket> call() => _blueprint!._signalForSocket(this);

  void connect(covariant Socket s) => _blueprint!.connect(this, s);
  void disconnect([covariant Socket? s]) => _blueprint!.disconnect(this, s!);

  Field<T> resolve();
}

mixin InputSocket<T> on Socket<T> {
  Iterable<OutputSocket> get incoming => _blueprint?._connections.incomingConnectionFor(this) ?? const [];

  // dart format off
  @override ReadonlySignal<InputSocket<T>> call() => super.call() as ReadonlySignal<InputSocket<T>>;
  @override void connect(OutputSocket s) => super.connect(s);
  @override void disconnect([OutputSocket? s]) => super.disconnect(s ?? incoming.single);
  // dart format on

  @override
  bool get isConnected => incoming.isNotEmpty;

  T get defaultValue;
  late T _inlineValue = defaultValue;
  T get inlineValue => _inlineValue;
  set inlineValue(T value) {
    if (_inlineValue == value) return;
    _inlineValue = value;
    _blueprint?._markSocketAsDirty(this);
  }

  @override
  Field<T> resolve() {
    if (!isConnected) {
      return .constant(inlineValue);
    }

    final incoming = this.incoming.single;
    final result = incoming.resolve();

    if (isConstant && result is! ConstantField) {
      throw StateError('dynamic field passed to a constant input socket');
    }

    return result as Field<T>;
  }
}

mixin OutputSocket<T> on Socket<T> {
  Iterable<InputSocket> get outgoing => _blueprint?._connections.outgoingConnectionsFor(this) ?? const [];

  @override
  bool get isConnected => outgoing.isNotEmpty;

  // dart format off
  @override ReadonlySignal<OutputSocket<T>> call() => super.call() as ReadonlySignal<OutputSocket<T>>;
  @override void connect(InputSocket s) => super.connect(s);
  @override void disconnect([InputSocket? s]) => super.disconnect(s ?? outgoing.single);
  // dart format on

  Field<T>? _value;
  set value(Field<T> v) {
    if (isConstant && v is! ConstantField) {
      throw StateError('dynamic field passed to a constant output socket');
    }

    _value = v;
  }

  @override
  Field<T> resolve() {
    _node!.execute();
    return _value!;
  }
}

mixin ListInputSocket<I, T extends List<I>> on InputSocket<T> {
  @override
  T get defaultValue => <I>[] as T;

  @override
  Field<T> resolve() {
    final incoming = this.incoming;
    final results = incoming.map((s) => s.resolve()).toList();

    if (results.every((f) => f is ConstantField)) {
      final values = results.map((f) => (f as ConstantField).value as I).toList();
      return .constant(values as T);
    } else {
      if (isConstant) {
        throw StateError('dynamic field passed to a constant input socket');
      }

      return .dynamic((context) {
        final values = results.map((f) => f.evaluate(context) as I).toList();
        return values as T;
      });
    }
  }
}

mixin ConstantSocket<T> on Socket<T> {
  @override
  ConstantField<T> resolve() => super.resolve() as ConstantField<T>;
}

mixin DynamicSocket<T> on Socket<T> {}
