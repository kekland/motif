part of '../kernel.dart';

extension CoedgeWalk on List<Coedge> {
  List<Coedge> get reversedWalk => reversed.map((c) => c.reversed).toList();
}
