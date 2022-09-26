import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mydriver/data/data_source/local/user_local.dart';
import 'package:mydriver/data/data_source/remote/user_remote.dart';
import 'package:mydriver/data/data_source/shared/user_shared.dart';
import 'package:mydriver/data/model/credentials_model.dart';
import 'package:mydriver/data/model/user_model.dart';
import 'package:mydriver/data/repository/local/users.dart';

import 'package:mydriver/data/repository/remote/users.dart';
import 'package:mydriver/data/repository/shared/users.dart';
import 'package:mydriver/domain/entity/person_data.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';
import 'package:mydriver/domain/usescases/users_case.dart';
import 'package:mydriver/utils/utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

// TEST TEST TEST TEST TEST TEST TEST TEST
// USERS TEST

Future<void> main() async {
  final prefs = await SharedPreferences.getInstance();

  final UsersCase usersCase = UsersCase(
      localRepository: UserLocalRepository(UserStorage()),
      remoteRepository: UserRemoteRepository(UserApiServerSource()),
      sharedRepository: UserSharedRepository(
          UserSharedPreferences(sharedPreferences: prefs)));

  test("User profile shared", (() {
    expect(userSharedTest(usersCase, 15), equals(15));
  }));
}

int? userSharedTest(UsersCase usersCase, int testUserId) {
  usersCase.setUserId(testUserId!);
  int? userId = usersCase.getUserId();
  return userId;
}

Future<void> registerTest(UsersCase usersCase) async {
  UserRegisterResult result = await usersCase.registerUser(UserRegisterData(
      personData: PersonData(
          name: "Jedi",
          email: "89506586628@bk.ru",
          fam: "Jedi2",
          otch: "Jedi3",
          phone: "+79097001166"),
      credentials: UserCredentialsModel(inputPassword: "12345")));

  Utils.log.wtf(result.resultType);
}

Future<void> getUserTest(UsersCase usersCase) async {
  Random random = Random();

  for (int i = 0; i <= 10; i++) {
    var user = await usersCase.getUserRemote(userId: random.nextInt(40000));

    Utils.log.wtf(user.toString());
  }
}
