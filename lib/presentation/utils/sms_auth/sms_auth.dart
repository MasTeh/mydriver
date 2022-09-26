import 'package:mydriver/presentation/utils/sms_auth/sms_auth_inapp.dart';

abstract class SMSAuth {
  SMSAuth(String phoneNumber);
  Future<void> sendSMSCode(String code);
  String getLastCode();
}

enum SMSAuthMethod { local, remoteApi }

class SMSAuthFactory {
  static call(SMSAuthMethod method, String phoneNumber) {
    switch (method) {
      case SMSAuthMethod.local:
        return SMSAuthInApp(phoneNumber);
      case SMSAuthMethod.remoteApi:
        // TODO: Handle this case.
        break;
    }
  }
}
