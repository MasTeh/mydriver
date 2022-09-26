import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydriver/domain/entity/person_data.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';
import 'package:mydriver/presentation/pages/login/auth/signin.dart';
import 'package:mydriver/presentation/pages/main/main_screen.dart';
import 'package:mydriver/presentation/pages/register/registration_page.dart';
import 'package:mydriver/presentation/theme/colors.dart';
import 'package:mydriver/presentation/theme/fontSizes.dart';
import 'package:mydriver/presentation/utils/utils.dart';
import 'package:mydriver/presentation/widgets/phoneFormatter.dart';
import 'package:mydriver/utils/utils.dart';

import 'package:mydriver/presentation/pages/login/bloc/user_login.dart' as bloc;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  final _validator = GlobalKey<FormState>();

  late UserRegisterData userRegisterBlank;  

  bool _isObscure = true;

  late bloc.LoginBloc blocProvider;

  void loginButton(BuildContext context) async {
    if (blocProvider.state is bloc.LoginLoading) return;
    if (!_validator.currentState!.validate()) return;

    blocProvider.add(bloc.LoginStart(
        (_loginController.text).replaceAll(" ", ""), _passwordController.text));
  }

  void registerButton(BuildContext context) {
    //
  }

  void passwordForgotButton(BuildContext context) async {
    //SMSAuth smsAuth = SMSAuthFactory.call(SMSAuthMethod.local, '+79097001166');
  }

  void googleAuthButton(BuildContext context) async {
    if (blocProvider.state is bloc.LoginLoading) return;

    SignInStrategy signIn =
        SignInService.getInstance(authMethod: AuthMethods.googleSignIn);
    await signIn.signIn();
    if (signIn.isSuccessfully()) {
      final _credentials = UserCredentials(googleAuthID: signIn.getUserId());

      userRegisterBlank = UserRegisterData(
          personData: PersonData(
              name: signIn.getUserName() ?? "",
              fam: "",
              otch: "",
              phone: (_loginController.text).replaceAll(" ", ""),
              email: signIn.getEmail() ?? ""),
          photoUrl: signIn.getAvatarPhoto(),
          credentials: _credentials);

      blocProvider.add(bloc.LoginCheckUser(_credentials));
    }
  }


  @override
  void didChangeDependencies() {
    
    blocProvider = context.read<bloc.LoginBloc>();
    blocProvider.stream.listen((state) {

      if (state is bloc.LoginComplete) {
        if (state.userLoginResult.accessApproved) {

          if (state.userLoginResult.userId != null) {
            blocProvider.add(bloc.LoginGetUser(state.userLoginResult.userId!));
          } else {
            AppUtils.dialogs
                .showAlert(context, "Неуспех", "Пользователь не найден");
          }          
        } else {
          AppUtils.dialogs
              .showAlert(context, "Неуспех", "Неправильный логин или пароль");
        }
      }
      
      if (state is bloc.LoginToRegister) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RegistrationPage(userRegisterBlank: userRegisterBlank)));
      }

      if (state is bloc.LoginUserReady) {
        Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MainScreen()));
      }

      if (state is bloc.UserNotFound) {
        AppUtils.dialogs
                .showAlert(context, "Неуспех", "Пользователь не найден в базе данных");
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    blocProvider.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Container(
                child: const Text("Авторизация"), alignment: Alignment.center)),
        body: BlocBuilder<bloc.LoginBloc, bloc.LoginState>(
          builder: ((context, state) => ListView(children: [
                Container(height: 50),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: _validator,
                      child: Column(
                        children: [
                          TextFormField(
                            scrollPadding: const EdgeInsets.only(bottom: 200),
                            autofocus: false,
                            enabled: state is bloc.LoginLoading ? false : true,
                            inputFormatters: [
                              PhoneFormatters.formatterWithoutFirstDigit
                            ],
                            controller: _loginController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.length < 12)
                                return "Неправильный номер";
                              return null;
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: "Номер телефона"),
                          ),
                          TextFormField(
                            scrollPadding: const EdgeInsets.only(bottom: 200),
                            enabled: state is bloc.LoginLoading ? false : true,
                            obscureText: _isObscure,
                            controller: _passwordController,
                            textInputAction: TextInputAction.done,
                            autofocus: false,
                            validator: (value) {
                              if (value!.isEmpty) return "Нужен пароль";
                              return null;
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                                prefixIcon: const Icon(Icons.https_outlined),
                                labelText: "Пароль"),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TextButton.icon(
                                //     onPressed: () => registerButton(context),
                                //     icon: const Icon(Icons.person),
                                //     label: const Text("Регистрация",
                                //         style: TextStyle(
                                //             fontSize: SpecialFontSizes.fontBig))),
                                ElevatedButton.icon(
                                    onPressed: () => googleAuthButton(context),
                                    icon: const Icon(Icons.g_mobiledata),
                                    label: const Text("Войти через Google",
                                        style: TextStyle(
                                            fontSize:
                                                SpecialFontSizes.fontLarge))),
                                TextButton.icon(
                                    onPressed: () => loginButton(context),
                                    icon: const Icon(Icons.login),
                                    label: const Text("Войти",
                                        style: TextStyle(
                                            fontSize:
                                                SpecialFontSizes.fontBig))),
                              ]),

                          Container(height: 50),

                          state is bloc.LoginLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Container()

                          // TextButton.icon(
                          //     onPressed: () => passwordForgotButton(context),
                          //     icon: const Icon(Icons.password,
                          //         color: SpecialColors.greyLight),
                          //     label: const Text("Забыли пароль?",
                          //         style: TextStyle(
                          //             fontSize: SpecialFontSizes.fontBig,
                          //             color: SpecialColors.greyLight))),
                        ],
                      )),
                )
              ])),
        ));
  }
}
