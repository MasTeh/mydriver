import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_profile.dart';

// LOCAL MEMORY REPOSITORY

abstract class UserRepositoryInterface {
  UserEntity? getUser({required int userId});
  UserProfile? getUserProfile();
  void setUserProfile(UserProfile profile);
  void clearProfile();
  void clearUsers();
}
