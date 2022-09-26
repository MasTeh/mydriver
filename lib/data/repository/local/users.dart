import 'package:mydriver/data/data_source/local/user_local.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_profile.dart';
import 'package:mydriver/domain/repository/local/users.dart' as local;

class UserLocalRepository extends local.UserRepositoryInterface {
  final UserLocalDataSource dataSource;

  UserLocalRepository(this.dataSource);

  @override
  UserEntity? getUser({required int userId}) {
    return dataSource.getUser(userId: userId);
  }

  @override
  UserProfile? getUserProfile() {
    return dataSource.getUserProfile();
  }

  @override
  void setUserProfile(UserProfile profile) {
    dataSource.setUserProfile(profile);
  }

  @override
  void clearProfile() {
    dataSource.clearProfile();
  }

  @override
  void clearUsers() {
    dataSource.clearUsers();
  }
}
