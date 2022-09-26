import 'package:mydriver/data/model/credentials_model.dart';
import 'package:mydriver/data/model/location_model.dart';
import 'package:mydriver/domain/entity/person_data.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';

class UserModel extends UserEntity {
  UserModel(
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

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
        id: entity.id, person: entity.person, credentials: entity.credentials);
  }

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    String? _googleId = json['google_id'] != null ? json['google_id'] as String : null;
    String? _appleId = json['apple_id'] != null ? json['apple_id'] as String : null;
    
    return UserModel(
        id: json['id'] as int,
        person: PersonData(
            name: json['name'] as String,
            fam: json['fam'] as String,
            otch: json['otch'] as String,
            phone: json['phone'] as String,
            email: (json['email'] ?? "") as String),
        credentials: UserCredentialsModel.forUser(
            md5Password: json['hash'] as String,
            googleId: _googleId,
            appleId: _appleId),
        lastActivity: json['last_activity'] != null
            ? DateTime.parse(json['last_activity'])
            : null,
        location: (json['lat'] != null && json['lng'] != null)
            ? LocationModel.fromStringLatLng(
                json['lat'].toString(), json['lng'].toString())
            : null,
        appVersion: json['version']);
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> _result = {
      'id': id,
      'name': person.name,
      'fam': person.fam,
      'otch': person.otch,
      'phone': person.phone,      
    };
    if (location != null) {
      _result['lat'] = location!.lat;
      _result['lng'] = location!.lng;
    }
    return _result;
  }

  @override
  String toString() {
    return toJSON().toString();
  }

  Map<String, String> toApiParams() {
    Map<String, String> _result = {
      'user_id': id.toString(),
      'name': person.name,
      'fam': person.fam,
      'otch': person.otch,
      'phone': person.phone,
    };
    if (location != null) {
      _result['lat'] = location!.lat.toString();
      _result['lng'] = location!.lng.toString();
    }
    return _result;
  }
}
