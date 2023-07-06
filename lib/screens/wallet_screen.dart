import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WallerScreen extends StatefulWidget {
  const WallerScreen({super.key});

  @override
  State<WallerScreen> createState() => _WallerScreenState();
}

class _WallerScreenState extends State<WallerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Center(
        child: Animate(
          effects: [
            FadeEffect(
              begin: 0,
              end: 1,
              duration: 500.ms,
              curve: Curves.easeInOutCubic,
            ),
            ScaleEffect(
              begin: const Offset(1, 1),
              end: const Offset(2, 2),
              duration: 1.seconds,
              curve: Curves.bounceOut,
            ),
          ],
          child: const Text(
            'Hello!',
            style: TextStyle(fontSize: 66),
          ),
        ),
      ),
    );
  }
}
