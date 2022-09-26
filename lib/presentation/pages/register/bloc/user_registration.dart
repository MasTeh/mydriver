import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydriver/domain/entity/user_profile.dart';
import 'package:mydriver/domain/entity/user_register_data.dart';
import 'package:mydriver/domain/usescases/users_case.dart';

// EVENT
abstract class RegistrationEvent {}

class EventPush extends RegistrationEvent {
  final UserRegisterData userRegisterBlank;
  EventPush({required this.userRegisterBlank});
}

// STATE
abstract class RegistrationState {}

class StateEmpty extends RegistrationState {}

class StateLoading extends RegistrationState {}

class StateComplete extends RegistrationState {
  final UserRegisterResult userRegisterResult;
  StateComplete(this.userRegisterResult);
}

class StateError extends RegistrationState {
  final String message;
  StateError(this.message);
}

// BLOC

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final UsersCase usersCase;

  RegistrationBloc(this.usersCase) : super(StateEmpty()) {
    on<EventPush>((event, emit) async {
      emit(StateLoading());

      var result = await usersCase.registerUser(event.userRegisterBlank);

      if (result.insertId == null) {
        emit(StateError("Внутренняя ошибка сервера, код 501"));
      }

      var user = await usersCase.getUserRemote(userId: result.insertId!);
      if (user == null) {
        emit(StateError("Внутренняя ошибка сервера, код 502"));
      }

      usersCase.setUserId(result.insertId!);
      usersCase.localRepository.setUserProfile(UserProfile(user!));
      emit(StateComplete(result));
    });
  }
}
