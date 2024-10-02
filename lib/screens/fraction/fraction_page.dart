import 'dart:math';
import 'package:flutter/material.dart';
import '../canvas_challenge/canvas_challenge.dart';
import '../../custom_paint/square_paint.dart';
import '../../custom_paint/triangle_paint.dart';
import '../widgets/fraction_widget.dart';

class FractionPage extends StatefulWidget {
  const FractionPage({super.key});

  @override
  State<FractionPage> createState() => _FractionPageState();
}

class _FractionPageState extends State<FractionPage> {
  double horizontalDivider = 0.1;
  double verticalDivider = 0.1;
  double boxSize = 300.0;
  Set<int> selectedCells = {};
  final GlobalKey _gridKey = GlobalKey();
  int numerator = 0;
  int denominator = 0;

  @override
  void initState() {
    super.initState();
    generateRandomFraction();
  }

  void generateRandomFraction() {
    Random random = Random();

    while (true) {
      int num1 = random.nextInt(10) + 1;
      int num2 = random.nextInt(10) + 1;
      int product = num1 * num2;
      int num = random.nextInt(product > 40 ? 11 : 5) + (product > 40 ? 4 : 1);

      if (product > num) {
        setState(() {
          numerator = num;
          denominator = product;
        });
        break;
      }
    }
  }

  int calculateGrid(double sliderPosition) {
    if (sliderPosition <= 0.1) return 1;
    if (sliderPosition <= 0.5) return 2;
    if (sliderPosition <= 0.6) return 3;
    if (sliderPosition <= 0.65) return 4;
    if (sliderPosition <= 0.7) return 5;
    if (sliderPosition <= 0.75) return 6;
    if (sliderPosition <= 0.8) return 7;
    if (sliderPosition <= 0.85) return 8;
    if (sliderPosition <= 0.9) return 9;
    return 10;
  }

  void _handleGridTap(Offset localPosition) {
    final RenderBox renderBox =
        _gridKey.currentContext!.findRenderObject() as RenderBox;
    final localPos = renderBox.globalToLocal(localPosition);
    final int cols = calculateGrid(verticalDivider);
    final int rows = calculateGrid(horizontalDivider);
    final double cellWidth = boxSize / cols;
    final double cellHeight = boxSize / rows;

    final int i = (localPos.dx / cellWidth).floor();
    final int j = (localPos.dy / cellHeight).floor();
    final int index = j * cols + i;

    setState(() {
      if (selectedCells.contains(index)) {
        selectedCells.remove(index);
      } else {
        selectedCells.add(index);
      }
    });
  }

  void _checkAnswer() {
    if (selectedCells.length == numerator &&
        (calculateGrid(verticalDivider) * calculateGrid(horizontalDivider) ==
            denominator)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Correct!"),
        backgroundColor: Colors.green,
      ));
      selectedCells.clear();
      verticalDivider = 0.1;
      horizontalDivider = 0.1;
      generateRandomFraction();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Incorrect!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildSliders() {
    return Stack(
      children: [
        _buildVerticalSlider(verticalDivider, (dy) {
          setState(() {
            verticalDivider = (verticalDivider - dy / boxSize).clamp(0.1, 1.0);
            selectedCells.clear();
          });
        }, false, TriangleDirection.down),
        _buildVerticalSlider(verticalDivider, (dy) {
          setState(() {
            verticalDivider = (verticalDivider - dy / boxSize).clamp(0.1, 1.0);
            selectedCells.clear();
          });
        }, true, TriangleDirection.up),
        _buildHorizontalSlider(horizontalDivider, (dx) {
          setState(() {
            horizontalDivider =
                (horizontalDivider - dx / boxSize).clamp(0.1, 1.0);
            selectedCells.clear();
          });
        }, false, TriangleDirection.right),
        _buildHorizontalSlider(horizontalDivider, (dx) {
          setState(() {
            horizontalDivider =
                (horizontalDivider - dx / boxSize).clamp(0.1, 1.0);
            selectedCells.clear();
          });
        }, true, TriangleDirection.left),
      ],
    );
  }

  Widget _buildHorizontalSlider(double divider, Function(double) onPanUpdate,
      bool isRightSide, TriangleDirection direction) {
    return Positioned(
      left: isRightSide
          ? (MediaQuery.of(context).size.width + boxSize) / 2 + 10
          : (MediaQuery.of(context).size.width - boxSize) / 2 - 50,
      top: (MediaQuery.of(context).size.height - boxSize) / 2 +
          boxSize * (1 - divider) +
          5,
      child: GestureDetector(
        onPanUpdate: (details) => onPanUpdate(details.delta.dy),
        child: _buildSliderTriangle(direction, calculateGrid(divider)),
      ),
    );
  }

  Widget _buildVerticalSlider(double divider, Function(double) onPanUpdate,
      bool isBottom, TriangleDirection direction) {
    return Positioned(
      right: (MediaQuery.of(context).size.width - boxSize) / 2 +
          boxSize * divider -
          50,
      top: isBottom
          ? (MediaQuery.of(context).size.height + boxSize) / 2 + 10
          : (MediaQuery.of(context).size.height - boxSize) / 2 - 50,
      child: GestureDetector(
        onPanUpdate: (details) => onPanUpdate(details.delta.dx),
        child: _buildSliderTriangle(direction, calculateGrid(divider)),
      ),
    );
  }

  Widget _buildSliderTriangle(TriangleDirection direction, int gridCount) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: TrianglePainter(direction),
        child: Center(
          child: Text(
            gridCount.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Stack(
        children: [
          _buildFractionDisplay(),
          _buildRefreshButton(),
          _buildGrid(),
          _buildSliders(),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildFractionDisplay() {
    return Positioned(
      top: 20,
      left: MediaQuery.of(context).size.width / 2 - 50,
      right: MediaQuery.of(context).size.width / 2 - 50,
      child: SafeArea(
        child: SizedBox(
          width: 80,
          child: FractionWidget(numerator: numerator, denominator: denominator),
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: generateRandomFraction,
            icon:
                const Icon(Icons.refresh_rounded, color: Colors.grey, size: 50),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const CanvasChallenge()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.grey, size: 50),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Center(
      child: GestureDetector(
        key: _gridKey,
        onTapDown: (details) {
          setState(() {
            _handleGridTap(details.globalPosition);
          });
        },
        child: CustomPaint(
          size: Size(boxSize, boxSize),
          painter: SquarePainter(
            calculateGrid(verticalDivider),
            calculateGrid(horizontalDivider),
            selectedCells,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
            backgroundColor: const Color(0xFF222222),
          ),
          onPressed: _checkAnswer,
          child: const Icon(Icons.check, size: 35, color: Colors.green),
        ),
      ),
    );
  }
}
