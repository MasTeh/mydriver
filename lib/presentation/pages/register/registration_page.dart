import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:logger/logger.dart';
import 'package:mydriver/domain/entity/person_data.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';
import 'package:mydriver/presentation/pages/main/main_screen.dart';
import 'package:mydriver/presentation/utils/utils.dart';
import 'package:mydriver/presentation/widgets/phoneFormatter.dart';

import 'package:mydriver/presentation/pages/register/bloc/user_registration.dart'
    as bloc;
import 'package:mydriver/utils/utils.dart';

class RegistrationPage extends StatefulWidget {
  final UserRegisterData userRegisterBlank;
  const RegistrationPage({Key? key, required this.userRegisterBlank})
      : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final log = Logger();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final patronymicNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  final _validator = GlobalKey<FormState>();

  late UserRegisterData userRegisterBlank;
  late bloc.RegistrationBloc blocProvider;

  String finishMessage = "";

  void registerButton() {
    if (!_validator.currentState!.validate()) return;

    userRegisterBlank = UserRegisterData(
      credentials: UserCredentials(
          passwordUserInput: password1Controller.text,
          googleAuthID: widget.userRegisterBlank.credentials.googleAuthID,
          appleAuthID: widget.userRegisterBlank.credentials.appleAuthID),
      personData: PersonData(
          name: firstNameController.text,
          fam: lastNameController.text,
          otch: patronymicNameController.text,
          phone: (phoneController.text).replaceAll(' ', ''),
          email: emailController.text),
    );

    blocProvider.add(bloc.EventPush(userRegisterBlank: userRegisterBlank));
  }

  @override
  void initState() {
    userRegisterBlank = widget.userRegisterBlank;
    firstNameController.text = widget.userRegisterBlank.personData.name;
    emailController.text = widget.userRegisterBlank.personData.email;
    phoneController.text = widget.userRegisterBlank.personData.phone;

    super.initState();
  }

  void afterRegistration() async {
    await AppUtils.dialogs
        .showAlert(context, "Успех", "Регистрация пройдена успешно.");

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()));
  }

  @override
  void didChangeDependencies() {
    blocProvider = BlocProvider.of<bloc.RegistrationBloc>(context);
    blocProvider.stream.listen((state) {
      
      if (state is bloc.StateComplete) {
        var registerResult = state.userRegisterResult;

        if (registerResult.resultType == UserRegisterResultType.exist) {
          AppUtils.dialogs.showAlert(context, "Проблемка",
              "С данным номером телефона уже есть учётная запись. Попробуйте авторизацию через Google.");
        }
        if (registerResult.resultType == UserRegisterResultType.error) {
          AppUtils.dialogs.showAlert(
              context, "Что-то пошло не так", registerResult.error.toString());
        }
        if (registerResult.resultType == UserRegisterResultType.ok) {
          // register complete

          afterRegistration();
        }
      }

      if (state is bloc.StateError) {
        AppUtils.dialogs.showAlert(context, "Что-то не так", state.message);
      }

    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (blocProvider.state is bloc.StateLoading) {
      Loader.show(context);
    } else {
      Loader.hide();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Регистрация")),
      body: BlocBuilder<bloc.RegistrationBloc, bloc.RegistrationState>(
        builder: ((context, state) {
          if (state is bloc.StateLoading) {
            Loader.show(context);
          } else {
            Loader.hide();
          }

          return ListView(padding: const EdgeInsets.all(20), children: [
            Container(
                width: 120,
                height: 120,
                child: CircleAvatar(
                    child: widget.userRegisterBlank.photoUrl != null
                        ? ClipOval(
                            child: Image.network(
                                widget.userRegisterBlank.photoUrl!,
                                fit: BoxFit.cover,
                                width: 120))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo_camera, size: 40),
                              Text("Аватар",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white))
                            ],
                          ))),
            Form(
                key: _validator,
                child: Column(children: [
                  TextFormField(
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Имя"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Требуется заполнить";
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: lastNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Фамилия"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Требуется заполнить";
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: patronymicNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Отчество"),
                      validator: (value) {
                        return null;
                      }),
                  TextFormField(
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        PhoneFormatters.formatterWithoutFirstDigit
                      ],
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(labelText: "Номер телефона"),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 12) {
                          return "Некорректный номер телефона";
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: "E-Mail"),
                      validator: (value) {
                        return null;
                      }),
                  TextFormField(
                      controller: password1Controller,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: "Придумайте пароль"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Требуется заполнить";
                        }

                        if (value.length < 5) {
                          return "Длинна не менее 4 символов";
                        }

                        if (value != password2Controller.text) {
                          return "Пароли не совпадают";
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: password2Controller,
                      textInputAction: TextInputAction.done,
                      autofocus: false,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: "Повторите пароль"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Требуется заполнить";
                        }

                        if (value.length < 5) {
                          return "Длинна не менее 4 символов";
                        }

                        if (value != password2Controller.text) {
                          return "Пароли не совпадают";
                        }
                        return null;
                      }),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: const Text("Зарегистрироваться"),
                      onPressed: () => registerButton(),
                    ),
                  )
                ]))
          ]);
        }),
      ),
    );
  }
}
