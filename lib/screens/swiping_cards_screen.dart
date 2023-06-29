import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  late final Tween<double> _buttonScale = Tween(
    begin: 1.0,
    end: 1.1,
  );

  late final ColorTween _cancelButtonBackgroundColor = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  );

  late final ColorTween _cancelButtonIconColor = ColorTween(
    begin: Colors.red,
    end: Colors.white,
  );

  late final ColorTween _checkButtonBackgroundColor = ColorTween(
    begin: Colors.white,
    end: Colors.green,
  );

  late final ColorTween _checkButtonIconColor = ColorTween(
    begin: Colors.green,
    end: Colors.white,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  void _onHorizontalDranEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(
            (dropZone) * factor,
            curve: Curves.easeOut,
          )
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  void _onCheckPressed() {
    _position
        .animateTo(
          size.width + 100,
          curve: Curves.easeOut,
        )
        .whenComplete(_whenComplete);
  }

  void _onClosePressed() {
    _position
        .animateTo(
          (size.width + 100) * -1,
          curve: Curves.easeOut,
        )
        .whenComplete(_whenComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Swiping Cards',
        ),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation
                  .transform((_position.value + size.width / 2) / size.width) *
              pi /
              180;

          final scale = _scale.transform(_position.value.abs() / size.width);

          final buttonScale =
              _buttonScale.transform(_position.value.abs() / size.width);

          final cancelButtonBackgroundColor = _cancelButtonBackgroundColor
              .transform(_position.value.abs() / (size.width + 100));

          final cancelButtonIconColor = _cancelButtonIconColor
              .transform(_position.value.abs() / (size.width + 100));

          final checkButtonBackgroundColor = _checkButtonBackgroundColor
              .transform(_position.value.abs() / (size.width + 100));

          final checkButtonIconColor = _checkButtonIconColor
              .transform(_position.value.abs() / (size.width + 100));

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 70,
                child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: Card(
                      index: _index == 5 ? 1 : _index + 1,
                    )),
              ),
              Positioned(
                top: 70,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDranEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Card(
                        index: _index,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                child: Row(
                  children: [
                    Transform.scale(
                      scale: _position.value.isNegative ? buttonScale : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _position.value.isNegative
                              ? cancelButtonBackgroundColor
                              : Colors.white,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 0,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                        ),
                        child: IconButton(
                          onPressed: _onClosePressed,
                          icon: Icon(
                            Icons.close_rounded,
                            size: 60,
                            color: _position.value.isNegative
                                ? cancelButtonIconColor
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Transform.scale(
                      scale: !_position.value.isNegative ? buttonScale : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: !_position.value.isNegative
                              ? checkButtonBackgroundColor
                              : Colors.white,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 0,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                        ),
                        child: IconButton(
                          onPressed: _onCheckPressed,
                          icon: Icon(
                            Icons.check,
                            size: 60,
                            color: !_position.value.isNegative
                                ? checkButtonIconColor
                                : Colors.green,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.55,
        child: Image.asset(
          'assets/covers/$index.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
