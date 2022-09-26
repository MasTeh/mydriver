import 'package:mydriver/domain/entity/location.dart';

abstract class MapRepositoryInterface {
  Future<String?> getAddressByPosition(LocationEntity locationEntity);
}
