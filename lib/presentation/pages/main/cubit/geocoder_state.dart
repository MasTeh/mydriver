import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydriver/domain/entity/location.dart';
import 'package:mydriver/domain/usescases/map_case.dart';
import 'package:mydriver/service/module.dart';
import 'package:mydriver/utils/utils.dart';

class GeocoderState {
  final String? address;
  final LatLng? position;
  late bool isDefined;

  GeocoderState(this.address, this.position) {
    if (address != null && position != null) {
      isDefined = true;
    } else {
      isDefined = false;
    }
  }
}

class GeocoderCubit extends Cubit<GeocoderState> {
  final mapCase = module<MapCase>();
  GeocoderCubit() : super(GeocoderState(null, null));

  void fetch(LatLng position) async {
    String? address = await mapCase.getAddressByPosition(
        LocationEntity(position.latitude, position.longitude, null));
    Utils.log.wtf(address);
    if (address != null) {
      emit(GeocoderState(address, position));
    }
  }
}
