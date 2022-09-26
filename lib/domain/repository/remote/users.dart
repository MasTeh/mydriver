
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';

abstract class UserRepositoryInterface {
  Future<UserEntity?> getUser({required int userId});  
  Future<UserLoginResult> userLogin(String phone, String password);
  Future<UserLoginResult> userExist(UserCredentials credentials);
  Future<UserRegisterResult> registerUser(UserRegisterData user);
}
