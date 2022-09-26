import 'package:mydriver/data/data_source/shared/user_shared.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_profile.dart';
import 'package:mydriver/domain/repository/shared/users.dart' as shared;

class UserSharedRepository extends shared.UserRepositoryInterface {
  final UserSharedDataSource dataSource;

  UserSharedRepository(this.dataSource);

  @override
  UserEntity? getUser({required int userId}) {
    return dataSource.getUser(userId: userId);
  }

  @override
  void saveUserData(UserEntity user) {
    dataSource.saveUserData(user);
  }

  @override
  UserProfile? getUserProfile() {
    return dataSource.getUserProfile();
  }

  @override
  void clearProfile() {
    dataSource.clearProfile();
  }

  @override
  int? getUserId() {
    return dataSource.getUserId();
  }

  @override
  void setUserId(int userId) {
    dataSource.setUserId(userId);
  }

  @override
  void clearAll() {
    dataSource.clearAll();
  }
}
