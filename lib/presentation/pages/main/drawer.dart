import 'package:flutter/material.dart';
import 'package:mydriver/domain/usescases/users_case.dart';
import 'package:mydriver/presentation/theme/fontSizes.dart';
import 'package:mydriver/presentation/widgets/avatar.dart';
import 'package:mydriver/service/module.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            UserAvatar(
                width: 50,
                userName: module<UsersCase>()
                    .localRepository
                    .getUserProfile()!
                    .userData
                    .person
                    .name,
                photoUrl: module<UsersCase>()
                    .localRepository
                    .getUserProfile()!
                    .userData
                    .photoUrl),
            Container(width: 20),
            Text(module<UsersCase>()
                .localRepository
                .getUserProfile()!
                .userData
                .person
                .name),
            Container(width: 20),
            TextButton(onPressed: () {}, child: const Text("выйти", style: TextStyle(fontSize: SpecialFontSizes.fontSmall)))
          ]),
        ),
        Divider(),
        
      ]),
    );
  }
}
