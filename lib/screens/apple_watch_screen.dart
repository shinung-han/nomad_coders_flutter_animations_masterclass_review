import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  final random = Random();
  final double min = 0.005;
  final double max = 2.0;

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  late Animation<double> _progress = Tween(
    begin: 0.005,
    end: min + (random.nextDouble() * (max - min)),
  ).animate(_curve);

  late Animation<double> _greenProgress = Tween(
    begin: 0.005,
    end: min + (random.nextDouble() * (max - min)),
  ).animate(_curve);

  late Animation<double> _blueProgress = Tween(
    begin: 0.005,
    end: min + (random.nextDouble() * (max - min)),
  ).animate(_curve);

  void _animateValues() {
    setState(() {
      _progress = Tween(
              begin: _progress.value,
              end: min + (random.nextDouble() * (max - min)))
          .animate(_curve);
      _greenProgress = Tween(
              begin: _greenProgress.value,
              end: min + (random.nextDouble() * (max - min)))
          .animate(_curve);
      _blueProgress = Tween(
              begin: _blueProgress.value,
              end: min + (random.nextDouble() * (max - min)))
          .animate(_curve);
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apple Watch'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                progress: _progress.value,
                greenProgress: _greenProgress.value,
                blueProgress: _blueProgress.value,
              ),
              size: const Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double progress;
  final double greenProgress;
  final double blueProgress;

  AppleWatchPainter({
    required this.progress,
    required this.greenProgress,
    required this.blueProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const startingAngle = -0.5 * pi;

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

    final greenCircleRadius = (size.width / 2) * 0.65;

    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);

    // draw blue
    final blueCirclePaint = Paint()
      ..color = const Color(0xff00dff4).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45;

    final blueCircleRadius = (size.width / 2) * 0.40;

    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    // red arc
    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);

    final redArcPaint = Paint()
      ..color = const Color(0xfff2124e)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 45;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      progress * pi,
      false,
      redArcPaint,
    );

    // green arc
    final greenArcRect =
        Rect.fromCircle(center: center, radius: greenCircleRadius);

    final greenArcPaint = Paint()
      ..color = const Color(0xffa6fa01)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 45;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      greenProgress * pi,
      false,
      greenArcPaint,
    );

    // blue arc
    final blueArcRect =
        Rect.fromCircle(center: center, radius: blueCircleRadius);

    final blueArcPaint = Paint()
      ..color = const Color(0xff00dff4)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 45;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      blueProgress * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
