import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({
    required this.index,
    super.key,
  });

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(minutes: 1),
  )..repeat(reverse: true);

  late final Animation<int> _startTimeAnimation = IntTween(
    begin: 60,
    end: 0,
  ).animate(_progressController);

  late final Animation<int> _endTimeAnimation = IntTween(
    begin: 0,
    end: 60,
  ).animate(_progressController);

  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 20,
    ),
  )..repeat(reverse: true);

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(_marqueeController);

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  void _onPlayPauseTap() {
    _playPauseController.isCompleted
        ? _playPauseController.reverse()
        : _playPauseController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  String _changeTime(int minutes, int seconds) {
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool _dragging = false;

  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  late final size = MediaQuery.of(context).size;

  final ValueNotifier<double> _volume = ValueNotifier(200);

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;

    _volume.value = _volume.value.clamp(0, size.width - 80);
  }

  void _openMenu() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interstellar'),
        actions: [
          IconButton(
            onPressed: _openMenu,
            icon: const Icon(
              Icons.menu,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: '${widget.index}',
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage('assets/covers/${widget.index}.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size.width - 80, 5),
                painter: ProgressBar(progressValue: _progressController.value),
              );
            },
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                int startMinutes = _startTimeAnimation.value ~/ 60;
                int startSeconds = _startTimeAnimation.value % 60;

                int endMinutes = _endTimeAnimation.value ~/ 60;
                int endSeconds = _endTimeAnimation.value % 60;

                return Row(
                  children: [
                    Text(
                      _changeTime(startMinutes, startSeconds),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _changeTime(endMinutes, endSeconds),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Interstellar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          SlideTransition(
            position: _marqueeTween,
            child: const Text(
              'A Film By Christopher Nolan - Original Motion Picture Soundtrack',
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _onPlayPauseTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  progress: _playPauseController,
                  size: 60,
                ),
                // LottieBuilder.asset(
                //   'assets/animations/play-lottie.json',
                //   controller: _playPauseController,
                //   onLoaded: (composition) =>
                //       _playPauseController.duration = composition.duration,
                //   width: 200,
                //   height: 200,
                // ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onHorizontalDragUpdate: _onVolumeDragUpdate,
            onHorizontalDragStart: (_) => _toggleDragging(),
            onHorizontalDragEnd: (_) => _toggleDragging(),
            child: AnimatedScale(
              scale: _dragging ? 1.1 : 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceOut,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ValueListenableBuilder(
                  valueListenable: _volume,
                  builder: (context, value, child) {
                    return CustomPaint(
                      size: Size(size.width - 80, 50),
                      painter: VolumePainter(
                        volume: value,
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    // track bar
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    // progress
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb
    canvas.drawCircle(
      Offset(progress, size.height / 2),
      10,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}

class VolumePainter extends CustomPainter {
  final double volume;

  VolumePainter({
    required this.volume,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.grey.shade300;

    final bgRect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    canvas.drawRect(bgRect, bgPaint);

    final volumePaint = Paint()..color = Colors.grey.shade500;

    final volumeRect = Rect.fromLTWH(
      0,
      0,
      volume,
      size.height,
    );

    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePainter oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
