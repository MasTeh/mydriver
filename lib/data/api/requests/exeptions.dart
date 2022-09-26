import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:mydriver/data/config.dart';

class NetworkExeption implements Exception {
  final String? url;
  final String? method;
  final String message;

  NetworkExeption(this.message, {@required this.url, @required this.method}) {
    if (ConfigProduction().logNetworkLevel) {
      Logger().e(toString());
    }
  }

  @override
  String toString() {
    return 'Network Error: ${method!.toUpperCase()} $url - $message';
  }
}
