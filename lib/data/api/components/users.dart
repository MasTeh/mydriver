import 'package:mydriver/data/api/api_interface.dart';
import 'package:mydriver/data/api/requests/json_response.dart';
import 'package:mydriver/data/api/requests/query.dart';
import 'package:mydriver/data/model/credentials_model.dart';
import 'package:mydriver/data/model/user_model.dart';
import 'package:mydriver/domain/config_interface.dart';

class APIComponentUsers implements ApiInterface {
  final Config _config;

  APIComponentUsers(this._config);

  @override
  Config get apiConfig => _config;

  @override
  String get apiName => "users";

  @override
  int get versionCode => 10;

  Future<UserModel?> getById(int userId) async {
    var response = await Query(QueryType.serverApi, apiConfig,
            action: "/api/user/getdata",
            params: {'user_id': userId.toString(), 'user_type': 'taxiclient'})
        .pull();

    if (response != null) {
      if (response.successfully) {
        if (response.json!['result'] == 'ok') {
          return UserModel.fromJSON(response.json!['user']);
        }
      }
    }

    return null;
  }

  Future<JSONResponse?> registerUser(Map<String, String> data) async {
    var response = await Query(QueryType.serverApi, apiConfig,
            action: "/api/registerTaxiClient", params: data)
        .pull();

    return response;
  }

  Future<JSONResponse?> checkExist(int userId) async {
    return await Query(QueryType.serverApi, apiConfig,
        action: "/api/check/userexist",
        params: {'user_id': userId.toString()}).pull();
  }

  Future<void>? updateUser(UserModel user) async {
    await Query(QueryType.serverApi, apiConfig,
            action: "/api/user/update", params: user.toApiParams())
        .pull();
  }

  Future<JSONResponse?> userLogin(String phone, String password) async {
    var response = await Query(QueryType.serverApi, apiConfig,
        action: "/api/loginTaxiClient",
        params: {'phone': phone, 'password': password}).pull();

    return response;
  }

  Future<JSONResponse?> checkUserExist(UserCredentialsModel credentials) async {
    var response = await Query(QueryType.serverApi, apiConfig,
            action: "/api/login/checkExistTaxiClient",
            params: credentials.toApiParams())
        .pull();

    return response;
  }
}
