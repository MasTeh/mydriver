import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydriver/domain/usescases/users_case.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class MapEvent {}

class PermissionsRequest extends MapEvent {}

class AfterInit extends MapEvent {
  final GoogleMapController controller;
  AfterInit(this.controller);
}

class UserPositionRequest extends MapEvent {}

class UserPositionDefined extends MapEvent {}

class StartCreateOrder extends MapEvent {}

abstract class MapState {}

class BeforeMapReady extends MapState {}

class MapReady extends MapState {}

class PermissionsGranted extends MapState {}

class PermissionsFailed extends MapState {}

class PermissionsDisabled extends MapState {}

class OrderCreationState extends MapState {}

class MapBloc extends Bloc<MapEvent, MapState> {
  final UsersCase usersCase;
  GoogleMapController? mapController;

  MapBloc(this.usersCase) : super(BeforeMapReady()) {
    on<PermissionsRequest>((event, emit) async {
      var perm = await handlePermissions();

      if (perm.isGranted) {
        emit(PermissionsGranted());
      } else if (perm.isPermanentlyDenied) {
        emit(PermissionsDisabled());
      } else {
        emit(PermissionsFailed());
      }
    });

    on<AfterInit>((event, emit) async {
      mapController = event.controller;
      emit(MapReady());
    });

    on<UserPositionDefined>(((event, emit) {
      emit(BeforeMapReady());
    }));

    on<StartCreateOrder>((event, emit) {
      emit(OrderCreationState());
    });
  }

  Future<PermissionStatus> handlePermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return PermissionStatus.permanentlyDenied;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return PermissionStatus.denied;
      }
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return PermissionStatus.granted;
    }

    return PermissionStatus.denied;
  }
}
