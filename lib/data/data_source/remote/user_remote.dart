import 'package:mydriver/data/api/api_service.dart';
import 'package:mydriver/data/api/requests/json_response.dart';
import 'package:mydriver/data/model/credentials_model.dart';
import 'package:mydriver/data/model/user_model.dart';
import 'package:mydriver/data/model/user_register_model.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';
import 'package:mydriver/utils/utils.dart';
import 'package:mydriver/domain/repository/remote/users.dart' as remote;

abstract class UserRemoteDataSource implements remote.UserRepositoryInterface {}

class UserApiServerSource implements UserRemoteDataSource {
  @override
  Future<UserModel?> getUser({required int userId}) async {
    UserModel? user = await ApiService.users.getById(userId);
    return user;
  }

  @override
  Future<UserRegisterResult> registerUser(UserRegisterData registerData) async {
    final UserRegisterModel registerModel =
        UserRegisterModel.fromEntity(registerData);
        
    JSONResponse? response =
        await ApiService.users.registerUser(registerModel.toApiParams());

    if (response == null) {
      Utils.log.e("RESPONSE IS NULL!");
      Utils.log.e(registerModel.toApiParams());
      return UserRegisterResult(
          resultType: UserRegisterResultType.error,
          error: "Response registerUser is null");
    }

    if (response.successfully == true) {
      if (response.json!['result'] == 'ok') {
        return UserRegisterResult(
            resultType: UserRegisterResultType.ok,
            insertId: response.json!['user_id']);
      }

      if (response.json!['result'] == 'exist') {
        return UserRegisterResult(resultType: UserRegisterResultType.exist);
      }
    } else {
      return UserRegisterResult(
          resultType: UserRegisterResultType.error,
          error: response.networkExeption!.message);
    }

    return UserRegisterResult(resultType: UserRegisterResultType.empty);
  }

  @override
  Future<UserLoginResult> userLogin(String phone, String password) async {
    JSONResponse? response = await ApiService.users.userLogin(phone, password);

    if (response?.json?['result'] == 'ok') {
      return UserLoginResult(
          accessApproved: true,
          userId: response!.json!['user_id'],
          user: UserModel.fromJSON(response.json!['user_data']));
    }

    return UserLoginResult(accessApproved: false);
  }

  @override
  Future<UserLoginResult> userExist(UserCredentials credentials) async {
    JSONResponse? response = await ApiService.users
        .checkUserExist(UserCredentialsModel.fromEntity(credentials));

    if (response?.json?['result'] == 'exist') {
      return UserLoginResult(
          accessApproved: true, userId: response!.json!['user_id']);
    } else {
      return UserLoginResult(accessApproved: false);
    }
  }
}
