import 'package:credito_inteligente/models/user.dart';
import 'package:credito_inteligente/screens/main_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crédito Inteligente',
        home: MainMenu(
          user: User(
              id: 1,
              name: "name",
              lastname: "lastname",
              email: "email",
              password: "password"),
        ));
  }
}
