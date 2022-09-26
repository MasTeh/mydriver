import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_profile.dart';

// SHARED REPOSITORY

abstract class UserRepositoryInterface {
  UserEntity? getUser({required int userId});
  void saveUserData(UserEntity user);
  UserProfile? getUserProfile();
  int? getUserId();
  void clearProfile();
  void setUserId(int userId);
  void clearAll();
}
