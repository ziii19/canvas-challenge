import 'package:flutter/material.dart';

class SquarePainter extends CustomPainter {
  final int verticalGrid;
  final int horizontalGrid;
  final Set<int> selectedCells;

  SquarePainter(this.verticalGrid, this.horizontalGrid, this.selectedCells);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..color = const Color.fromARGB(255, 88, 194, 252)
      ..style = PaintingStyle.fill;

    // Hitung ukuran setiap kotak berdasarkan jumlah grid
    double cellWidth = size.width / verticalGrid;
    double cellHeight = size.height / horizontalGrid;

    // Gambar grid kotak
    for (int i = 0; i < verticalGrid; i++) {
      for (int j = 0; j < horizontalGrid; j++) {
        final int index = j * verticalGrid + i;

        print(selectedCells);

        // Ubah warna jika kotak dipilih
        final paintToUse =
            selectedCells.contains(index) ? selectedPaint : paint;

        canvas.drawRect(
          Rect.fromLTWH(i * cellWidth, j * cellHeight, cellWidth, cellHeight),
          paintToUse,
        );
      }
    }

    // Divider paint (garis pemisah)
    final dividerPaint = Paint()
      ..color = const Color(0xFF333333)
      ..strokeWidth = 2;

    // Gambar garis pemisah vertikal dan horizontal
    for (int i = 1; i < verticalGrid; i++) {
      final x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), dividerPaint);
    }

    for (int j = 1; j < horizontalGrid; j++) {
      final y = j * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), dividerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint on position change
  }
}


///////////////////////////////////////
// class SquarePainter extends CustomPainter {
//   final int verticalGrid;
//   final int horizontalGrid;

//   SquarePainter(this.verticalGrid, this.horizontalGrid);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blueGrey
//       ..style = PaintingStyle.fill;

//     // Hitung ukuran setiap kotak berdasarkan jumlah grid
//     double cellWidth = size.width / verticalGrid;
//     double cellHeight = size.height / horizontalGrid;

//     // Gambar grid kotak
//     for (int i = 0; i < verticalGrid; i++) {
//       for (int j = 0; j < horizontalGrid; j++) {
//         canvas.drawRect(
//           Rect.fromLTWH(i * cellWidth, j * cellHeight, cellWidth, cellHeight),
//           paint,
//         );
//       }
//     }

//     // Divider paint (garis pemisah)
//     final dividerPaint = Paint()
//       ..color = Color(0xFF333333)
//       ..strokeWidth = 2;

//     // Gambar garis pemisah vertikal dan horizontal
//     for (int i = 1; i < verticalGrid; i++) {
//       final x = i * cellWidth;
//       canvas.drawLine(Offset(x, 0), Offset(x, size.height), dividerPaint);
//     }

//     for (int j = 1; j < horizontalGrid; j++) {
//       final y = j * cellHeight;
//       canvas.drawLine(Offset(0, y), Offset(size.width, y), dividerPaint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true; // Always repaint on position change
//   }
// }
