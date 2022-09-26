import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydriver/domain/entity/user.dart';
import 'package:mydriver/domain/entity/user_profile.dart';
import 'package:mydriver/domain/usescases/users_case.dart';
import 'package:mydriver/presentation/pages/login/login_page.dart';
import 'package:mydriver/presentation/pages/main/cubit/geocoder_state.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/feed_getter.dart';
import 'package:mydriver/presentation/pages/main/drawer.dart';
import 'package:mydriver/presentation/pages/main/googlemap/google_map.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/state_chooser/widget.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/state_staged/widget.dart';
import 'package:mydriver/presentation/pages/main/sliding_panel/sliding_panel.dart';
import 'package:mydriver/presentation/theme/fontSizes.dart';
import 'package:mydriver/service/module.dart';

import 'package:mydriver/presentation/pages/main/bloc/feed_point.dart' as feed;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  void logout() {
    module<UsersCase>().clearShared();
    module<UsersCase>().clearUserProfile();
    module<UsersCase>().clearLocalUsers();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => LoginPage())));
  }

  void checkUser() async {
    int? userId = module<UsersCase>().getUserId();

    if (userId == null) logout();

    UserEntity? user = await module<UsersCase>().getUserRemote(userId: userId!);
    if (user == null) logout();

    module<UsersCase>().localRepository.setUserProfile(UserProfile(user!));
  }

  final _scaffoldState = GlobalKey<ScaffoldState>();
  Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      key: _scaffoldState,
      drawer: const AppDrawer(),
      body: Stack(children: [
        const AppGoogleMap(),
        Positioned(
            top: 45,
            width: MediaQuery.of(context).size.width,
            left: 0,
            child: BlocBuilder<GeocoderCubit, GeocoderState>(
              builder: (context, state) {
                if (state.isDefined) {
                  return Text("Ваш адрес:\n" + state.address!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: SpecialFontSizes.fontBig,
                          fontWeight: FontWeight.bold,
                          color: Colors.black));
                } else {
                  return Container();
                }
              },
            )),
        Positioned(
            top: 30,
            left: 20,
            child: IconButton(
                onPressed: () {
                  _scaffoldState.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu_sharp, size: 30))),
        Positioned(
            top: MediaQuery.of(context).size.height / 2 -
                FeedPointGetter.size.height,
            left: MediaQuery.of(context).size.width / 2 -
                FeedPointGetter.size.width / 2 -
                1,
            child: BlocBuilder<feed.FeedPointBloc, feed.FeedPointState>(
                builder: (context, state) {
              if (state is feed.FeedPointMapMoving) {
                return const FeedWidgetChooseState();
              }

              return const FeedWidgetStaged();
            })),
        MySlideUpPanel()
      ]),
    );
  }
}
