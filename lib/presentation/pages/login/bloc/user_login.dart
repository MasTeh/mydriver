import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_credentials.dart';
import 'package:mydriver/domain/usescases/users_case.dart';

abstract class LoginEvent {}

class LoginStart extends LoginEvent {
  final String phone;
  final String password;
  LoginStart(this.phone, this.password);
}

class LoginCheckUser extends LoginEvent {
  final UserCredentials credentials;

  LoginCheckUser(this.credentials);
}

class LoginGetUser extends LoginEvent {
  final int userId;
  LoginGetUser(this.userId);
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginComplete extends LoginState {
  final UserLoginResult userLoginResult;
  LoginComplete(this.userLoginResult);
}

class LoginUserReady extends LoginState {
  final UserEntity user;
  LoginUserReady(this.user);
}

class LoginToRegister extends LoginState {}

class UserChecked extends LoginState {
  final bool userExist;
  final int? userId;

  UserChecked(this.userExist, this.userId);
}

class UserNotFound extends LoginState {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UsersCase usersCase;

  LoginBloc(this.usersCase) : super(LoginInitial()) {
    
    on<LoginStart>((event, emit) async {
      emit(LoginLoading());
      var userLoginResult =
          await usersCase.userLogin(event.phone, event.password);
      emit(LoginComplete(userLoginResult));
    });

    on<LoginCheckUser>((event, emit) async {
      emit(LoginLoading());
      var result = await usersCase.userCheckExist(event.credentials);
      if (result.accessApproved) {
        emit(LoginComplete(result));
      } else {
        emit(LoginToRegister());
      }
    });

    on<LoginGetUser>(((event, emit) async {
      emit(LoginLoading());
      var user = await usersCase.getUserRemote(userId: event.userId);
      if (user == null) {
        emit(UserNotFound());
        return;
      } else {
        usersCase.setUserId(user.id);
        emit(LoginUserReady(user));
      }
    }));
  }
}
