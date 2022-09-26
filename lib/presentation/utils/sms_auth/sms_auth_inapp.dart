import 'dart:math';

import 'package:flutter_sms/flutter_sms.dart';
import 'package:mydriver/presentation/utils/sms_auth/sms_auth.dart';
import 'package:mydriver/presentation/utils/permissions.dart';

class SMSAuthInApp implements SMSAuth {
  String currentCode = "";
  final String phoneNumber;

  SMSAuthInApp(this.phoneNumber);

  @override
  String getLastCode() {
    return currentCode;
  }

  @override
  Future<void> sendSMSCode(String code) async {
    if (await PermissionHelper.checkSMSPermission() == false) {
      bool permGranted = await PermissionHelper.requestSMSPermission();
      if (!permGranted) return;
    }

    String codeStr = "";

    for (int i = 0; i <= 6; i++) {
      codeStr += Random().nextInt(9).toString();
    }

    await sendSMS(
        message: 'Код подтверждения: ' + codeStr,
        recipients: [phoneNumber],
        sendDirect: true);

    currentCode = codeStr;
  }
}
