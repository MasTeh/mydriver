import 'package:mydriver/data/data_source/remote/map_geocoding.dart';
import 'package:mydriver/data/model/location_model.dart';
import 'package:mydriver/domain/entity/location.dart';
import 'package:mydriver/domain/repository/remote/map.dart';

class MapRepository implements MapRepositoryInterface {
  final MapGeocodingInterface geocodingInterface;

  MapRepository(this.geocodingInterface);

  @override
  Future<String?> getAddressByPosition(LocationEntity locationEntity) async {
    return geocodingInterface.getAddressByPosition(
        LocationModel(lat: locationEntity.lat, lng: locationEntity.lng));
  }
}
