import 'package:mydriver/data/model/user_model.dart';

class UserStore {
  List<UserModel> users = [];  

  UserModel? findById(int userId) {
    for (var element in users) {
      if (element.id == userId) return element;
    }
    return null;
  }

  void push(UserModel user) {
    if (findById(user.id) == null) {
      users.add(user);
    } else {
      users[users.indexOf(user)] = user;
    }
  }
}
