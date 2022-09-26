import 'dart:convert';

import 'package:mydriver/data/model/user_model.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel(UserEntity userData) : super(userData);

  factory UserProfileModel.fromJSON(Map<String, dynamic> json) {
    UserModel userModel = UserModel.fromJSON(json['user_data']);
    return UserProfileModel(userModel);
  }

  Map<String, dynamic> toJSON() {
    UserModel userModel = UserModel.fromEntity(userData);

    return {'user_data': userModel.toJSON()};
  }

  String toJSONString() {
    return jsonEncode(toJSON());
  }
}
