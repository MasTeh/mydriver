import 'package:flutter/material.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/feed_getter.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/state_staged/paint.dart';

class FeedWidgetStaged extends StatefulWidget {
  const FeedWidgetStaged({Key? key}) : super(key: key);

  @override
  State<FeedWidgetStaged> createState() => _FeedWidgetStagedState();
}

class _FeedWidgetStagedState extends State<FeedWidgetStaged>
    with TickerProviderStateMixin {
  late AnimationController _downAnimationController;
  late Animation<double> _downAnimation;

  @override
  void initState() {
    _downAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _downAnimation = Tween<double>().animate(_downAnimationController)
      ..addListener(() {
        setState(() {});
      });

    _downAnimationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: FeedPointStagedPainter((1 - _downAnimationController.value) *
            FeedPointGetter.currentDimension),
        size: FeedPointGetter.size);
  }
}
