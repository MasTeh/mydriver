import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';
import 'package:mydriver/domain/entity/user_profile.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';
import 'package:mydriver/domain/repository/remote/users.dart' as remote;
import 'package:mydriver/domain/repository/local/users.dart' as local;
import 'package:mydriver/domain/repository/shared/users.dart' as shared;
import 'package:mydriver/utils/utils.dart';

enum LocalSourceType { store, shared }

class UsersCase {
  final remote.UserRepositoryInterface remoteRepository;
  final local.UserRepositoryInterface localRepository;
  final shared.UserRepositoryInterface sharedRepository;

  UsersCase(
      {required this.localRepository,
      required this.remoteRepository,
      required this.sharedRepository});

  Future<UserEntity?> getUserRemote({required int userId}) async {
    return await remoteRepository.getUser(userId: userId);
  }

  Future<UserEntity?> getUserLocal(
      {required int userId,
      LocalSourceType sourceType = LocalSourceType.store}) async {
    if (sourceType == LocalSourceType.store) {
      return localRepository.getUser(userId: userId);
    }

    if (sourceType == LocalSourceType.shared) {
      return sharedRepository.getUser(userId: userId);
    }
    return null;
  }

  Future<UserLoginResult> userLogin(String phone, String password) async {
    return await remoteRepository.userLogin(phone, password);
  }

  Future<UserLoginResult> userCheckExist(UserCredentials credentials) async {
    return await remoteRepository.userExist(credentials);
  }

  Future<UserRegisterResult> registerUser(UserRegisterData userData) async {
    return await remoteRepository.registerUser(userData);
  }

  void saveProfileToShared(UserEntity userEntity) {
    sharedRepository.saveUserData(userEntity);
    localRepository.setUserProfile(UserProfile(userEntity));
  }

  Future<UserProfile?> getUserProfile() async {
    var _fromLocal = localRepository.getUserProfile();

    if (_fromLocal != null) return _fromLocal;

    var userId = sharedRepository.getUserId();

    Utils.log.wtf(userId.toString());

    if (userId != null) {
      UserEntity? _fromRemote = await remoteRepository.getUser(userId: userId);
      if (_fromRemote != null) {
        UserProfile profile = UserProfile(_fromRemote);
        localRepository.setUserProfile(profile);

        return profile;
      }
    }

    return null;
  }

  int? getUserId() {
    return sharedRepository.getUserId();
  }

  void setUserId(int userId) {
    sharedRepository.setUserId(userId);
  }

  void clearUserProfile() {
    sharedRepository.clearProfile();
    localRepository.clearProfile();
  }

  void clearLocalUsers() {
    localRepository.clearUsers();
  }

  void clearShared() {
    sharedRepository.clearAll();
  }
}
