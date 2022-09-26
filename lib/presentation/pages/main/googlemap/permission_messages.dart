import 'package:flutter/material.dart';
import 'package:mydriver/presentation/pages/main/bloc/map.dart' as bloc;

class PermissionMessage {
  static Widget disabled(bloc.MapBloc blocProvider) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "У вас отключена геолокация, её необходимо включить для работы приложения", textAlign: TextAlign.center,),
          TextButton(
              onPressed: () => blocProvider.add(bloc.PermissionsRequest()),
              child: const Text("Обновить"))
        ],
      ),
    );
  }

  static Widget failed(bloc.MapBloc blocProvider) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              "Для работы приложения необходимо дать разрешения на геолокацию", textAlign: TextAlign.center),
          TextButton(
              onPressed: () => blocProvider.add(bloc.PermissionsRequest()),
              child: const Text("Обновить"))
        ],
      ),
    );
  }
}
