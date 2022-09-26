import 'package:mydriver/domain/entity/location.dart';
import 'package:mydriver/domain/repository/remote/map.dart';

class MapCase {
  final MapRepositoryInterface mapRepository;

  MapCase(this.mapRepository);

  Future<String?> getAddressByPosition(LocationEntity locationEntity) async {
    return mapRepository.getAddressByPosition(locationEntity);
  }
}
