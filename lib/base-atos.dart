import 'package:flutter/material.dart';
class AbacusBead extends StatefulWidget {
   double width;
   double height;
   Color color;
   Color borderColor;

    AbacusBead(
       {Key? key,required this.width,required this.height,required this.color,required this.borderColor, }) : super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AbacusBead();
  }
}
class _AbacusBead extends State<AbacusBead> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: _AbacusBeadPainter(),
    );
  }
}

// // 上半梯形颜色
// final upperColor = Color.fromRGBO(180, 200, 220,1)!;
// // 下半梯形颜色
// final lowerColor = Color.fromRGBO(160, 190, 210,1)!;




// class AbacusBead extends StatelessWidget {
//   final double width;
//   final double height;
//
//   const AbacusBead({Key? key, required this.width, required this.height})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(width, height),
//       painter: _AbacusBeadPainter(),
//     );
//   }
// }

class _AbacusBeadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 上半梯形颜色
    final upperColor = Color.fromRGBO(200, 180, 160,1)!;
// 下半梯形颜色
    final lowerColor = Color.fromRGBO(180, 160, 140,1)!;

    // 绘制上半梯形（位置调整）
    final upperPath = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(0, size.height * 0.5)
      ..close();
    final upperPaint = Paint()..color = upperColor;
    canvas.drawPath(upperPath, upperPaint);

    // 绘制下半梯形（位置调整）
    final lowerPath = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..close();
    final lowerPaint = Paint()..color = lowerColor;
    canvas.drawPath(lowerPath, lowerPaint);

    // // 绘制中间分隔线
    // final linePaint = Paint()
    //   ..color = Color.fromRGBO(255, 255, 255, 1)
    //   ..strokeWidth = 1.5;
    // canvas.drawLine(
    //   Offset(0, size.height * 0.5),
    //   Offset(size.width, size.height * 0.5),
    //   linePaint,
    // );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}