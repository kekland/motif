// Port of ink_stroke_modeler/stroke_modeler_test.cc.
//
// Expected values are the C++ suite's, computed in float; the port runs in double, so the
// tolerances are the C++ ones (kTol = 1e-4, kAccelTol = 1e-3) and are comfortably met.

import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/ink_stroke_modeler.dart';
import 'package:test/test.dart';

const tol = 1e-4;
const accelTol = 5e-3;
const intMax = 2147483647.0;

/// These parameters use cm for distance and seconds for time.
const defaultParams = StrokeModelParams(
  wobbleSmootherParams: WobbleSmootherParams(timeout: TimeSpan(0.04), speedRange: Range(1.31, 1.44)),
  positionModelerParams: PositionModelerParams(springMassConstant: 11.0 / 32400, dragConstant: 72.0),
  samplingParams: SamplingParams(minOutputRate: 180, endOfStrokeStoppingDistance: 0.001, endOfStrokeMaxIterations: 20),
  stylusStateModelerParams: StylusStateModelerParams(useStrokeNormalProjection: false),
  predictionParams: StrokeEndPredictorParams(),
);

/// [defaultParams] with one or more fields changed. `wobbleSmootherParams: null` disables the smoother.
StrokeModelParams makeParams({
  WobbleSmootherParams? wobbleSmootherParams = const WobbleSmootherParams(
    timeout: TimeSpan(0.04),
    speedRange: Range(1.31, 1.44),
  ),
  LoopContractionMitigationParams? loopContractionMitigationParams,
  double minOutputRate = 180,
  bool useStrokeNormalProjection = false,
  PredictionParams predictionParams = const StrokeEndPredictorParams(),
}) => StrokeModelParams(
  wobbleSmootherParams: wobbleSmootherParams,
  positionModelerParams: PositionModelerParams(
    springMassConstant: 11.0 / 32400,
    dragConstant: 72.0,
    loopContractionMitigationParams: loopContractionMitigationParams,
  ),
  samplingParams: SamplingParams(
    minOutputRate: minOutputRate,
    endOfStrokeStoppingDistance: 0.001,
    endOfStrokeMaxIterations: 20,
  ),
  stylusStateModelerParams: StylusStateModelerParams(useStrokeNormalProjection: useStrokeNormalProjection),
  predictionParams: predictionParams,
);

Input input(EventType type, double x, double y, double time, {double? p, double? tilt, double? o}) =>
    Input(eventType: type, position: Vec2(x, y), time: Time(time), pressure: p, tilt: tilt, orientation: o);

/// An expected result. Unspecified velocity/acceleration are zero, unspecified stylus fields are
/// unknown (null), matching the C++ `Result` defaults of {0, 0} and -1.
final class Near {
  const Near(this.x, this.y, {this.v = (0, 0), this.a = (0, 0), required this.t, this.p, this.tilt, this.o});
  final double x, y;
  final (double, double) v, a;
  final double t;
  final double? p, tilt, o;
}

Near near(
  double x,
  double y, {
  (double, double) v = (0, 0),
  (double, double) a = (0, 0),
  required double t,
  double? p,
  double? tilt,
  double? o,
}) => Near(x, y, v: v, a: a, t: t, p: p, tilt: tilt, o: o);

void _expectNear(double? actual, double? expected, double tolerance, String what) {
  if (expected == null) {
    expect(actual, isNull, reason: what);
  } else {
    expect(actual, isNotNull, reason: what);
    expect(actual, closeTo(expected, tolerance), reason: what);
  }
}

void expectResults(List<Result> actual, List<Near> expected) {
  expect(actual.length, expected.length, reason: 'result count');
  for (var i = 0; i < expected.length; i++) {
    final r = actual[i], e = expected[i];
    final w = 'result $i';
    expect(r.position.x, closeTo(e.x, tol), reason: '$w position.x');
    expect(r.position.y, closeTo(e.y, tol), reason: '$w position.y');
    expect(r.velocity.x, closeTo(e.v.$1, tol), reason: '$w velocity.x');
    expect(r.velocity.y, closeTo(e.v.$2, tol), reason: '$w velocity.y');
    expect(r.acceleration.x, closeTo(e.a.$1, accelTol), reason: '$w acceleration.x');
    expect(r.acceleration.y, closeTo(e.a.$2, accelTol), reason: '$w acceleration.y');
    expect(r.time, closeTo(e.t, tol), reason: '$w time');
    _expectNear(r.pressure, e.p, tol, '$w pressure');
    _expectNear(r.tilt, e.tilt, tol, '$w tilt');
    _expectNear(r.orientation, e.o, tol, '$w orientation');
  }
}

/// Exact equality, field by field (the C++ compares with `operator==`).
void expectSameResults(List<Result> a, List<Result> b) {
  expect(a.length, b.length);
  for (var i = 0; i < a.length; i++) {
    expect(a[i].position.x, b[i].position.x, reason: 'position.x $i');
    expect(a[i].position.y, b[i].position.y, reason: 'position.y $i');
    expect(a[i].velocity.x, b[i].velocity.x, reason: 'velocity.x $i');
    expect(a[i].velocity.y, b[i].velocity.y, reason: 'velocity.y $i');
    expect(a[i].acceleration.x, b[i].acceleration.x, reason: 'acceleration.x $i');
    expect(a[i].acceleration.y, b[i].acceleration.y, reason: 'acceleration.y $i');
    expect(a[i].time, b[i].time, reason: 'time $i');
    expect(a[i].pressure, b[i].pressure, reason: 'pressure $i');
    expect(a[i].tilt, b[i].tilt, reason: 'tilt $i');
    expect(a[i].orientation, b[i].orientation, reason: 'orientation $i');
  }
}

