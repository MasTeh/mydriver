import 'package:mydriver/data/storage/storage.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_profile.dart';
import 'package:mydriver/domain/repository/local/users.dart' as local;

// репозиторий для данных в памяти на время работы приложения

abstract class UserLocalDataSource implements local.UserRepositoryInterface {}

class UserStorage implements UserLocalDataSource {
  @override
  UserEntity? getUser({required int userId}) {
    return Storage().userStore.findById(userId);
  }

  @override
  UserProfile? getUserProfile() {
    return Storage().userProfile;
  }

  @override
  void setUserProfile(UserProfile profile) {
    Storage().userProfile = profile;
  }

  @override
  void clearProfile() {
    Storage().userProfile = null;
  }

  @override
  void clearUsers() {
    Storage().userStore.users.clear();
  }
}
