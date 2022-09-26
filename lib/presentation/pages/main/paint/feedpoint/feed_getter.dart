import 'package:flutter/animation.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/state_chooser/widget.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/state_staged/widget.dart';

class FeedPointGetter {
  static double currentDimension = 0;
  static Size size = const Size(35, 70);
  static const stateChoosing = FeedWidgetChooseState();
  static const stateStaged = FeedWidgetStaged();
}
