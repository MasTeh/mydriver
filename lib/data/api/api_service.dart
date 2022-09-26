import 'package:mydriver/data/api/components/users.dart';
import 'package:mydriver/data/config.dart';

class ApiService {
  static APIComponentUsers users = APIComponentUsers(ConfigProduction());
}
