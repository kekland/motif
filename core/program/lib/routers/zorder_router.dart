part of '../program.dart';

sealed class const ZOrderRoute() {
  static const accept = ZOrderRouteAccept();
  const factory ZOrderRoute.forward(CellRef to) = ZOrderRouteForward;
  static const ignore = ZOrderRouteIgnore();
}

final class const ZOrderRouteAccept() extends ZOrderRoute;
final class const ZOrderRouteForward(final CellRef to) extends ZOrderRoute;
final class const ZOrderRouteIgnore() extends ZOrderRoute;

extension RouteZOrder on Evaluation {
  CellRef? routeZOrder(CellRef ref) {
    final s = statement(rootOf(ref.statementId));
    if (s == null) return null;

    late final ZOrderRoute result;
    if (s is ShapeStatement) {
      if (s.frame == ref) {
        result = .accept;
      } else {
        result = .forward(s.frame);
      }
    } else {
      result = .accept;
    }

    return switch (result) {
      ZOrderRouteAccept() => ref,
      ZOrderRouteForward f => routeZOrder(f.to),
      ZOrderRouteIgnore() => null,
    };
  }
}
