import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = false;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              width: size.width * 0.8,
              height: size.width * 0.8,
              curve: Curves.elasticOut,
              transform: Matrix4.rotationZ(_visible ? 1 : 0),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: _visible ? Colors.amberAccent : Colors.redAccent,
                borderRadius: BorderRadius.circular(_visible ? 100 : 0),
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: _trigger,
              child: const Text('Go'),
            ),
          ],
        ),
      ),
    );
  }
}
