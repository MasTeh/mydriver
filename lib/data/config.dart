
import 'package:mydriver/domain/config_interface.dart';

class ConfigProduction implements Config {
  @override  
  String get apiUrl => "https://api.buttonsos.ru";

  @override
  String get googleApiKey => "AIzaSyC_bvWPg_bZCQ4NHIMvAVxDEnEIWccUH5Q";

  @override
  bool get logNetworkLevel => true;

}