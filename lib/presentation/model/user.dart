import 'package:mydriver/domain/entity/person_data.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';
import 'package:mydriver/presentation/model/location.dart';


class User extends UserEntity {
  User(
      {required int id,
      required PersonData person,
      required UserCredentials credentials,
      String? photoUrl,
      DateTime? lastActivity,
      DateTime? created,
      LocationModel? location,
      appVersion})
      : super(
            id: id,
            person: person,
            photoUrl: photoUrl,
            lastActivity: lastActivity,
            created: created,
            location: location,
            appVersion: appVersion,
            credentials: credentials);
}
