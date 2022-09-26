import 'package:google_sign_in/google_sign_in.dart';
import 'package:mydriver/presentation/pages/login/auth/signin.dart';
import 'package:mydriver/utils/utils.dart';

class GoogleAuth implements SignInStrategy {
  late int googleUserId;
  late GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['https://www.googleapis.com/auth/userinfo.profile', 'email']);
  late GoogleSignInAccount? user;
  bool _successfully = false;

  @override
  String? getToken() {
    if (user != null) {
      return user!.serverAuthCode;
    }
    return null;
  }

  @override
  String? getUserId() {
    if (user != null) {
      return user!.id;
    }
    return null;
  }

  @override
  Future<GoogleAuth> signIn() async {
    try {
      user = await _googleSignIn.signIn();

      Utils.log.wtf(user.toString());

      if (user != null) _successfully = true;
    } catch (err) {
      _successfully = false;
      Utils.log.e(err.toString());
    }
    return this;
  }

  @override
  String? getUserName() {
    if (user != null) {
      return user!.displayName;
    }
    return null;
  }

  @override
  bool isSuccessfully() {
    return _successfully;
  }

  @override
  String? getAvatarPhoto() {
    return user?.photoUrl;
  }

  @override
  String? getEmail() {
    return user?.email;
  }
}
