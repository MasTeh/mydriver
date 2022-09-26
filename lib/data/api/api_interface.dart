import 'package:mydriver/data/config.dart';
import 'package:mydriver/domain/config_interface.dart';

abstract class ApiInterface {
  int get versionCode;
  String get apiName;
  Config get apiConfig;
}
