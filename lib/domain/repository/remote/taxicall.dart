
import 'package:mydriver/domain/entity/taxicall.dart';

abstract class TaxiCallInterface {
  TaxiCallEntity getFromLocale();
  TaxiCallEntity getFromRemote();
  void push();
  void update();
}
