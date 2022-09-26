import 'package:mydriver/presentation/pages/login/auth/google_auth.dart';

abstract class SignInStrategy {
  Future<SignInStrategy> signIn();
  String? getUserId();
  String? getUserName();
  String? getAvatarPhoto();
  String? getToken();
  String? getEmail();
  bool isSuccessfully();
}

enum AuthMethods { googleSignIn, appleSignIn }

class SignInService {
  static getInstance({required AuthMethods authMethod}) {
    switch (authMethod) {
      case AuthMethods.googleSignIn:
        return GoogleAuth();
      case AuthMethods.appleSignIn:
        // apple sign in
        break;
    }
  }
}
