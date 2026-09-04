part of 'program.dart';

extension _ArgBox<H extends CellHandle> on Ref<H> {
  Borrow<Ref<H>> borrow() => Borrow(this);
  Own<Ref<H>> own() => Own(this);
}

// extension _ArgBoxOptional<H extends CellHandle> on Ref<H>? {
//   Borrow<Ref<H>>? borrow() => this == null ? null : Borrow(this!);
//   Own<Ref<H>>? own() => this == null ? null : Own(this!);
// }

extension _ArgListBox<H extends CellHandle> on List<Ref<H>> {
  List<Borrow<Ref<H>>> borrow() => [for (final e in this) e.borrow()];
  List<Own<Ref<H>>> own() => [for (final e in this) e.own()];
}

extension _ArgUnbox<H extends CellHandle> on Arg<Ref<H>> {
  Ref<H> get ref => this.ref;
  bool get isBorrow => this.isBorrow;
  bool get isOwn => this.isOwn;
}

extension _ArgListUnbox<H extends CellHandle> on List<Arg<Ref<H>>> {
  List<Ref<H>> get refs => [for (final e in this) e.ref];
  List<Borrow<Ref<H>>> get borrows => [for (final e in this) Borrow(e.ref)];
  List<Own<Ref<H>>> get owns => [for (final e in this) Own(e.ref)];
}

extension SymbolName on Symbol {
  String get name {
    final str = toString();
    return str.substring(8, str.length - 2);
  }

  Symbol operator /(String next) => Symbol('$name.$next');
}
