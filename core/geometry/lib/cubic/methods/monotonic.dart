part of '../cubic.dart';

bool _cubicMonotonicInX(Cubic2 c) => _monotone(c.p0.x, c.p1.x, c.p2.x, c.p3.x);
bool _cubicMonotonicInY(Cubic2 c) => _monotone(c.p0.y, c.p1.y, c.p2.y, c.p3.y);

bool _monotone(double a, double b, double c, double d) => (a <= b && b <= c && c <= d) || (a >= b && b >= c && c >= d);

bool _cubicIsMonotone(Cubic2 c) => _cubicExtrema(c).isEmpty;