import 'package:flutter/material.dart';

import '../models/user.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Column(children: [
          Center(
            child: Text("Your Porfile"),
          )
        ]),
      ),
    );
  }
}
