import 'package:get_it/get_it.dart';
import 'package:mydriver/data/data_source/local/user_local.dart';
import 'package:mydriver/data/data_source/remote/map_geocoding.dart';
import 'package:mydriver/data/data_source/remote/user_remote.dart';
import 'package:mydriver/data/data_source/shared/user_shared.dart';
import 'package:mydriver/data/repository/local/users.dart';
import 'package:mydriver/data/repository/remote/map.dart';
import 'package:mydriver/data/repository/remote/users.dart';
import 'package:mydriver/data/repository/shared/users.dart';
import 'package:mydriver/domain/repository/remote/map.dart';
import 'package:mydriver/domain/usescases/map_case.dart';

import 'package:mydriver/domain/usescases/users_case.dart';
import 'package:mydriver/presentation/pages/login/bloc/user_login.dart';
import 'package:mydriver/presentation/pages/main/bloc/feed_point.dart';
import 'package:mydriver/presentation/pages/main/bloc/map.dart';
import 'package:mydriver/presentation/pages/register/bloc/user_registration.dart';

import 'package:mydriver/domain/repository/remote/users.dart' as remote;
import 'package:mydriver/domain/repository/local/users.dart' as local;
import 'package:mydriver/domain/repository/shared/users.dart' as shared;
import 'package:shared_preferences/shared_preferences.dart';

final module = GetIt.instance;

Future<void> init() async {
  module.registerFactory(() => LoginBloc(module<UsersCase>()));
  module.registerFactory(() => RegistrationBloc(module<UsersCase>()));
  module.registerFactory(() => MapBloc(module<UsersCase>()));

  module.registerFactory(() => UsersCase(
      localRepository: module<local.UserRepositoryInterface>(),
      remoteRepository: module<remote.UserRepositoryInterface>(),
      sharedRepository: module<shared.UserRepositoryInterface>()));

  module.registerFactory(() => MapCase(module<MapRepositoryInterface>()));
  module.registerFactory<MapRepositoryInterface>(
      () => MapRepository(module<MapGeocodingInterface>()));

  module.registerLazySingleton<MapGeocodingInterface>(() => GoogleGeocoding());


  module.registerFactory<local.UserRepositoryInterface>(
      () => UserLocalRepository(module<UserLocalDataSource>()));

  module.registerLazySingleton<UserLocalDataSource>(() => UserStorage());

  module.registerFactory<remote.UserRepositoryInterface>(
      () => UserRemoteRepository(module<UserRemoteDataSource>()));

  module
      .registerLazySingleton<UserRemoteDataSource>(() => UserApiServerSource());

  module.registerFactory<shared.UserRepositoryInterface>(
      () => UserSharedRepository(module<UserSharedDataSource>()));

  module.registerLazySingleton<UserSharedDataSource>(
      () => UserSharedPreferences(sharedPreferences: module()));

  final sharedPreferences = await SharedPreferences.getInstance();

  module.registerLazySingleton(() => sharedPreferences);
}