void main() {
  test('NoPredictionUponInit', () {
    final modeler = StrokeModeler();
    modeler.reset(defaultParams);
    expect(modeler.predict, throwsA(isA<StateError>()));
  });

  test('NoPredictionWithDisabledPredictor', () {
    final modeler = StrokeModeler();
    modeler.reset(makeParams(predictionParams: const DisabledPredictorParams()));
    expect(modeler.predict, throwsA(isA<StateError>()));
  });

  test('InputRateSlowerThanMinOutputRate', () {
    const deltaTime = 1.0 / 30;

    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var time = Time(0);
    var results = modeler.update(input(.down, 3, 4, time));
    expectResults(results, [near(3, 4, t: 0)]);

    results = modeler.predict();
    expect(results, isEmpty);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 3.2, 4.2, time));
    expectResults(results, [
      near(3.0019, 4.0019, v: (0.4007, 0.4007), a: (84.1557, 84.1564), t: 0.0048),
      near(3.0069, 4.0069, v: (1.0381, 1.0381), a: (133.8378, 133.8369), t: 0.0095),
      near(3.0154, 4.0154, v: (1.7883, 1.7883), a: (157.5465, 157.5459), t: 0.0143),
      near(3.0276, 4.0276, v: (2.5626, 2.5626), a: (162.6039, 162.6021), t: 0.0190),
      near(3.0433, 4.0433, v: (3.3010, 3.3010), a: (155.0670, 155.0666), t: 0.0238),
      near(3.0622, 4.0622, v: (3.9665, 3.9665), a: (139.7575, 139.7564), t: 0.0286),
      near(3.0838, 4.0838, v: (4.5397, 4.5397), a: (120.3618, 120.3625), t: 0.0333),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(3.1095, 4.1095, v: (4.6253, 4.6253), a: (15.4218, 15.4223), t: 0.0389),
      near(3.1331, 4.1331, v: (4.2563, 4.2563), a: (-66.4341, -66.4339), t: 0.0444),
      near(3.1534, 4.1534, v: (3.6479, 3.6479), a: (-109.5083, -109.5081), t: 0.0500),
      near(3.1698, 4.1698, v: (2.9512, 2.9512), a: (-125.3978, -125.3976), t: 0.0556),
      near(3.1824, 4.1824, v: (2.2649, 2.2649), a: (-123.5318, -123.5310), t: 0.0611),
      near(3.1915, 4.1915, v: (1.6473, 1.6473), a: (-111.1818, -111.1806), t: 0.0667),
      near(3.1978, 4.1978, v: (1.1269, 1.1269), a: (-93.6643, -93.6636), t: 0.0722),
      near(3.1992, 4.1992, v: (1.0232, 1.0232), a: (-74.6390, -74.6392), t: 0.0736),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 3.5, 4.2, time));
    expectResults(results, [
      near(3.1086, 4.1058, v: (5.2142, 4.6131), a: (141.6557, 15.4223), t: 0.0381),
      near(3.1368, 4.1265, v: (5.9103, 4.3532), a: (146.1873, -54.5680), t: 0.0429),
      near(3.1681, 4.1450, v: (6.5742, 3.8917), a: (139.4012, -96.9169), t: 0.0476),
      near(3.2022, 4.1609, v: (7.1724, 3.3285), a: (125.6306, -118.2742), t: 0.0524),
      near(3.2388, 4.1739, v: (7.6876, 2.7361), a: (108.1908, -124.4087), t: 0.0571),
      near(3.2775, 4.1842, v: (8.1138, 2.1640), a: (89.5049, -120.1309), t: 0.0619),
      near(3.3177, 4.1920, v: (8.4531, 1.6436), a: (71.2473, -109.2959), t: 0.0667),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(3.3625, 4.1982, v: (8.0545, 1.1165), a: (-71.7427, -94.8765), t: 0.0722),
      near(3.4018, 4.2021, v: (7.0831, 0.6987), a: (-174.8469, -75.1957), t: 0.0778),
      near(3.4344, 4.2043, v: (5.8564, 0.3846), a: (-220.8140, -56.5515), t: 0.0833),
      near(3.4598, 4.2052, v: (4.5880, 0.1611), a: (-228.3204, -40.2244), t: 0.0889),
      near(3.4788, 4.2052, v: (3.4098, 0.0124), a: (-212.0678, -26.7709), t: 0.0944),
      near(3.4921, 4.2048, v: (2.3929, -0.0780), a: (-183.0373, -16.2648), t: 0.1000),
      near(3.4976, 4.2045, v: (1.9791, -0.1015), a: (-148.9792, -8.4822), t: 0.1028),
      near(3.5001, 4.2044, v: (1.7911, -0.1098), a: (-135.3759, -5.9543), t: 0.1042),
    ]);

    time = Time(time + deltaTime);
    // We get more results at the end of the stroke as it tries to "catch up" to
    // the raw input.
    results = modeler.update(input(.up, 3.7, 4.4, time));
    expectResults(results, [
      near(3.3583, 4.1996, v: (8.5122, 1.5925), a: (12.4129, -10.7201), t: 0.0714),
      near(3.3982, 4.2084, v: (8.3832, 1.8534), a: (-27.0783, 54.7731), t: 0.0762),
      near(3.4369, 4.2194, v: (8.1393, 2.3017), a: (-51.2222, 94.1542), t: 0.0810),
      near(3.4743, 4.2329, v: (7.8362, 2.8434), a: (-63.6668, 113.7452), t: 0.0857),
      near(3.5100, 4.2492, v: (7.5143, 3.4101), a: (-67.5926, 119.0224), t: 0.0905),
      near(3.5443, 4.2680, v: (7.2016, 3.9556), a: (-65.6568, 114.5394), t: 0.0952),
      near(3.5773, 4.2892, v: (6.9159, 4.4505), a: (-59.9999, 103.9444), t: 0.1000),
      near(3.6115, 4.3141, v: (6.1580, 4.4832), a: (-136.4312, 5.8833), t: 0.1056),
      near(3.6400, 4.3369, v: (5.1434, 4.0953), a: (-182.6254, -69.8314), t: 0.1111),
      near(3.6626, 4.3563, v: (4.0671, 3.4902), a: (-193.7401, -108.9119), t: 0.1167),
      near(3.6796, 4.3719, v: (3.0515, 2.8099), a: (-182.7957, -122.4598), t: 0.1222),
      near(3.6916, 4.3838, v: (2.1648, 2.1462), a: (-159.6116, -119.4551), t: 0.1278),
      near(3.6996, 4.3924, v: (1.4360, 1.5529), a: (-131.1906, -106.7926), t: 0.1333),
      near(3.7028, 4.3960, v: (1.1520, 1.3044), a: (-102.2117, -89.4872), t: 0.1361),
    ]);

    // The stroke is finished, so there's nothing to predict anymore.
    expect(modeler.predict, throwsA(isA<StateError>()));
  });

  test('InputRateSlowerThanMinOutputRateNormalProjection', () {
    const deltaTime = 1.0 / 30;

    final modeler = StrokeModeler();
    modeler.reset(makeParams(useStrokeNormalProjection: true));

    var time = Time(0);
    var results = modeler.update(input(.down, 3, 4, time));
    expectResults(results, [near(3, 4, t: 0)]);

    results = modeler.predict();
    expect(results, isEmpty);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 3.2, 4.2, time));
    expectResults(results, [
      near(3.0019, 4.0019, v: (0.4007, 0.4007), a: (84.1557, 84.1564), t: 0.0048),
      near(3.0069, 4.0069, v: (1.0381, 1.0381), a: (133.8378, 133.8369), t: 0.0095),
      near(3.0154, 4.0154, v: (1.7883, 1.7883), a: (157.5465, 157.5459), t: 0.0143),
      near(3.0276, 4.0276, v: (2.5626, 2.5626), a: (162.6039, 162.6021), t: 0.0190),
      near(3.0433, 4.0433, v: (3.3010, 3.3010), a: (155.0670, 155.0666), t: 0.0238),
      near(3.0622, 4.0622, v: (3.9665, 3.9665), a: (139.7575, 139.7564), t: 0.0286),
      near(3.0838, 4.0838, v: (4.5397, 4.5397), a: (120.3618, 120.3625), t: 0.0333),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(3.1095, 4.1095, v: (4.6253, 4.6253), a: (15.4218, 15.4223), t: 0.0389),
      near(3.1331, 4.1331, v: (4.2563, 4.2563), a: (-66.4341, -66.4339), t: 0.0444),
      near(3.1534, 4.1534, v: (3.6479, 3.6479), a: (-109.5083, -109.5081), t: 0.0500),
      near(3.1698, 4.1698, v: (2.9512, 2.9512), a: (-125.3978, -125.3976), t: 0.0556),
      near(3.1824, 4.1824, v: (2.2649, 2.2649), a: (-123.5318, -123.5310), t: 0.0611),
      near(3.1915, 4.1915, v: (1.6473, 1.6473), a: (-111.1818, -111.1806), t: 0.0667),
      near(3.1978, 4.1978, v: (1.1269, 1.1269), a: (-93.6643, -93.6636), t: 0.0722),
      near(3.1992, 4.1992, v: (1.0232, 1.0232), a: (-74.6390, -74.6392), t: 0.0736),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 3.5, 4.2, time));
    expectResults(results, [
      near(3.1086, 4.1058, v: (5.2142, 4.6131), a: (141.6557, 15.4223), t: 0.0381),
      near(3.1368, 4.1265, v: (5.9103, 4.3532), a: (146.1873, -54.5680), t: 0.0429),
      near(3.1681, 4.1450, v: (6.5742, 3.8917), a: (139.4012, -96.9169), t: 0.0476),
      near(3.2022, 4.1609, v: (7.1724, 3.3285), a: (125.6306, -118.2742), t: 0.0524),
      near(3.2388, 4.1739, v: (7.6876, 2.7361), a: (108.1908, -124.4087), t: 0.0571),
      near(3.2775, 4.1842, v: (8.1138, 2.1640), a: (89.5049, -120.1309), t: 0.0619),
      near(3.3177, 4.1920, v: (8.4531, 1.6436), a: (71.2473, -109.2959), t: 0.0667),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(3.3625, 4.1982, v: (8.0545, 1.1165), a: (-71.7427, -94.8765), t: 0.0722),
      near(3.4018, 4.2021, v: (7.0831, 0.6987), a: (-174.8469, -75.1957), t: 0.0778),
      near(3.4344, 4.2043, v: (5.8564, 0.3846), a: (-220.8140, -56.5515), t: 0.0833),
      near(3.4598, 4.2052, v: (4.5880, 0.1611), a: (-228.3204, -40.2244), t: 0.0889),
      near(3.4788, 4.2052, v: (3.4098, 0.0124), a: (-212.0678, -26.7709), t: 0.0944),
      near(3.4921, 4.2048, v: (2.3929, -0.0780), a: (-183.0373, -16.2648), t: 0.1000),
      near(3.4976, 4.2045, v: (1.9791, -0.1015), a: (-148.9792, -8.4822), t: 0.1028),
      near(3.5001, 4.2044, v: (1.7911, -0.1098), a: (-135.3759, -5.9543), t: 0.1042),
    ]);

    time = Time(time + deltaTime);
    // We get more results at the end of the stroke as it tries to "catch up" to
    // the raw input.
    results = modeler.update(input(.up, 3.7, 4.4, time));
    expectResults(results, [
      near(3.3583, 4.1996, v: (8.5122, 1.5925), a: (12.4129, -10.7201), t: 0.0714),
      near(3.3982, 4.2084, v: (8.3832, 1.8534), a: (-27.0783, 54.7731), t: 0.0762),
      near(3.4369, 4.2194, v: (8.1393, 2.3017), a: (-51.2222, 94.1542), t: 0.0810),
      near(3.4743, 4.2329, v: (7.8362, 2.8434), a: (-63.6668, 113.7452), t: 0.0857),
      near(3.5100, 4.2492, v: (7.5143, 3.4101), a: (-67.5926, 119.0224), t: 0.0905),
      near(3.5443, 4.2680, v: (7.2016, 3.9556), a: (-65.6568, 114.5394), t: 0.0952),
      near(3.5773, 4.2892, v: (6.9159, 4.4505), a: (-59.9999, 103.9444), t: 0.1000),
      near(3.6115, 4.3141, v: (6.1580, 4.4832), a: (-136.4312, 5.8833), t: 0.1056),
      near(3.6400, 4.3369, v: (5.1434, 4.0953), a: (-182.6254, -69.8314), t: 0.1111),
      near(3.6626, 4.3563, v: (4.0671, 3.4902), a: (-193.7401, -108.9119), t: 0.1167),
      near(3.6796, 4.3719, v: (3.0515, 2.8099), a: (-182.7957, -122.4598), t: 0.1222),
      near(3.6916, 4.3838, v: (2.1648, 2.1462), a: (-159.6116, -119.4551), t: 0.1278),
      near(3.6996, 4.3924, v: (1.4360, 1.5529), a: (-131.1906, -106.7926), t: 0.1333),
      near(3.7028, 4.3960, v: (1.1520, 1.3044), a: (-102.2117, -89.4872), t: 0.1361),
    ]);

    // The stroke is finished, so there's nothing to predict anymore.
    expect(modeler.predict, throwsA(isA<StateError>()));
  });

  test('InputRateSlowerThanMinOutputRateNormalProjectionWithLoopMitigation', () {
    const deltaTime = 1.0 / 30;
    final modeler = StrokeModeler();
    modeler.reset(
      makeParams(
        useStrokeNormalProjection: true,
        loopContractionMitigationParams: const LoopContractionMitigationParams(
          speedBound: Range(0, 10),
          interpolationStrengthAtSpeedLowerBound: 1,
          interpolationStrengthAtSpeedUpperBound: 0,
          minSpeedSamplingWindow: TimeSpan(20),
        ),
      ),
    );

    var time = Time(0);
    var results = modeler.update(input(.down, 3, 4, time));
    expectResults(results, [near(3, 4, t: 0)]);

    results = modeler.predict();
    expect(results, isEmpty);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 3.2, 4.2, time));
    expectResults(results, [
      near(3.0019, 4.0019, v: (0.4007, 0.4007), a: (84.1557, 84.1564), t: 0.0047619),
      near(3.0069, 4.0069, v: (0.9909, 0.9909), a: (126.6022, 126.6014), t: 0.00952381),
      near(3.0154, 4.0154, v: (1.6577, 1.6577), a: (143.4044, 143.4039), t: 0.0142857),
      near(3.0276, 4.0276, v: (2.3131, 2.3131), a: (142.7971, 142.7955), t: 0.0190476),
      near(3.0433, 4.0433, v: (2.9214, 2.9214), a: (133.0543, 133.0539), t: 0.0238095),
      near(3.0622, 4.0622, v: (3.4742, 3.4742), a: (120.1235, 120.1227), t: 0.0285714),
      near(3.0838, 4.0838, v: (3.9782, 3.9782), a: (107.9054, 107.9059), t: 0.0333333),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(3.10949, 4.10949, v: (4.19914, 4.19913), a: (41.8473, 41.8476), t: 0.0388889),
      near(3.13314, 4.13314, v: (4.16388, 4.16387), a: (-0.79512, -0.795006), t: 0.0444444),
      near(3.1534, 4.1534, v: (4.00923, 4.00922), a: (-15.7575, -15.7574), t: 0.05),
      near(3.1698, 4.1698, v: (3.80299, 3.80299), a: (-14.803, -14.803), t: 0.0555556),
      near(3.18238, 4.18238, v: (3.58047, 3.58046), a: (-5.50763, -5.50725), t: 0.0611111),
      near(3.19153, 4.19153, v: (3.36166, 3.36166), a: (7.42517, 7.42575), t: 0.0666667),
      near(3.19779, 4.19779, v: (3.15865, 3.15865), a: (21.1664, 21.1667), t: 0.0722222),
      near(3.19921, 4.19921, v: (3.12532, 3.12532), a: (33.1267, 33.1264), t: 0.0736111),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 3.5, 4.2, time));
    expectResults(results, [
      near(3.10806, 4.10611, v: (4.57574, 4.16572), a: (127.197, 41.096), t: 0.0380952),
      near(3.13529, 4.12867, v: (5.22357, 4.22006), a: (136.649, 7.26822), t: 0.0428571),
      near(3.16495, 4.1509, v: (5.88198, 4.24741), a: (141.224, -2.77902), t: 0.047619),
      near(3.19714, 4.17332, v: (6.55079, 4.3372), a: (144.959, 4.50102), t: 0.052381),
      near(3.23516, 4.18583, v: (7.05712, 3.94619), a: (136.785, -2.18567), t: 0.0571429),
      near(3.27574, 4.19189, v: (7.44526, 3.31069), a: (122.731, -17.3051), t: 0.0619048),
      near(3.31707, 4.19611, v: (7.79387, 2.68079), a: (109.01, -32.7855), t: 0.0666667),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(3.36237, 4.19918, v: (7.82404, 1.99092), a: (36.6682, -52.0924), t: 0.0722222),
      near(3.40191, 4.20095, v: (7.60028, 1.39536), a: (-12.3829, -68.1158), t: 0.0777778),
      near(3.43446, 4.20185, v: (7.2649, 0.907921), a: (-33.8065, -81.9532), t: 0.0833333),
      near(3.45987, 4.20219, v: (6.89701, 0.530171), a: (-38.1399, -92.9828), t: 0.0888889),
      near(3.4787, 4.20218, v: (6.53972, 0.253838), a: (-32.4934, -101.051), t: 0.0944444),
      near(3.49187, 4.20198, v: (6.21575, 0.0647929), a: (-21.597, -106.379), t: 0.1),
      near(3.49741, 4.20186, v: (6.08952, -0.00998237), a: (-8.04681, -107.375), t: 0.102778),
      near(3.4999, 4.20179, v: (6.03392, -0.0425394), a: (-2.64958, -108.264), t: 0.104167),
    ]);

    time = Time(time + deltaTime);
    // We get more results at the end of the stroke as it tries to "catch up" to
    // the raw input.
    results = modeler.update(input(.up, 3.7, 4.4, time));
    expectResults(results, [
      near(3.35822, 4.19982, v: (8.01552, 2.25652), a: (76.5494, -10.244), t: 0.0714286),
      near(3.3993, 4.20377, v: (8.17208, 1.93242), a: (54.3432, -8.91926), t: 0.0761905),
      near(3.44044, 4.20831, v: (8.30583, 1.63694), a: (39.2784, -23.511), t: 0.0809524),
      near(3.48211, 4.21358, v: (8.4475, 1.31753), a: (28.8514, -50.195), t: 0.0857143),
      near(3.51793, 4.23348, v: (8.20064, 1.77303), a: (14.8426, -36.1067), t: 0.0904762),
      near(3.5498, 4.25891, v: (7.81686, 2.5044), a: (0.631893, -7.71963), t: 0.0952381),
      near(3.58032, 4.2848, v: (7.44861, 3.20856), a: (-12.4313, 18.8486), t: 0.1),
      near(3.61221, 4.31318, v: (6.88897, 3.78287), a: (-57.1107, 16.5751), t: 0.105556),
      near(3.63911, 4.33797, v: (6.28318, 4.13534), a: (-87.8043, 19.4788), t: 0.111111),
      near(3.66068, 4.35842, v: (5.70713, 4.32859), a: (-103.24, 30.7454), t: 0.116667),
      near(3.67711, 4.3744, v: (5.20066, 4.40827), a: (-108.429, 45.5063), t: 0.122222),
      near(3.68899, 4.38625, v: (4.77974, 4.4096), a: (-107.076, 60.7109), t: 0.127778),
      near(3.69704, 4.39453, v: (4.44584, 4.36005), a: (-101.873, 74.6184), t: 0.133333),
      near(3.70043, 4.39806, v: (4.30761, 4.33629), a: (-93.7887, 84.475), t: 0.136111),
    ]);

    // The stroke is finished, so there's nothing to predict anymore.
    expect(modeler.predict, throwsA(isA<StateError>()));
  });

  test('InputRateFasterThanMinOutputRate', () {
    const deltaTime = 1.0 / 300;

    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var time = Time(2);
    var results = modeler.update(input(.down, 5, -3, time));
    expectResults(results, [near(5, -3, t: 2)]);

    results = modeler.predict();
    expect(results, isEmpty);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 5, -3.1, time));
    expectResults(results, [near(5, -3.0033, v: (0, -0.9818), a: (0, -294.5452), t: 2.0033)]);

    results = modeler.predict();
    expectResults(results, [
      near(5, -3.0153, v: (0, -2.1719), a: (0, -214.2145), t: 2.0089),
      near(5, -3.0303, v: (0, -2.6885), a: (0, -92.9885), t: 2.0144),
      near(5, -3.0456, v: (0, -2.7541), a: (0, -11.7992), t: 2.0200),
      near(5, -3.0597, v: (0, -2.5430), a: (0, 37.9868), t: 2.0256),
      near(5, -3.0718, v: (0, -2.1852), a: (0, 64.4053), t: 2.0311),
      near(5, -3.0817, v: (0, -1.7719), a: (0, 74.4011), t: 2.0367),
      near(5, -3.0893, v: (0, -1.3628), a: (0, 73.6345), t: 2.0422),
      near(5, -3.0948, v: (0, -0.9934), a: (0, 66.4807), t: 2.0478),
      near(5, -3.0986, v: (0, -0.6815), a: (0, 56.1448), t: 2.0533),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 4.975, -3.175, time));
    expectResults(results, [near(4.9992, -3.0114, v: (-0.2455, -2.4322), a: (-73.6366, -435.1238), t: 2.0067)]);

    results = modeler.predict();
    expectResults(results, [
      near(4.9962, -3.0344, v: (-0.5430, -4.1368), a: (-53.5537, -306.8140), t: 2.0122),
      near(4.9924, -3.0609, v: (-0.6721, -4.7834), a: (-23.2474, -116.3963), t: 2.0178),
      near(4.9886, -3.0873, v: (-0.6885, -4.7365), a: (-2.9498, 8.4358), t: 2.0233),
      near(4.9851, -3.1110, v: (-0.6358, -4.2778), a: (9.4971, 82.5682), t: 2.0289),
      near(4.9820, -3.1311, v: (-0.5463, -3.6137), a: (16.1014, 119.5413), t: 2.0344),
      near(4.9796, -3.1471, v: (-0.4430, -2.8867), a: (18.6005, 130.8578), t: 2.0400),
      near(4.9777, -3.1593, v: (-0.3407, -2.1881), a: (18.4089, 125.7516), t: 2.0456),
      near(4.9763, -3.1680, v: (-0.2484, -1.5700), a: (16.6198, 111.2560), t: 2.0511),
      near(4.9754, -3.1739, v: (-0.1704, -1.0564), a: (14.0365, 92.4447), t: 2.0567),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 4.9, -3.2, time));
    expectResults(results, [near(4.9953, -3.0237, v: (-1.1603, -3.7004), a: (-274.4622, -380.4507), t: 2.0100)]);

    results = modeler.predict();
    expectResults(results, [
      near(4.9828, -3.0521, v: (-2.2559, -5.1049), a: (-197.1994, -252.8115), t: 2.0156),
      near(4.9677, -3.0825, v: (-2.7081, -5.4835), a: (-81.4051, -68.1520), t: 2.0211),
      near(4.9526, -3.1115, v: (-2.7333, -5.2122), a: (-4.5282, 48.8396), t: 2.0267),
      near(4.9387, -3.1369, v: (-2.4999, -4.5756), a: (42.0094, 114.5943), t: 2.0322),
      near(4.9268, -3.1579, v: (-2.1326, -3.7776), a: (66.1132, 143.6292), t: 2.0378),
      near(4.9173, -3.1743, v: (-1.7184, -2.9554), a: (74.5656, 147.9932), t: 2.0433),
      near(4.9100, -3.1865, v: (-1.3136, -2.1935), a: (72.8575, 137.1578), t: 2.0489),
      near(4.9047, -3.1950, v: (-0.9513, -1.5369), a: (65.2090, 118.1874), t: 2.0544),
      near(4.9011, -3.2006, v: (-0.6475, -1.0032), a: (54.6929, 96.0608), t: 2.0600),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 4.825, -3.2, time));
    expectResults(results, [near(4.9868, -3.0389, v: (-2.5540, -4.5431), a: (-418.1093, -252.8115), t: 2.0133)]);

    results = modeler.predict();
    expectResults(results, [
      near(4.9636, -3.0687, v: (-4.1801, -5.3627), a: (-292.6871, -147.5319), t: 2.0189),
      near(4.9370, -3.0985, v: (-4.7757, -5.3670), a: (-107.2116, -0.7651), t: 2.0244),
      near(4.9109, -3.1256, v: (-4.6989, -4.8816), a: (13.8210, 87.3644), t: 2.0300),
      near(4.8875, -3.1486, v: (-4.2257, -4.1466), a: (85.1835, 132.2997), t: 2.0356),
      near(4.8677, -3.1671, v: (-3.5576, -3.3287), a: (120.2579, 147.2335), t: 2.0411),
      near(4.8520, -3.1812, v: (-2.8333, -2.5353), a: (130.3700, 142.8088), t: 2.0467),
      near(4.8401, -3.1914, v: (-2.1411, -1.8288), a: (124.5846, 127.1714), t: 2.0522),
      near(4.8316, -3.1982, v: (-1.5312, -1.2386), a: (109.7874, 106.2279), t: 2.0578),
      near(4.8280, -3.2010, v: (-1.2786, -1.0053), a: (90.9288, 84.0051), t: 2.0606),
      near(4.8272, -3.2017, v: (-1.2209, -0.9529), a: (83.2052, 75.4288), t: 2.0613),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 4.75, -3.225, time));
    expectResults(results, [near(4.9726, -3.0565, v: (-4.2660, -5.2803), a: (-513.5957, -221.1678), t: 2.0167)]);

    results = modeler.predict();
    expectResults(results, [
      near(4.9381, -3.0894, v: (-6.2018, -5.9261), a: (-348.4476, -116.2445), t: 2.0222),
      near(4.9004, -3.1215, v: (-6.7995, -5.7749), a: (-107.5834, 27.2264), t: 2.0278),
      near(4.8640, -3.1501, v: (-6.5400, -5.1591), a: (46.7146, 110.8336), t: 2.0333),
      near(4.8319, -3.1741, v: (-5.7897, -4.3207), a: (135.0462, 150.9226), t: 2.0389),
      near(4.8051, -3.1932, v: (-4.8132, -3.4248), a: (175.7684, 161.2555), t: 2.0444),
      near(4.7841, -3.2075, v: (-3.7898, -2.5759), a: (184.2227, 152.7958), t: 2.0500),
      near(4.7683, -3.2176, v: (-2.8312, -1.8324), a: (172.5480, 133.8294), t: 2.0556),
      near(4.7572, -3.2244, v: (-1.9986, -1.2198), a: (149.8577, 110.2830), t: 2.0611),
      near(4.7526, -3.2271, v: (-1.6580, -0.9805), a: (122.6198, 86.1299), t: 2.0639),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 4.7, -3.3, time));
    expectResults(results, [near(4.9529, -3.0778, v: (-5.9184, -6.4042), a: (-495.7209, -337.1538), t: 2.0200)]);

    results = modeler.predict();
    expectResults(results, [
      near(4.9101, -3.1194, v: (-7.6886, -7.4784), a: (-318.6394, -193.3594), t: 2.0256),
      near(4.8654, -3.1607, v: (-8.0518, -7.4431), a: (-65.3698, 6.3579), t: 2.0311),
      near(4.8235, -3.1982, v: (-7.5377, -6.7452), a: (92.5345, 125.6104), t: 2.0367),
      near(4.7872, -3.2299, v: (-6.5440, -5.7133), a: (178.8654, 185.7426), t: 2.0422),
      near(4.7574, -3.2553, v: (-5.3529, -4.5748), a: (214.4027, 204.9362), t: 2.0478),
      near(4.7344, -3.2746, v: (-4.1516, -3.4758), a: (216.2348, 197.8224), t: 2.0533),
      near(4.7174, -3.2885, v: (-3.0534, -2.5004), a: (197.6767, 175.5702), t: 2.0589),
      near(4.7056, -3.2979, v: (-2.1169, -1.6879), a: (168.5711, 146.2573), t: 2.0644),
      near(4.7030, -3.3000, v: (-1.9283, -1.5276), a: (135.7820, 115.3739), t: 2.0658),
      near(4.7017, -3.3010, v: (-1.8380, -1.4512), a: (130.0928, 110.0859), t: 2.0665),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 4.675, -3.4, time));
    expectResults(results, [near(4.9288, -3.1046, v: (-7.2260, -8.0305), a: (-392.2747, -487.9053), t: 2.0233)]);

    results = modeler.predict();
    expectResults(results, [
      near(4.8816, -3.1582, v: (-8.4881, -9.6525), a: (-227.1831, -291.9628), t: 2.0289),
      near(4.8345, -3.2124, v: (-8.4738, -9.7482), a: (2.5870, -17.2266), t: 2.0344),
      near(4.7918, -3.2619, v: (-7.6948, -8.9195), a: (140.2131, 149.1810), t: 2.0400),
      near(4.7555, -3.3042, v: (-6.5279, -7.6113), a: (210.0428, 235.4638), t: 2.0456),
      near(4.7264, -3.3383, v: (-5.2343, -6.1345), a: (232.8451, 265.8274), t: 2.0511),
      near(4.7043, -3.3643, v: (-3.9823, -4.6907), a: (225.3593, 259.8790), t: 2.0567),
      near(4.6884, -3.3832, v: (-2.8691, -3.3980), a: (200.3802, 232.6849), t: 2.0622),
      near(4.6776, -3.3961, v: (-1.9403, -2.3135), a: (167.1764, 195.2152), t: 2.0678),
      near(4.6752, -3.3990, v: (-1.7569, -2.0983), a: (132.0560, 154.9868), t: 2.0692),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 4.675, -3.525, time));
    expectResults(results, [near(4.9022, -3.1387, v: (-7.9833, -10.2310), a: (-227.1831, -660.1446), t: 2.0267)]);

    results = modeler.predict();
    expectResults(results, [
      near(4.8549, -3.2079, v: (-8.5070, -12.4602), a: (-94.2781, -401.2599), t: 2.0322),
      near(4.8102, -3.2783, v: (-8.0479, -12.6650), a: (82.6390, -36.8616), t: 2.0378),
      near(4.7711, -3.3429, v: (-7.0408, -11.6365), a: (181.2765, 185.1286), t: 2.0433),
      near(4.7389, -3.3983, v: (-5.7965, -9.9616), a: (223.9801, 301.4933), t: 2.0489),
      near(4.7137, -3.4430, v: (-4.5230, -8.0510), a: (229.2397, 343.9032), t: 2.0544),
      near(4.6951, -3.4773, v: (-3.3477, -6.1727), a: (211.5554, 338.0856), t: 2.0600),
      near(4.6821, -3.5022, v: (-2.3381, -4.4846), a: (181.7131, 303.8597), t: 2.0656),
      near(4.6737, -3.5192, v: (-1.5199, -3.0641), a: (147.2879, 255.7003), t: 2.0711),
      near(4.6718, -3.5231, v: (-1.3626, -2.7813), a: (113.2437, 203.5595), t: 2.0725),
    ]);

    time = Time(time + deltaTime);
    // We get more results at the end of the stroke as it tries to "catch up" to
    // the raw input.
    results = modeler.update(input(.up, 4.7, -3.6, time));
    expectResults(results, [
      near(4.8753, -3.1797, v: (-8.0521, -12.3049), a: (-20.6429, -622.1685), t: 2.0300),
      near(4.8325, -3.2589, v: (-7.7000, -14.2607), a: (63.3680, -352.0363), t: 2.0356),
      near(4.7948, -3.3375, v: (-6.7888, -14.1377), a: (164.0215, 22.1350), t: 2.0411),
      near(4.7636, -3.4085, v: (-5.6249, -12.7787), a: (209.5020, 244.6249), t: 2.0467),
      near(4.7390, -3.4685, v: (-4.4152, -10.8015), a: (217.7452, 355.8801), t: 2.0522),
      near(4.7208, -3.5164, v: (-3.2880, -8.6333), a: (202.8961, 390.2804), t: 2.0578),
      near(4.7079, -3.5528, v: (-2.3128, -6.5475), a: (175.5414, 375.4407), t: 2.0633),
      near(4.6995, -3.5789, v: (-1.5174, -4.7008), a: (143.1705, 332.4062), t: 2.0689),
      near(4.6945, -3.5965, v: (-0.9022, -3.1655), a: (110.7325, 276.3669), t: 2.0744),
      near(4.6942, -3.5976, v: (-0.8740, -3.0899), a: (81.2036, 217.6189), t: 2.0748),
    ]);

    // The stroke is finished, so there's nothing to predict anymore.
    expect(modeler.predict, throwsA(isA<StateError>()));
  });

  test('WobbleSmoothed', () {
    const deltaTime = 0.0167;

    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var time = Time(4);
    var results = modeler.update(input(.down, -6, -2, time));
    expectResults(results, [near(-6, -2, t: 4)]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -6.02, -2, time));
    expectResults(results, [
      near(-6.0003, -2, v: (-0.0615, 0), a: (-14.7276, 0), t: 4.0042),
      near(-6.0009, -2, v: (-0.1628, 0), a: (-24.2725, 0), t: 4.0084),
      near(-6.0021, -2, v: (-0.2868, 0), a: (-29.6996, 0), t: 4.0125),
      near(-6.0039, -2, v: (-0.4203, 0), a: (-31.9728, 0), t: 4.0167),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -6.02, -2.02, time));
    expectResults(results, [
      near(-6.0059, -2.0001, v: (-0.4921, -0.0307), a: (-17.1932, -7.3638), t: 4.0209),
      near(-6.0081, -2.0005, v: (-0.5170, -0.0814), a: (-5.9729, -12.1355), t: 4.0251),
      near(-6.0102, -2.0010, v: (-0.5079, -0.1434), a: (2.1807, -14.8493), t: 4.0292),
      near(-6.0122, -2.0019, v: (-0.4755, -0.2101), a: (7.7710, -15.9860), t: 4.0334),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -6.04, -2.02, time));
    expectResults(results, [
      near(-6.0141, -2.0030, v: (-0.4489, -0.2563), a: (6.3733, -11.0507), t: 4.0376),
      near(-6.0159, -2.0042, v: (-0.4277, -0.2856), a: (5.0670, -7.0315), t: 4.0418),
      near(-6.0176, -2.0055, v: (-0.4115, -0.3018), a: (3.8950, -3.8603), t: 4.0459),
      near(-6.0193, -2.0067, v: (-0.3994, -0.3078), a: (2.8758, -1.4435), t: 4.0501),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -6.04, -2.04, time));
    expectResults(results, [
      near(-6.0209, -2.0082, v: (-0.3910, -0.3372), a: (2.0142, -7.0427), t: 4.0543),
      near(-6.0225, -2.0098, v: (-0.3856, -0.3814), a: (1.3090, -10.5977), t: 4.0585),
      near(-6.0241, -2.0116, v: (-0.3825, -0.4338), a: (0.7470, -12.5399), t: 4.0626),
      near(-6.0257, -2.0136, v: (-0.3811, -0.4891), a: (0.3174, -13.2543), t: 4.0668),
    ]);
  });

  test('WobbleNotSmoothedIfNotEnabled', () {
    const deltaTime = 0.0167;

    final modeler = StrokeModeler();
    modeler.reset(makeParams(wobbleSmootherParams: null));

    var time = Time(4);
    var results = modeler.update(input(.down, -6, -2, time));
    expectResults(results, [near(-6, -2, t: 4)]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -6.02, -2, time));
    expectResults(results, [
      near(-6.0003, -2, v: (-0.0615, 0), a: (-14.7276, 0), t: 4.0042),
      near(-6.0009, -2, v: (-0.1628, 0), a: (-24.2725, 0), t: 4.0084),
      near(-6.0021, -2, v: (-0.2868, 0), a: (-29.6996, 0), t: 4.0125),
      near(-6.0039, -2, v: (-0.4203, 0), a: (-31.9728, 0), t: 4.0167),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -6.02, -2.02, time));
    expectResults(results, [
      near(-6.0059, -2.0003, v: (-0.4921, -0.0615), a: (-17.1932, -14.7276), t: 4.0209),
      near(-6.0081, -2.0009, v: (-0.5170, -0.1628), a: (-5.9729, -24.2711), t: 4.0251),
      near(-6.0102, -2.0021, v: (-0.5079, -0.2868), a: (2.1807, -29.7000), t: 4.0292),
      near(-6.0122, -2.0039, v: (-0.4755, -0.4203), a: (7.7710, -31.9724), t: 4.0334),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -6.04, -2.02, time));
    expectResults(results, [
      near(-6.0143, -2.0059, v: (-0.4899, -0.4921), a: (-3.4456, -17.1929), t: 4.0376),
      near(-6.0165, -2.0081, v: (-0.5363, -0.5170), a: (-11.1122, -5.9734), t: 4.0418),
      near(-6.0190, -2.0102, v: (-0.6027, -0.5079), a: (-15.9053, 2.1804), t: 4.0459),
      near(-6.0218, -2.0122, v: (-0.6796, -0.4755), a: (-18.4402, 7.7708), t: 4.0501),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -6.04, -2.04, time));
    expectResults(results, [
      near(-6.0248, -2.0143, v: (-0.6986, -0.4899), a: (-4.5389, -3.4458), t: 4.0543),
      near(-6.0276, -2.0165, v: (-0.6760, -0.5363), a: (5.4168, -11.1130), t: 4.0585),
      near(-6.0302, -2.0190, v: (-0.6255, -0.6027), a: (12.1018, -15.9045), t: 4.0626),
      near(-6.0325, -2.0218, v: (-0.5580, -0.6796), a: (16.1550, -18.4404), t: 4.0668),
    ]);
  });

  test('UpdateAppendsToResults', () {
    // In the C++ API `Update` appends to a caller-owned vector; here each call returns its own list,
    // so concatenating them is the equivalent check.
    const deltaTime = 1.0 / 300;

    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var time = Time(2);
    final results = <Result>[];
    results.addAll(modeler.update(input(.down, 5, -3, time)));
    final firstResult = near(5, -3, t: 2);
    expectResults(results, [firstResult]);

    time = Time(time + deltaTime);
    results.addAll(modeler.update(input(.move, 5, -3.1, time)));
    expectResults(results, [
      firstResult,
      near(5, -3.0033, v: (0, -0.9818), a: (0, -294.5452), t: 2.0033),
    ]);
  });

  test('Reset', () {
    const deltaTime = 1.0 / 50;

    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var time = Time(0);
    var results = modeler.update(input(.down, -8, -10, time));
    expect(results, isNotEmpty);

    results = modeler.predict();
    expect(results, isEmpty);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 0, 0, time));
    expect(results, isNotEmpty);

    results = modeler.predict();
    expect(results, isNotEmpty);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, -11, -5, time));
    expect(results, isNotEmpty);

    results = modeler.predict();
    expect(results, isNotEmpty);

    modeler.reset(defaultParams);
    expect(modeler.predict, throwsA(isA<StateError>()));
  });

  test('IgnoreInputsBeforeTDown', () {
    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    expect(() => modeler.update(input(.move, 0, 0, 0)), throwsA(isA<StateError>()));

    expect(() => modeler.update(input(.up, 0, 0, 1)), throwsA(isA<StateError>()));
  });

  test('IgnoreTDownWhileStrokeIsInProgress', () {
    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var results = modeler.update(input(.down, 0, 0, 0));
    expect(results, isNotEmpty);

    expect(() => modeler.update(input(.down, 1, 1, 1)), throwsA(isA<StateError>()));

    results = modeler.update(input(.move, 1, 1, 1));
    expect(results, isNotEmpty);

    expect(() => modeler.update(input(.down, 2, 2, 2)), throwsA(isA<StateError>()));
  });

  test('AlternateParams', () {
    const deltaTime = 1.0 / 50;

    final modeler = StrokeModeler();
    modeler.reset(makeParams(minOutputRate: 70));

    var time = Time(3);
    var results = modeler.update(input(.down, 0, 0, time, p: 0.5, tilt: 0.2, o: 0.4));
    expectResults(results, [near(0, 0, v: (0, 0), a: (0, 0), t: 3, p: 0.5, tilt: 0.2, o: 0.4)]);

    results = modeler.predict();
    expect(results, isEmpty);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 0, 0.5, time, p: 0.4, tilt: 0.3, o: 0.3));
    expectResults(results, [
      near(0, 0.0736, v: (0, 7.3636), a: (0, 736.3636), t: 3.0100, p: 0.4853, tilt: 0.2147, o: 0.3853),
      near(0, 0.2198, v: (0, 14.6202), a: (0, 725.6529), t: 3.0200, p: 0.4560, tilt: 0.2440, o: 0.3560),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(0, 0.3823, v: (0, 11.3709), a: (0, -227.4474), t: 3.0343, p: 0.4235, tilt: 0.2765, o: 0.3235),
      near(0, 0.4484, v: (0, 4.6285), a: (0, -471.9660), t: 3.0486, p: 0.4103, tilt: 0.2897, o: 0.3103),
      near(0, 0.4775, v: (0, 2.0389), a: (0, -181.2747), t: 3.0629, p: 0.4045, tilt: 0.2955, o: 0.3045),
      near(0, 0.4902, v: (0, 0.8873), a: (0, -80.6136), t: 3.0771, p: 0.4020, tilt: 0.2980, o: 0.3020),
      near(0, 0.4957, v: (0, 0.3868), a: (0, -35.0318), t: 3.0914, p: 0.4009, tilt: 0.2991, o: 0.3009),
      near(0, 0.4981, v: (0, 0.1686), a: (0, -15.2760), t: 3.1057, p: 0.4004, tilt: 0.2996, o: 0.3004),
      near(0, 0.4992, v: (0, 0.0735), a: (0, -6.6579), t: 3.1200, p: 0.4002, tilt: 0.2998, o: 0.3002),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 0.2, 1, time, p: 0.3, tilt: 0.4, o: 0.2));
    expectResults(results, [
      near(
        0.0295,
        0.4169,
        v: (2.9455, 19.7093),
        a: (294.5455, 508.9161),
        t: 3.0300,
        p: 0.4166,
        tilt: 0.2834,
        o: 0.3166,
      ),
      near(
        0.0879,
        0.6439,
        v: (5.8481, 22.6926),
        a: (290.2612, 298.3311),
        t: 3.0400,
        p: 0.3691,
        tilt: 0.3309,
        o: 0.2691,
      ),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(
        0.1529,
        0.8487,
        v: (4.5484, 14.3374),
        a: (-90.9790, -584.8687),
        t: 3.0543,
        p: 0.3293,
        tilt: 0.3707,
        o: 0.2293,
      ),
      near(
        0.1794,
        0.9338,
        v: (1.8514, 5.9577),
        a: (-188.7864, -586.5760),
        t: 3.0686,
        p: 0.3128,
        tilt: 0.3872,
        o: 0.2128,
      ),
      near(
        0.1910,
        0.9712,
        v: (0.8156, 2.6159),
        a: (-72.5099, -233.9289),
        t: 3.0829,
        p: 0.3056,
        tilt: 0.3944,
        o: 0.2056,
      ),
      near(
        0.1961,
        0.9874,
        v: (0.3549, 1.1389),
        a: (-32.2455, -103.3868),
        t: 3.0971,
        p: 0.3024,
        tilt: 0.3976,
        o: 0.2024,
      ),
      near(0.1983, 0.9945, v: (0.1547, 0.4965), a: (-14.0127, -44.9693), t: 3.1114, p: 0.3011, tilt: 0.3989, o: 0.2011),
      near(0.1993, 0.9976, v: (0.0674, 0.2164), a: (-6.1104, -19.6068), t: 3.1257, p: 0.3005, tilt: 0.3995, o: 0.2005),
      near(0.1997, 0.9990, v: (0.0294, 0.0943), a: (-2.6631, -8.5455), t: 3.1400, p: 0.3002, tilt: 0.3998, o: 0.2002),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 0.4, 1.4, time, p: 0.2, tilt: 0.7, o: 0));
    expectResults(results, [
      near(0.1668, 0.8712, v: (7.8837, 22.7349), a: (203.5665, 4.2224), t: 3.0500, p: 0.3245, tilt: 0.3755, o: 0.2245),
      near(
        0.2575,
        1.0906,
        v: (9.0771, 21.9411),
        a: (119.3324, -79.3721),
        t: 3.0600,
        p: 0.2761,
        tilt: 0.4716,
        o: 0.1522,
      ),
    ]);

    results = modeler.predict();
    expectResults(results, [
      near(
        0.3395,
        1.2676,
        v: (5.7349, 12.3913),
        a: (-233.9475, -668.4906),
        t: 3.0743,
        p: 0.2325,
        tilt: 0.6024,
        o: 0.0651,
      ),
      near(
        0.3735,
        1.3421,
        v: (2.3831, 5.2156),
        a: (-234.6304, -502.2992),
        t: 3.0886,
        p: 0.2142,
        tilt: 0.6573,
        o: 0.0284,
      ),
      near(
        0.3885,
        1.3748,
        v: (1.0463, 2.2854),
        a: (-93.5716, -205.1091),
        t: 3.1029,
        p: 0.2062,
        tilt: 0.6814,
        o: 0.0124,
      ),
      near(0.3950, 1.3890, v: (0.4556, 0.9954), a: (-41.3547, -90.3064), t: 3.1171, p: 0.2027, tilt: 0.6919, o: 0.0054),
      near(0.3978, 1.3952, v: (0.1986, 0.4339), a: (-17.9877, -39.3021), t: 3.1314, p: 0.2012, tilt: 0.6965, o: 0.0024),
      near(0.3990, 1.3979, v: (0.0866, 0.1891), a: (-7.8428, -17.1346), t: 3.1457, p: 0.2005, tilt: 0.6985, o: 0.0010),
      near(0.3996, 1.3991, v: (0.0377, 0.0824), a: (-3.4182, -7.4680), t: 3.1600, p: 0.2002, tilt: 0.6993, o: 0.0004),
    ]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.up, 0.7, 1.7, time, p: 0.1, tilt: 1, o: 0));
    expectResults(results, [
      near(
        0.3691,
        1.2874,
        v: (11.1558, 19.6744),
        a: (207.8707, -226.6725),
        t: 3.0700,
        p: 0.2256,
        tilt: 0.6231,
        o: 0.0512,
      ),
      near(0.4978, 1.4640, v: (12.8701, 17.6629), a: (171.4340, -201.1508), t: 3.0800, p: 0.1730, tilt: 0.7809, o: 0),
      near(0.6141, 1.5986, v: (8.1404, 9.4261), a: (-331.0815, -576.5752), t: 3.0943, p: 0.1312, tilt: 0.9064, o: 0),
      near(0.6624, 1.6557, v: (3.3822, 3.9953), a: (-333.0701, -380.1579), t: 3.1086, p: 0.1136, tilt: 0.9591, o: 0),
      near(0.6836, 1.6807, v: (1.4851, 1.7488), a: (-132.8005, -157.2520), t: 3.1229, p: 0.1059, tilt: 0.9822, o: 0),
      near(0.6929, 1.6916, v: (0.6466, 0.7618), a: (-58.6943, -69.0946), t: 3.1371, p: 0.1026, tilt: 0.9922, o: 0),
      near(0.6969, 1.6963, v: (0.2819, 0.3321), a: (-25.5298, -30.0794), t: 3.1514, p: 0.1011, tilt: 0.9966, o: 0),
      near(0.6986, 1.6984, v: (0.1229, 0.1447), a: (-11.1311, -13.1133), t: 3.1657, p: 0.1005, tilt: 0.9985, o: 0),
      near(0.6994, 1.6993, v: (0.0535, 0.0631), a: (-4.8514, -5.7153), t: 3.1800, p: 0.1002, tilt: 0.9994, o: 0),
    ]);

    expect(modeler.predict, throwsA(isA<StateError>()));
  });

  test('GenerateOutputOnTUpEvenIfNoTimeDelta', () {
    const deltaTime = 1.0 / 500;

    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var time = Time(0);
    var results = modeler.update(input(.down, 5, 5, time));
    expectResults(results, [near(5, 5, t: 0)]);

    time = Time(time + deltaTime);
    results = modeler.update(input(.move, 5, 5, time));
    expectResults(results, [near(5, 5, t: 0.002)]);

    results = modeler.update(input(.up, 5, 5, time));
    expectResults(results, [near(5, 5, t: 0.0076)]);
  });

  test('RejectInputIfNegativeTimeDelta', () {
    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var results = modeler.update(input(.down, 0, 0, 0));
    expect(results, isNotEmpty);

    expect(() => modeler.update(input(.move, 1, 1, -0.1)), throwsA(isA<ArgumentError>()));

    results = modeler.update(input(.move, 1, 1, 1));
    expect(results, isNotEmpty);

    expect(() => modeler.update(input(.up, 1, 1, 0.9)), throwsA(isA<ArgumentError>()));
  });

  test('RejectDuplicateInput', () {
    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var results = modeler.update(input(.down, 0, 0, 0, p: 0.2, tilt: 0.3, o: 0.4));
    expect(results, isNotEmpty);

    expect(() => modeler.update(input(.down, 0, 0, 0, p: 0.2, tilt: 0.3, o: 0.4)), throwsA(isA<ArgumentError>()));

    results = modeler.update(input(.move, 1, 2, 1, p: 0.1, tilt: 0.2, o: 0.3));
    expect(results, isNotEmpty);

    expect(() => modeler.update(input(.move, 1, 2, 1, p: 0.1, tilt: 0.2, o: 0.3)), throwsA(isA<ArgumentError>()));
  });

  test('FarApartTimesDoNotCrashForMove', () {
    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var results = modeler.update(input(.down, 0, 0, 0, p: 0.2, tilt: 0.3, o: 0.4));
    expect(results, isNotEmpty);

    expect(() => modeler.update(input(.move, 0, 0, intMax, p: 0.2, tilt: 0.3, o: 0.4)), throwsA(isA<ArgumentError>()));
  });

  test('FarApartTimesDoNotCrashForUp', () {
    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    var results = modeler.update(input(.down, 0, 0, 0, p: 0.2, tilt: 0.3, o: 0.4));
    expect(results, isNotEmpty);

    expect(() => modeler.update(input(.up, 0, 0, intMax, p: 0.2, tilt: 0.3, o: 0.4)), throwsA(isA<ArgumentError>()));
  });

  test('FirstResetMustPassParams', () {
    final modeler = StrokeModeler();
    expect(modeler.reset, throwsA(isA<StateError>()));
  });

  test('ResetKeepsParamsAndResetsStroke', () {
    final modeler = StrokeModeler();
    // Initialize with parameters and update.
    final pointerDown = input(.down, 3, 4, 0);
    modeler.reset(defaultParams);
    modeler.update(pointerDown);

    // Reset, using the same parameters.
    modeler.reset();

    // Doesn't object to seeing a duplicate input or another down event, since
    // the previous stroke in progress was aborted by the call to reset.
    modeler.update(pointerDown);
  });

  test('SaveAndRestore', () {
    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    // Create a save that will be overwritten.
    modeler.save();
    var results = modeler.update(input(.down, -6, -2, 4));
    expectResults(results, [near(-6, -2, t: 4)]);

    // Save a second time and then finish the stroke.
    modeler.save();

    results = modeler.update(input(.up, -6.02, -2, 4.0167));
    expectResults(results, [
      near(-6.0003, -2, v: (-0.0615, 0), a: (-14.7276, 0), t: 4.0042),
      near(-6.0009, -2, v: (-0.1628, 0), a: (-24.2725, 0), t: 4.0084),
      near(-6.0021, -2, v: (-0.2868, 0), a: (-29.6996, 0), t: 4.0125),
      near(-6.0039, -2, v: (-0.4203, 0), a: (-31.9728, 0), t: 4.0167),
      near(-6.0068, -2, v: (-0.5158, 0), a: (-17.1932, 0), t: 4.0223),
      near(-6.0097, -2, v: (-0.5262, 0), a: (-1.8749, 0), t: 4.0278),
      near(-6.0124, -2, v: (-0.4847, 0), a: (7.4861, 0), t: 4.0334),
      near(-6.0147, -2, v: (-0.4156, 0), a: (12.4229, 0), t: 4.0389),
      near(-6.0165, -2, v: (-0.3364, 0), a: (14.2557, 0), t: 4.0445),
      near(-6.0180, -2, v: (-0.2583, 0), a: (14.0591, 0), t: 4.0500),
      near(-6.0190, -2, v: (-0.1880, 0), a: (12.6630, 0), t: 4.0556),
    ]);

    // Restore and finish the stroke again.
    modeler.restore();
    results = modeler.update(input(.up, -6.02, -2, 4.0167));
    expectResults(results, [
      near(-6.0003, -2, v: (-0.0615, 0), a: (-14.7276, 0), t: 4.0042),
      near(-6.0009, -2, v: (-0.1628, 0), a: (-24.2725, 0), t: 4.0084),
      near(-6.0021, -2, v: (-0.2868, 0), a: (-29.6996, 0), t: 4.0125),
      near(-6.0039, -2, v: (-0.4203, 0), a: (-31.9728, 0), t: 4.0167),
      near(-6.0068, -2, v: (-0.5158, 0), a: (-17.1932, 0), t: 4.0223),
      near(-6.0097, -2, v: (-0.5262, 0), a: (-1.8749, 0), t: 4.0278),
      near(-6.0124, -2, v: (-0.4847, 0), a: (7.4861, 0), t: 4.0334),
      near(-6.0147, -2, v: (-0.4156, 0), a: (12.4229, 0), t: 4.0389),
      near(-6.0165, -2, v: (-0.3364, 0), a: (14.2557, 0), t: 4.0445),
      near(-6.0180, -2, v: (-0.2583, 0), a: (14.0591, 0), t: 4.0500),
      near(-6.0190, -2, v: (-0.1880, 0), a: (12.6630, 0), t: 4.0556),
    ]);

    // Restoring should not have cleared the save, so repeat one more time.
    modeler.restore();
    results = modeler.update(input(.up, -6.02, -2, 4.0167));
    expectResults(results, [
      near(-6.0003, -2, v: (-0.0615, 0), a: (-14.7276, 0), t: 4.0042),
      near(-6.0009, -2, v: (-0.1628, 0), a: (-24.2725, 0), t: 4.0084),
      near(-6.0021, -2, v: (-0.2868, 0), a: (-29.6996, 0), t: 4.0125),
      near(-6.0039, -2, v: (-0.4203, 0), a: (-31.9728, 0), t: 4.0167),
      near(-6.0068, -2, v: (-0.5158, 0), a: (-17.1932, 0), t: 4.0223),
      near(-6.0097, -2, v: (-0.5262, 0), a: (-1.8749, 0), t: 4.0278),
      near(-6.0124, -2, v: (-0.4847, 0), a: (7.4861, 0), t: 4.0334),
      near(-6.0147, -2, v: (-0.4156, 0), a: (12.4229, 0), t: 4.0389),
      near(-6.0165, -2, v: (-0.3364, 0), a: (14.2557, 0), t: 4.0445),
      near(-6.0180, -2, v: (-0.2583, 0), a: (14.0591, 0), t: 4.0500),
      near(-6.0190, -2, v: (-0.1880, 0), a: (12.6630, 0), t: 4.0556),
    ]);

    // Calling Reset() should clear the save point so calling Restore() again
    // should have no effect.
    modeler.reset();
    results = modeler.update(input(.down, -6, -2, 4));
    expectResults(results, [near(-6, -2, t: 4)]);
    results = modeler.update(input(.up, -6.02, -2, 4.0167));

    modeler.restore();

    // Restore should have no effect so we cannot finish the line again.
    expect(() => modeler.update(input(.up, -6.02, -2, 4.0167)), throwsA(isA<StateError>()));
  });

  test('UpdateUpdateIdenticalToUpdatePredictUpdate', () {
    final input1 = input(.down, -6, -2, 0, p: 0.5, tilt: 0.5, o: 0.5);
    final input2 = input(.move, -6.2, -2, 0.0167, p: 0.48, tilt: 0.4, o: 0.4);
    final input3 = input(.move, -6.2, -2.2, 0.0334, p: 0.48, tilt: 0.4, o: 0.4);

    final modeler = StrokeModeler();
    modeler.reset(defaultParams);

    // Run the first 2 input updates, then a prediction, then the last input.
    modeler.update(input1);
    modeler.update(input2);
    modeler.predict();
    final resultsWithPredict = modeler.update(input3);

    // Reset the modeler and run the same 3 input updates again but without prediction.
    modeler.reset(defaultParams);
    modeler.update(input1);
    modeler.update(input2);
    final resultsWithoutPredict = modeler.update(input3);

    // The results for both runs should be the same.
    expectSameResults(resultsWithPredict, resultsWithoutPredict);
  });
}
