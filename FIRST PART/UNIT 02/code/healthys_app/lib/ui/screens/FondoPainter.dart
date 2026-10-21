import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FondoPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.green.shade200, Colors.orange.shade200],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Punt inicial, lleugerament per baix de la part superior
    path.moveTo(size.width / 2, size.height * 0.35);

    // Corba de la meitat esquerra superior
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.1,
      size.width * 0.1,
      size.height * 0.3,
    );

    // Corba de baix esquerra fins a la punta inferior
    path.quadraticBezierTo(
      0,
      size.height * 0.6,
      size.width / 2,
      size.height * 0.9,
    );

    // Corba de baix dreta
    path.quadraticBezierTo(
      size.width,
      size.height * 0.6,
      size.width * 0.9,
      size.height * 0.3,
    );

    // Corba de la meitat dreta superior
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.1,
      size.width / 2,
      size.height * 0.35,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}