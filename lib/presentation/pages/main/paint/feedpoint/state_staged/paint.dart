import 'dart:ui';

import 'package:mydriver/presentation/pages/main/paint/feedpoint/feed_paint.dart';

class FeedPointStagedPainter extends FeedPointPainer {
  final double animateModificator;

  FeedPointStagedPainter(this.animateModificator);

  @override
  double get verticalDimension => animateModificator;

  @override
  Path paintInside(Offset offset) {
    return Path()
      ..addOval(Rect.fromCenter(center: offset, width: 10, height: 10));
  }

  @override
  void drawBottomPoint(Canvas canvas, Size size) {
    Paint shadowPaint = Paint()..color = const Color(0x10000000);
    shadowPaint.imageFilter =
        ImageFilter.blur(sigmaX: 4, sigmaY: 2, tileMode: TileMode.decal);

    canvas.drawOval(
        buildBottomDotOval(
            size, 60 + verticalDimension, 40 + verticalDimension),
        shadowPaint);
  }
}
