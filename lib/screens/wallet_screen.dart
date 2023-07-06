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
        child: const Text(
          'Hello!',
          style: TextStyle(fontSize: 66),
        )
            .animate()
            .fadeIn(
              begin: 0,
              duration: 1.seconds,
            )
            .scale(
              alignment: Alignment.center,
              begin: Offset.zero,
              end: const Offset(2, 2),
              curve: Curves.easeInOutCubic,
            ),
      ),
    );
  }
}
