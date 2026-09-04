part of '../kernel.dart';

sealed class Mutation() {
  void reapply(Transaction txn);
  void unapply(Transaction txn);
}
