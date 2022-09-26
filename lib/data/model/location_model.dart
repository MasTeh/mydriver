import 'package:mydriver/domain/entity/location.dart';

class LocationModel extends LocationEntity {
  LocationModel({required lat, required lng, accuracy})
      : super(lat, lng, accuracy);

  factory LocationModel.fromStringLatLng(String lat, String lng) {
    return LocationModel(
        lat: double.parse(lat.toString()), lng: double.parse(lng.toString()));
  }

  String toUrlParams() {
    return "${lat.toString()},${lng.toString()}";
  }
}
