import 'package:mydriver/data/api/requests/exeptions.dart';

class JSONResponse {
  final bool successfully;
  final NetworkExeption? networkExeption;
  final int? statusCode;
  final Map<String, dynamic>? json;

  JSONResponse({this.statusCode, this.json, required this.successfully, this.networkExeption});
}
