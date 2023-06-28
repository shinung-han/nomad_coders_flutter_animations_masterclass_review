import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Apple Watch'),
      ),
      body: Center(
        child: CustomPaint(
          painter: AppleWatchPainter(),
          size: const Size(400, 400),
        ),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // draw red
    final redCirclePaint = Paint()
      ..color = const Color(0xfff2124e).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45;

    final redCircleRadius = (size.width / 2) * 0.9;

    canvas.drawCircle(center, redCircleRadius, redCirclePaint);

    // draw green
    final greenCirclePaint = Paint()
      ..color = const Color(0xffa6fa01).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45;

    canvas.drawCircle(center, (size.width / 2) * 0.65, greenCirclePaint);

    // draw blue
    final blueCirclePaint = Paint()
      ..color = const Color(0xff00dff4).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45;

    canvas.drawCircle(center, (size.width / 2) * 0.40, blueCirclePaint);

    // red arc
    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);

    final redArcPaint = Paint()
      ..color = const Color(0xfff2124e)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 45;

    canvas.drawArc(
      redArcRect,
      -0.5 * pi,
      1.5 * pi,
      false,
      redArcPaint,
    );

    // green arc

    // blue arc
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
