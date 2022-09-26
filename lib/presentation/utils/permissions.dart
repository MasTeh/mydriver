
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> checkSMSPermission() async {
    return await Permission.sms.isGranted;
  }

  static Future<bool> requestSMSPermission() async {
    PermissionStatus status = await Permission.sms.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}
