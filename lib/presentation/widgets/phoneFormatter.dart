import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

mixin PhoneFormatters {
  static MaskTextInputFormatter formatterWithoutFirstDigit = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.eager);

  static MaskTextInputFormatter formatterWithFirstDigit = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}
