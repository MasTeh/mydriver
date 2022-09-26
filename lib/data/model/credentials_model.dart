import 'package:mydriver/domain/entity/user_credentials.dart';

class UserCredentialsModel extends UserCredentials {
  UserCredentialsModel({phone, inputPassword, md5Password, googleId, appleId})
      : super(
            phone: phone,
            passwordUserInput: inputPassword,
            appleAuthID: appleId,
            googleAuthID: googleId,
            passwordWithMD5: md5Password);

  factory UserCredentialsModel.fromEntity(UserCredentials userCredentials) {
    return UserCredentialsModel(
        phone: userCredentials.phone,
        inputPassword: userCredentials.passwordUserInput,
        appleId: userCredentials.appleAuthID,
        googleId: userCredentials.googleAuthID,
        md5Password: userCredentials.passwordWithMD5);
  }

  factory UserCredentialsModel.forRegisterBlank(
      {required String inputPassword, String? googleId, String? appleId}) {
    return UserCredentialsModel(
        inputPassword: inputPassword, googleId: googleId, appleId: appleId);
  }

  factory UserCredentialsModel.forUser(
      {required String md5Password, String? googleId, String? appleId}) {
    return UserCredentialsModel(
        md5Password: md5Password, googleId: googleId, appleId: appleId);
  }

  Map<String, String> toApiParams() {
    Map<String, String> result = {};
    if (phone != null) result['phone'] = phone as String;
    if (passwordUserInput != null) result['password'] = passwordUserInput as String;
    if (appleAuthID != null) result['apple_id'] = appleAuthID as String;
    if (googleAuthID != null) result['google_id'] = googleAuthID as String;
    return result;
  }
}
