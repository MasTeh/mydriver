import 'package:mydriver/data/api/requests/json_response.dart';
import 'package:mydriver/data/api/requests/query.dart';
import 'package:mydriver/data/config.dart';
import 'package:mydriver/data/model/location_model.dart';
import 'package:mydriver/domain/config_interface.dart';
import 'package:mydriver/utils/utils.dart';

abstract class MapGeocodingInterface {
  Config get config;
  Future<String?> getAddressByPosition(LocationModel locationModel);
}

class GoogleGeocoding extends MapGeocodingInterface {
  final String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?";

  @override
  Config get config => ConfigProduction();

  @override
  Future<String?> getAddressByPosition(LocationModel locationModel) async {
    JSONResponse? jsonResponse = await Query(QueryType.outside, config,
            url: apiUrl +
                "latlng=" +
                locationModel.toUrlParams() +
                "&language=ru&region=RU" +
                "&key=${config.googleApiKey}")
        .pull();

    if (jsonResponse != null && jsonResponse.successfully) {
      if (jsonResponse.json!['status'] == "OK") {
        return handleLocationData(jsonResponse.json!);
      }
    }

    return null;
  }

  String handleLocationData(Map<String, dynamic> data) {
    var allitems = List<dynamic>.from(data['results']);
    String blurAddress = "";
    for (var resultItems in allitems) {
      var items = List<dynamic>.from(resultItems['address_components']);
      String locality = "";
      String adminArea2 = "";
      String adminArea3 = "";
      String street = "";
      String number = "";
      for (var element in items) {
        if (element['types'][0] == 'route') {
          street = " " + element['short_name'];
        }

        if (element['types'][0] == 'street_number') {
          number = " " + element['short_name'];
        }
      }

      if (street != "" && number != "") return street + number;

      if (street == "") {
        for (var element in items) {
          if (element['types'][0] == 'locality') {
            locality = " " + element['short_name'];
          }

          if (element['types'][0] == 'administrative_area_level_3') {
            adminArea3 = " " + element['short_name'];
          }

          if (element['types'][0] == 'administrative_area_level_2') {
            adminArea2 = " " + element['short_name'];
          }
        }

        if (locality == adminArea2) {
          locality = " Адрес неопределен";
        }

        blurAddress = adminArea2 + adminArea3 + locality;
      }
    }

    return blurAddress;
  }
}
