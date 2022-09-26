import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/feed_getter.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/feed_paint.dart';

class FeedPointPainerChooser extends FeedPointPainer {
  final double animateModificator1;
  final double animateModificator2;

  FeedPointPainerChooser(
      {required this.animateModificator1, required this.animateModificator2}) {
        FeedPointGetter.currentDimension = animateModificator1;
      }

  @override
  double get verticalDimension => animateModificator1;

  @override
  Path paintInside(Offset offset) {
    return Path()
      ..addOval(Rect.fromCenter(
          center: offset, width: 10, height: 10 * animateModificator2));
  }

  @override
  void drawBottomPoint(Canvas canvas, Size size) {
    Paint dotPaint = Paint()..color = Colors.grey.shade800;
    Paint shadowPaint = Paint()..color = const Color(0x30000000);
    shadowPaint.imageFilter = ImageFilter.blur(sigmaX: 4, sigmaY: 2, tileMode: TileMode.decal);

    canvas.drawOval(buildBottomDotOval(size, 10, 5), dotPaint);
    canvas.drawOval(
        buildBottomDotOval(
            size, 60 + animateModificator1*0.5, 40 + animateModificator1*0.5),
        shadowPaint);
  }
}
