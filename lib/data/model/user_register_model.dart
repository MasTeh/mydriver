import 'package:mydriver/data/model/credentials_model.dart';
import 'package:mydriver/data/dto.dart';
import 'package:mydriver/domain/entity/person_data.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';

class UserRegisterModel extends UserRegisterData with DTO {
  UserRegisterModel(
      {required PersonData personData,
      required UserCredentialsModel credential,
      photoUrl})
      : super(
            personData: personData,
            credentials: credential,
            photoUrl: photoUrl);

  factory UserRegisterModel.fromEntity(UserRegisterData userRegisterData) {
    return UserRegisterModel(
        personData: userRegisterData.personData,
        photoUrl: userRegisterData.photoUrl,
        credential:
            UserCredentialsModel.fromEntity(userRegisterData.credentials));
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'name': personData.name,
      'fam': personData.fam,
      'otch': personData.otch,
      'phone': personData.phone,
      'email': personData.email,
      'photo': photoUrl
    };
  }

  @override
  String toString() {
    return toJSON().toString();
  }

  @override
  Map<String, String> toApiParams() {
    
    return {
      'name': personData.name,
      'fam': personData.fam,
      'otch': personData.otch,
      'phone': personData.phone,
      'email': personData.email,
      'photo': photoUrl.toString(),
      'password': credentials.passwordUserInput.toString(),
      'google_id': (credentials.googleAuthID ?? "").toString(),
      'apple_id': (credentials.appleAuthID ?? "").toString(),
    };
  }
}
