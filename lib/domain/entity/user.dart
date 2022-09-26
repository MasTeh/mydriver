

import 'package:mydriver/domain/entity/location.dart';
import 'package:mydriver/domain/entity/person_data.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';

class UserEntity {
  final int id;
  final PersonData person;
  final UserCredentials credentials;
  final String? photoUrl;
  final DateTime? lastActivity;
  final DateTime? created;
  final LocationEntity? location;
  final String? appVersion;

  UserEntity(
      {required this.id,
      required this.person,
      required this.credentials,
      this.photoUrl,
      this.lastActivity,
      this.created,
      this.location,
      this.appVersion});
}
