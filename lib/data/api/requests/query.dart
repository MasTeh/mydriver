import 'dart:convert';

import 'package:mydriver/data/api/requests/exeptions.dart';
import 'package:mydriver/data/api/requests/json_response.dart';
import 'package:http/http.dart' as http;
import 'package:mydriver/domain/config_interface.dart';
import 'package:mydriver/utils/utils.dart';

enum QueryType { serverApi, outside }

abstract class Query {
  factory Query(QueryType queryType, Config config,
      {String? url,
      String? action,
      Map<String, String>? params,
      Map<String, String>? headers,
      String? method}) {
    switch (queryType) {
      case QueryType.serverApi:
        return ServerQuery(action ?? "", config.apiUrl, method ?? "get", params, headers);
      case QueryType.outside:
        return OutsideQuery(url ?? "", method ?? "get", params, headers);
    }
  }

  Future<JSONResponse?> pull();
}

class ServerQuery implements Query {
  final String apiUrl;
  final String action;
  final String method;
  final Map<String, String>? params;
  final Map<String, String>? headers;

  ServerQuery(this.action, this.apiUrl, this.method, this.params, this.headers);


  @override
  Future<JSONResponse?> pull() async {
    JSONResponse jsonResponse;

    if (method == "get") {
      String queryParams = "";
      if (params != null) {
        queryParams += "?";
        params!.forEach((key, value) => queryParams += '&$key=$value');
      }

      try {
        Utils.log.i(apiUrl + action + queryParams);
        var response = await http.get(Uri.parse(apiUrl + action + queryParams));
        Utils.log.wtf(response.body);
        jsonResponse = ResponseHandler(response).handle();
      } catch (err) {
        print(err.toString());
        jsonResponse = JSONResponse(
            successfully: false,
            networkExeption:
                NetworkExeption(err.toString(), url: apiUrl, method: 'get'));
      }

      return jsonResponse;
    }

    if (method == "post") {
      try {
        var response = await http.post(Uri.https(apiUrl, action),
            body: params, headers: headers);

        jsonResponse = ResponseHandler(response).handle();
      } catch (err) {
        jsonResponse = JSONResponse(
            successfully: false,
            networkExeption:
                NetworkExeption(err.toString(), url: apiUrl, method: 'post'));
      }

      return jsonResponse;
    }

    return null;
  }
}

class OutsideQuery implements Query {
  final String url;
  final String method;
  final Map<String, String>? params;
  final Map<String, String>? headers;

  OutsideQuery(this.url, this.method, this.params, this.headers);

  @override
  Future<JSONResponse?> pull() async {
    JSONResponse? jsonResponse;
    if (method == "get") {
      try {
        var response = await http.get(Uri.parse(url), headers: headers);

        jsonResponse = ResponseHandler(response).handle();
      } catch (err) {
        jsonResponse = JSONResponse(
            successfully: false,
            networkExeption:
                NetworkExeption(err.toString(), method: 'get', url: url));
      }
    }

    if (method == "post") {
      try {
        var response =
            await http.post(Uri.parse(url), headers: headers, body: params);

        jsonResponse = ResponseHandler(response).handle();
      } catch (err) {
        jsonResponse = JSONResponse(
            successfully: false,
            networkExeption:
                NetworkExeption(err.toString(), url: url, method: 'post'));
      }
    }

    return jsonResponse;
  }
}

class ResponseHandler {
  final http.Response response;
  ResponseHandler(this.response);

  JSONResponse handle() {
    String reqUrl = response.request!.url.toString();
    JSONResponse? jsonResponse;

    if (response.statusCode == 200) {
      var responseBody = Map<String, dynamic>.from(jsonDecode(response.body));
      jsonResponse =
          JSONResponse(successfully: true, statusCode: 200, json: responseBody);
    } else {
      jsonResponse = JSONResponse(
          successfully: false,
          statusCode: response.statusCode,
          networkExeption: NetworkExeption(response.body,
              method: response.request!.method.toString(), url: reqUrl));
    }

    return jsonResponse;
  }
}
