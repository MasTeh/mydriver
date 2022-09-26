import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mydriver/presentation/pages/main/sliding_panel/initial/body.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MySlideUpPanel extends StatefulWidget {
  MySlideUpPanel({Key? key}) : super(key: key);

  @override
  State<MySlideUpPanel> createState() => _MySlideUpPanelState();
}

class _MySlideUpPanelState extends State<MySlideUpPanel> {
  final PanelController _panelController = PanelController();

  final panelOpenCloseStream = StreamController<bool>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        minHeight: 80,
        maxHeight: MediaQuery.of(context).size.height - 100,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        backdropEnabled: true,
        isDraggable: true,
        padding: const EdgeInsets.all(10),
        controller: _panelController,
        margin: const EdgeInsets.all(10),
        onPanelClosed: () {
          panelOpenCloseStream.sink.add(false);
        },
        onPanelOpened: () {
          Future.delayed(const Duration(milliseconds: 300),
              () => panelOpenCloseStream.sink.add(true));
        },
        panel: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: SlidePanelInitialState(
              panelController: _panelController,
              panelOpenCloseState: panelOpenCloseStream),
        ));
  }
}
