import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/feed_getter.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/state_chooser/paint.dart';

class FeedWidgetChooseState extends StatefulWidget {
  const FeedWidgetChooseState({Key? key}) : super(key: key);

  @override
  State<FeedWidgetChooseState> createState() => _FeedWidgetChooseStateState();
}

class _FeedWidgetChooseStateState extends State<FeedWidgetChooseState>
    with TickerProviderStateMixin {
  late AnimationController _upDownAnimationController;
  late AnimationController _blinkingAnimationController;
  late AnimationController _raiseAnimationController;
  late Animation<double> upDownAnimation;
  late Animation<double> blinkingAnimation;
  late Animation<double> raiseAnimation;

  final double verticalDimension = 50;

  final Random random = Random();

  Timer? timer;

  @override
  void initState() {
    _upDownAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    upDownAnimation = Tween<double>().animate(_upDownAnimationController)
      ..addListener(() {
        if (_upDownAnimationController.isCompleted) {
          _upDownAnimationController.repeat(reverse: true);
        }
        
        setState(() {});
      });

    _blinkingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    blinkingAnimation =
        Tween<double>(begin: 0.1, end: 1).animate(_blinkingAnimationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _blinkingAnimationController.reverse();
              timer = Timer(Duration(seconds: (random.nextInt(2) + 1)),
                  () => _blinkingAnimationController.forward());
            }
          });

    _raiseAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    raiseAnimation = Tween<double>().animate(_raiseAnimationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _upDownAnimationController.forward();
      });

    _raiseAnimationController.forward();
    _blinkingAnimationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    _upDownAnimationController.dispose();
    _blinkingAnimationController.dispose();
    _raiseAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: FeedPointPainerChooser(
            animateModificator1: _upDownAnimationController.value * 20 -
                (_raiseAnimationController.value * verticalDimension),
            animateModificator2: 1 - _blinkingAnimationController.value),
        size: FeedPointGetter.size);
  }
}
