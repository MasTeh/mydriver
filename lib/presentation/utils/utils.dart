
import 'package:mydriver/presentation/utils/dialogs/dialogs_abstract.dart';
import 'package:mydriver/presentation/utils/dialogs/material_dialogs.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class AppUtils {
  static final dialogs = DialogsProvider(MaterialDialogs()).build();

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}