import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final height = size.height;
    final width = size.width;

    Paint paint = Paint();
    Path mainBackGround = Path();
    mainBackGround.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.amber.shade100;
    // canvas.drawPath(mainBackGround, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(0, height * 0.2);
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.5, height * 0.5);
    paint.color = Colors.green.shade100;
    // canvas.drawPath(ovalPath, paint);
    //////////// middle circle
    paint.color = Color.fromARGB(94, 253, 233, 197);
    canvas.drawCircle(Offset(width * 0.5, height * 0.5), 265, paint);

    paint.color = Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(Offset(width * 0.5, height * 0.5), 250, paint);

    paint.color = Color.fromARGB(94, 253, 233, 197);
    canvas.drawCircle(Offset(width * 0.5, height * 0.5), 230, paint);

    paint.color = Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(Offset(width * 0.5, height * 0.5), 200, paint);
////////////// paint right top corner
    paint.color = Colors.green.shade800;
    canvas.drawCircle(Offset(width * 1, height * 0), 150, paint);

    paint.color = Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(Offset(width * 1, height * 0), 135, paint);

    paint.color = Colors.green.shade400;
    canvas.drawCircle(Offset(width * 1, height * 0), 120, paint);

    paint.color = Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(Offset(width * 1, height * 0), 95, paint);

/////////////// paint left down corner
    paint.color = Colors.green.shade800;
    canvas.drawCircle(Offset(width * 0, height * 1), 150, paint);

    paint.color = Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(Offset(width * 0, height * 1), 135, paint);

    paint.color = Colors.green.shade400;
    canvas.drawCircle(Offset(width * 0, height * 1), 120, paint);

    paint.color = Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(Offset(width * 0, height * 1), 95, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate != this;
    // throw UnimplementedError();
  }
}
