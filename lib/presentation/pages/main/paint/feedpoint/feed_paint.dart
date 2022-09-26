import 'package:flutter/material.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/feed_getter.dart';

abstract class FeedPointPainer extends CustomPainter {
  final double radius = FeedPointGetter.size.width/2;
  final double leftDimen = 0;
  final double bottomMargin = 10;
  final Color circleColor = Colors.red.shade700;
  final Color insideCircleColor = Colors.white;
  final Color legColor = Colors.grey.shade600;
  final double verticalDimension = 0;

  Path paintInside(Offset offset);

  void drawBottomPoint(Canvas canvas, Size size);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()..color = circleColor;

    canvas.drawCircle(
        Offset(size.width / 2 + leftDimen, verticalDimension + radius),
        radius,
        paint1);

    final paint2 = Paint()..color = insideCircleColor;
    canvas.drawPath(
        paintInside(
            Offset(size.width / 2 + leftDimen, verticalDimension + radius)),
        paint2);

    Paint paint3 = Paint();
    paint3.color = legColor;
    paint3.strokeWidth = 3;
    canvas.drawLine(
        Offset(size.width / 2 + leftDimen, radius * 2 + verticalDimension),
        Offset(size.width / 2 + leftDimen,
            size.height - bottomMargin + verticalDimension),
        paint3);

    drawBottomPoint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Rect buildBottomDotOval(Size size, double width, double height) {
    return Rect.fromCenter(
        center: Offset(size.width / 2, size.height - 8),
        width: width,
        height: height);
  }
}
