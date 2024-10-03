import 'dart:ui';

import 'package:canvas_test_challenge/screens/fraction/fraction_page.dart';
import 'package:flutter/material.dart';

class CanvasChallenge extends StatefulWidget {
  const CanvasChallenge({super.key});

  @override
  State<CanvasChallenge> createState() => _CanvasChallengeState();
}

class _CanvasChallengeState extends State<CanvasChallenge>
    with SingleTickerProviderStateMixin {
  List<Color> containerColors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.brown,
  ];

  List<int?> connections = [null, null, null, null];

  int? leftSelectedIndex;
  int? rightSelectedIndex;

  final List<GlobalKey> leftKeys = List.generate(4, (_) => GlobalKey());
  final List<GlobalKey> rightKeys = List.generate(4, (_) => GlobalKey());

  late AnimationController _animationController;
  int? currentAnimatingIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          leftSelectedIndex = null;
          rightSelectedIndex = null;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.purple[100],
        body: LayoutBuilder(
          builder: (context, constraints) {
            final containerSize = constraints.maxHeight / 8;

            return Stack(
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CurvePainter(
                        connections,
                        containerColors,
                        leftKeys,
                        rightKeys,
                        _animationController.value,
                        currentAnimatingIndex,
                        containerSize,
                      ),
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (connections[index] != null) {
                                    connections[index] = null;
                                    leftSelectedIndex = null;
                                  } else {
                                    leftSelectedIndex = index;
                                  }
                                });
                              },
                              child: Container(
                                key: leftKeys[index],
                                width: containerSize,
                                height: containerSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: (connections[index] != null ||
                                            leftSelectedIndex == index)
                                        ? containerColors[index]
                                        : Colors.transparent,
                                    width: 10,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  final leftIndex = connections.indexWhere(
                                      (element) => element == index);

                                  if (leftIndex != -1) {
                                    connections[leftIndex] = null;
                                  } else if (leftSelectedIndex != null) {
                                    connections[leftSelectedIndex!] = index;
                                    currentAnimatingIndex = leftSelectedIndex;

                                    _animationController.reset();
                                    _animationController.forward();
                                  }
                                });
                              },
                              child: Container(
                                key: rightKeys[index],
                                width: containerSize,
                                height: containerSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: connections.contains(index)
                                      ? Border.all(
                                          color: containerColors[
                                              connections.indexOf(index)],
                                          width: 10,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const FractionPage()),
                            (route) => false);
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.grey, size: 50),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final List<int?> connections;
  final double containerSize;
  final List<Color> containerColors;
  final List<GlobalKey> leftKeys;
  final List<GlobalKey> rightKeys;
  final double progress;
  final int? animatingIndex;

  CurvePainter(this.connections, this.containerColors, this.leftKeys,
      this.rightKeys, this.progress, this.animatingIndex, this.containerSize);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 4; i++) {
      if (connections[i] != null) {
        int? rightIndex = connections[i];

        final paint = Paint()
          ..color = containerColors[i]
          ..strokeWidth = 10
          ..style = PaintingStyle.stroke;

        final p1 = _getContainerPosition(leftKeys[i]);

        final p2 = _getContainerPosition(rightKeys[rightIndex!]);

        final cp1 = Offset(size.width * 0.5 + 10, p1.dy);
        final cp2 = Offset(size.width * 0.5 - 70, p2.dy);

        final path = Path()
          ..moveTo(p1.dx, p1.dy)
          ..cubicTo(cp1.dx + 50, p1.dy, cp2.dx, cp2.dy,
              p2.dx - containerSize + 10, p2.dy);

        if (i == animatingIndex) {
          PathMetrics pathMetrics = path.computeMetrics();
          for (PathMetric pathMetric in pathMetrics) {
            Path extractPath =
                pathMetric.extractPath(0.0, pathMetric.length * progress);
            canvas.drawPath(extractPath, paint);
          }
        } else {
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  Offset _getContainerPosition(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;

      return Offset(position.dx + size.width, position.dy + size.height / 2);
    }
    return Offset.zero;
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) {
    return oldDelegate.connections != connections ||
        oldDelegate.progress != progress ||
        oldDelegate.animatingIndex != animatingIndex;
  }
}
