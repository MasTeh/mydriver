abstract class UIDialogs {
  void showToastShort(String message);
  void showToastLong(String message);
  Future<void> showAlert(dynamic context, String title, String message);
}

class DialogsProvider {
  final UIDialogs _uiDialogs;

  DialogsProvider(this._uiDialogs);

  UIDialogs build() {
    return _uiDialogs;
  }
}
