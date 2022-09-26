import 'package:mydriver/data/storage/users_store.dart';
import 'package:mydriver/domain/entity/user_profile.dart';

// storage singletone

class Storage {
  static final Storage _storage = Storage._internal();

  factory Storage() {    
    return _storage;
  }

  Storage._internal();

  UserProfile? userProfile;
  final UserStore userStore = UserStore();
}
