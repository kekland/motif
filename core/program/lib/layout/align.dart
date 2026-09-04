part of '../program.dart';

enum LayoutAlign {
  start,
  center,
  end;

  double offset(double outer, double inner) => switch (this) {
    .start => 0.0,
    .center => (outer - inner) / 2.0,
    .end => outer - inner,
  };
}
