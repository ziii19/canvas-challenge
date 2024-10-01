import 'package:flutter/material.dart';

enum TriangleDirection { up, down, left, right }

class TrianglePainter extends CustomPainter {
  final TriangleDirection direction;

  TrianglePainter(this.direction);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF049F9A);
    final path = Path();

    switch (direction) {
      case TriangleDirection.up:
        path
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height);
        break;

      case TriangleDirection.down:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width / 2, size.height)
          ..lineTo(size.width, 0);
        break;

      case TriangleDirection.left:
        path
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height);
        break;

      case TriangleDirection.right:
        path
          ..moveTo(size.width, size.height / 2)
          ..lineTo(0, 0)
          ..lineTo(0, size.height);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
