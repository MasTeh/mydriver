import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String? userName;
  final double width;

  const UserAvatar(
      {Key? key, this.photoUrl, required this.width, this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: width,
        child: CircleAvatar(
            child: photoUrl != null
                ? ClipOval(
                    child: Image.network(photoUrl!,
                        fit: BoxFit.cover, width: width))
                : ClipOval(
                    child: Container(
                        width: width,
                        height: width,
                        alignment: Alignment.center,
                        decoration:
                            const BoxDecoration(color: Colors.deepPurple),
                        child: userName != null
                            ? Text(userName!.substring(0, 1),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white))
                            : Container()),
                  )));
  }
}
