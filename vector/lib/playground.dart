import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:vgc/debug/debug_draw.dart';
import 'package:vgc/vgc.dart';

class VectorPlayground extends StatelessWidget {
  const VectorPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    final complex = VectorComplex();

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200.0,
          height: 200.0,
          child: CustomPaint(
            painter: _VectorComplexPainter(complex: complex),
          ),
        ),
      ),
    );
  }
}

class _VectorComplexPainter extends CustomPainter {
  const _VectorComplexPainter({
    required this.complex,
  });

  final VectorComplex complex;

  @override
  void paint(Canvas canvas, Size size) {
    drawDebugVectorComplex(canvas, complex);
  }

  @override
  bool shouldRepaint(_VectorComplexPainter oldDelegate) => true;
}
