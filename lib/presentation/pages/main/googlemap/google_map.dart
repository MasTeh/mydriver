import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydriver/domain/entity/location.dart';
import 'package:mydriver/domain/usescases/map_case.dart';
import 'package:mydriver/presentation/pages/main/bloc/map.dart' as bloc;
import 'package:mydriver/presentation/pages/main/bloc/feed_point.dart'
    as feedBloc;
import 'package:mydriver/presentation/pages/main/cubit/geocoder_state.dart';
import 'package:mydriver/presentation/pages/main/googlemap/permission_messages.dart';
import 'package:mydriver/presentation/utils/utils.dart';
import 'package:mydriver/service/module.dart';
import 'package:mydriver/utils/utils.dart';

class AppGoogleMap extends StatefulWidget {
  const AppGoogleMap({Key? key}) : super(key: key);

  @override
  State<AppGoogleMap> createState() => _AppGoogleMapState();
}

class _AppGoogleMapState extends State<AppGoogleMap> {
  Position? _userPosition;

  bool _mapIsLoading = true;
  bool _permissionGranted = false;

  CameraPosition? cameraPosition;

  late bloc.MapBloc mapBloc;
  late feedBloc.FeedPointBloc feedPointBloc;

  GoogleMapController? _googleMapController;

  Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};

  late GeocoderCubit geocoderCubit;

  @override
  void didChangeDependencies() {
    mapBloc = context.read<bloc.MapBloc>();
    feedPointBloc = context.read<feedBloc.FeedPointBloc>();

    mapBloc.stream.listen((state) async {
      if (state is bloc.PermissionsGranted) {
        var _position = await Geolocator.getLastKnownPosition();

        _position ??= await Geolocator.getCurrentPosition();

        _userPosition = _position;
        _permissionGranted = true;
        mapBloc.add(bloc.UserPositionDefined());
      }

      if (state is bloc.MapReady) {
        mapBloc.add(bloc.StartCreateOrder());
      }
    });

    mapBloc.add(bloc.PermissionsRequest());

    geocoderCubit = context.read<GeocoderCubit>();

    super.didChangeDependencies();
  }

  void setLocationChoosePoint() async {
    if (cameraPosition == null) return;
    //if (mapBloc.state is bloc.OrderCreationState) {
    mapMarkers[const MarkerId("feed")] = Marker(
        icon: BitmapDescriptor.fromBytes(
            await AppUtils.getBytesFromAsset('assets/point.png', 50)),
        markerId: const MarkerId("feed"),
        position: LatLng(
            cameraPosition!.target.latitude, cameraPosition!.target.longitude));

    geocoderCubit.fetch(cameraPosition!.target);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<bloc.MapBloc, bloc.MapState>(builder: ((context, state) {
      if (state is bloc.PermissionsDisabled) {
        return PermissionMessage.disabled(mapBloc);
      }
      if (state is bloc.PermissionsFailed) {
        return PermissionMessage.failed(mapBloc);
      }

      return !_permissionGranted
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: size.height,
              width: size.width,
              child: Stack(
                children: <Widget>[
                  BlocBuilder<bloc.MapBloc, bloc.MapState>(
                      builder: ((context, state) {
                    return GoogleMap(
                      
                      initialCameraPosition: const CameraPosition(
                          target: LatLng(0.0, 0.0), zoom: 18),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: true,
                      onCameraIdle: () {
                        feedPointBloc.add(feedBloc.MapMoveStopped());
                        setLocationChoosePoint();
                      },
                      onCameraMoveStarted: () {
                        feedPointBloc.add(feedBloc.MapMoveStart());
                      },
                      onCameraMove: (CameraPosition position) {
                        cameraPosition = position;
                      },
                      markers: Set<Marker>.of(mapMarkers.values),
                      onMapCreated: (GoogleMapController controller) async {
                        Utils.log.wtf(_userPosition);

                        if (_userPosition != null) {
                          controller.moveCamera(CameraUpdate.newCameraPosition(
                              CameraPosition(
                                  target: LatLng(_userPosition!.latitude,
                                      _userPosition!.longitude),
                                  zoom: 18)));
                        }
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() => _mapIsLoading = false);
                        });

                        _googleMapController = controller;
                        mapBloc.add(bloc.AfterInit(controller));
                      },
                    );
                  })),
                  (_mapIsLoading)
                      ? Container(
                          height: size.height,
                          width: size.width,
                          color: Colors.grey[100],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        )
                      : Container(),
                ],
              ));
    }));
  }
}
