import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mydriver/utils/utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidePanelInitialState extends StatefulWidget {
  const SlidePanelInitialState(
      {Key? key,
      required this.panelController,
      required this.panelOpenCloseState})
      : super(key: key);

  final PanelController panelController;
  final StreamController<bool> panelOpenCloseState;

  @override
  State<SlidePanelInitialState> createState() => _SlidePanelInitialStateState();
}

class _SlidePanelInitialStateState extends State<SlidePanelInitialState> {
  final TextEditingController _addressController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool _addressReadOny = true;

  @override
  void initState() {
    widget.panelOpenCloseState.stream.listen((panelOpened) {
      Utils.log.wtf(panelOpened);
      if (panelOpened) {
        _addressReadOny = false;
      } else {
        _addressReadOny = true;
        _focusNode.unfocus();
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(
        controller: _addressController,
        focusNode: _focusNode,
        readOnly: _addressReadOny,
        onTap: () async {
          if (widget.panelController.isPanelClosed) {
            await widget.panelController.open();            
          }          
        },
        decoration: const InputDecoration(
            hintText: "Куда едем?", prefixIcon: Icon(Icons.trip_origin)),
      )
    ]);
  }
}
