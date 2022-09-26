
import 'package:mydriver/domain/entity/user.dart';

class UserCredentials {
  final String? phone;
  final String? passwordWithMD5;
  final String? passwordUserInput;
  final String? googleAuthID;
  final String? appleAuthID;

  UserCredentials(
      {this.phone,
      this.passwordWithMD5,
      this.passwordUserInput,
      this.appleAuthID,
      this.googleAuthID});
}

class UserLoginResult {
  final bool accessApproved;
  final int? userId;
  final UserEntity? user;

  UserLoginResult({required this.accessApproved, this.userId, this.user});
}