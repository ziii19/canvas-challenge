import 'package:flutter/material.dart';

class CanvasChallenge extends StatefulWidget {
  const CanvasChallenge({super.key});

  @override
  State<CanvasChallenge> createState() => _CanvasChallengeState();
}

class _CanvasChallengeState extends State<CanvasChallenge> {
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
                CustomPaint(
                  painter: CurvePainter(
                      connections, containerColors, leftKeys, rightKeys),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
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
                                    width: 5,
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
                                          width: 5,
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
  final List<Color> containerColors;
  final List<GlobalKey> leftKeys;
  final List<GlobalKey> rightKeys;

  CurvePainter(
      this.connections, this.containerColors, this.leftKeys, this.rightKeys);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 4; i++) {
      if (connections[i] != null) {
        int? rightIndex = connections[i];

        final paint = Paint()
          ..color = containerColors[i]
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke;

        final p1 = _getContainerPosition(leftKeys[i]);

        final p2 = _getContainerPosition(rightKeys[rightIndex!]);

        final cp1 = Offset(size.width * 0.5 + 10, p1.dy);
        final cp2 = Offset(size.width * 0.5 - 50, p2.dy);

        final path = Path()
          ..moveTo(p1.dx, p1.dy)
          ..cubicTo(cp1.dx, p1.dy, cp2.dx, cp2.dy, p2.dx, cp2.dy);

        canvas.drawPath(path, paint);
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
    return oldDelegate.connections != connections;
  }
}
