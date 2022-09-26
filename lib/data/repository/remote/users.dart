import 'package:mydriver/data/data_source/remote/user_remote.dart';
import 'package:mydriver/data/model/user_model.dart';
import 'package:mydriver/data/model/user_register_model.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';
import 'package:mydriver/domain/repository/remote/users.dart' as remote;

class UserRemoteRepository implements remote.UserRepositoryInterface {
  final UserRemoteDataSource _userDataSource;

  UserRemoteRepository(this._userDataSource);

  @override
  Future<UserEntity?> getUser({required int userId}) async {
    return _userDataSource.getUser(userId: userId);
  }

  @override
  Future<UserLoginResult> userLogin(String phone, String password) async {
    return await _userDataSource.userLogin(phone, password);
  }

  @override
  Future<UserLoginResult> userExist(UserCredentials credentials) async {
    return await _userDataSource.userExist(credentials);
  }

  @override
  Future<UserRegisterResult> registerUser(UserRegisterData data) async {
    return _userDataSource.registerUser(UserRegisterModel.fromEntity(data));
  }
}
