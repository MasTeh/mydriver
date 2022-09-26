
import 'package:mydriver/domain/entity/person_data.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';

enum UserRegisterResultType { ok, exist, error, empty }

class UserRegisterResult {
  final UserRegisterResultType resultType;
  final int? insertId;
  final String? error;

  UserRegisterResult({required this.resultType, this.insertId, this.error});
}


class UserRegisterData {  
  final PersonData personData;
  final UserCredentials credentials;
  final String? photoUrl;

  UserRegisterData({required this.personData, required this.credentials, this.photoUrl});
}
