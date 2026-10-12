part of '../_program.dart';

enum LayoutAlign {
  none,
  start,
  center,
  end;

  double offset(double outer, double inner) => switch (this) {
    .none => 0.0,
    .start => 0.0,
    .center => (outer - inner) / 2.0,
    .end => outer - inner,
  };
}
