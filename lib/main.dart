import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydriver/domain/usescases/users_case.dart';
import 'package:mydriver/presentation/pages/login/bloc/user_login.dart';
import 'package:mydriver/presentation/pages/main/bloc/feed_point.dart';
import 'package:mydriver/presentation/pages/main/bloc/map.dart';
import 'package:mydriver/presentation/pages/main/cubit/geocoder_state.dart';
import 'package:mydriver/presentation/pages/register/bloc/user_registration.dart';
import 'package:mydriver/presentation/pages/login/login_page.dart';
import 'package:mydriver/presentation/pages/main/main_screen.dart';
import 'package:mydriver/presentation/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mydriver/service/module.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await di.init();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  bool checkUserLogged() {
    int? userId = di.module<UsersCase>().sharedRepository.getUserId();
    if (userId != null) {      
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _userLogged = checkUserLogged();    
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => di.module<LoginBloc>()),
        BlocProvider<RegistrationBloc>(create: (context) => di.module<RegistrationBloc>()),
        BlocProvider<MapBloc>(create: (context) => di.module<MapBloc>()),
        BlocProvider<FeedPointBloc>(create: (context) => FeedPointBloc()),
        BlocProvider<GeocoderCubit>(create: (context) => GeocoderCubit())
      ],
      child: MaterialApp(
          title: "My Driver", theme: materialTheme, 
          home: _userLogged ? const MainScreen() : const LoginPage()
        ),
    );
  }
}
