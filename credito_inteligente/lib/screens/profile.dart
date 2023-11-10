import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
