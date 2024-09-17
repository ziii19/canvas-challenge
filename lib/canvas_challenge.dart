import 'package:flutter/material.dart';

class CanvasChallenge extends StatelessWidget {
  const CanvasChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: const Text("Canvas Test Challenge"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final containerSize = constraints.maxHeight / 7;
          return Stack(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Left Column (Source Boxes)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: containerSize,
                            height: containerSize,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                          onTap: () {},
                          child: Container(
                            width: containerSize,
                            height: containerSize,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
          ]);
        },
      ),
    );
  }
}
