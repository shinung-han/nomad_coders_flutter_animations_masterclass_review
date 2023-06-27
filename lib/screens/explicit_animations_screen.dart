import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 2,
    ),
  );

  late final Animation<Decoration> _color = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amberAccent,
      borderRadius: BorderRadius.circular(0),
    ),
    end: BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(100),
    ),
  ).animate(_animationController);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_animationController);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 0.8,
  ).animate(_animationController);

  late final Animation<Offset> _offset = Tween(
    begin: Offset.zero,
    end: const Offset(0, -0.3),
  ).animate(_animationController);

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offset,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _color,
                    child: SizedBox(
                      width: size.width * 0.8,
                      height: size.width * 0.8,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Text('Play'),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: _rewind,
                  child: const Text('Rewind'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
