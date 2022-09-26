import 'dart:convert';

import 'package:mydriver/data/model/profile_model.dart';
import 'package:mydriver/data/model/user_model.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mydriver/domain/repository/shared/users.dart' as shared;

// Источники данных связанные с ПОСТОЯННЫМ ХРАНЕНИЕМ на девайсе

abstract class UserSharedDataSource implements shared.UserRepositoryInterface {}

class UserSharedPreferences implements UserSharedDataSource {
  final SharedPreferences sharedPreferences;

  UserSharedPreferences({required this.sharedPreferences});

  @override
  void saveUserData(UserEntity userEntity) {
    UserProfileModel profileModel = UserProfileModel(userEntity);
    sharedPreferences.setString("user_profile", profileModel.toJSONString());
  }

  @override
  UserEntity? getUser({required int userId}) {
    String? userJson = sharedPreferences.getString("userId_$userId");

    if (userJson == null) return null;

    return UserModel.fromJSON(jsonDecode(userJson));
  }

  @override
  UserProfile? getUserProfile() {
    String? profileJson = sharedPreferences.getString("user_profile");

    if (profileJson != null) {
      final UserProfileModel profileModel =
          UserProfileModel.fromJSON(jsonDecode(profileJson));

      return profileModel;
    }

    return null;
  }

  @override
  void clearProfile() {
    sharedPreferences.remove("user_profile");
  }

  @override
  int? getUserId() {
    return sharedPreferences.getInt("profile_user_id");
  }

  @override
  void setUserId(int userId) {
    sharedPreferences.setInt("profile_user_id", userId);
  }

  @override
  void clearAll() {
    sharedPreferences.clear();
  }
}
