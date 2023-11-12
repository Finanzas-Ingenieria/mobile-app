import 'dart:ui';

import 'package:credito_inteligente/screens/history.dart';
import 'package:credito_inteligente/screens/home.dart';
import 'package:credito_inteligente/screens/profile.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../styles/styles.dart';

class MainMenu extends StatefulWidget {
  final User user;
  const MainMenu({
    super.key,
    required this.user,
  });

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late List<Widget> screens;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    screens = [
      Home(user: widget.user),
      History(user: widget.user),
      Profile(user: widget.user),
    ];
    print(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Crédito Inteligente',
      home: Scaffold(
        bottomNavigationBar: MediaQuery.of(context).size.width < 640
            ? BottomNavigationBar(
                currentIndex: selectedIndex,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.blue,
                onTap: (index) => setState(() => selectedIndex = index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Inicio',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Historial',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Perfil',
                  ),
                ],
              )
            : null,
        body: Row(children: [
          if (MediaQuery.of(context).size.width >= webScreenWidth)
            NavigationRail(
              onDestinationSelected: (index) =>
                  setState(() => selectedIndex = index),
              selectedIndex: selectedIndex,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('Historial'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Perfil'),
                ),
              ],
            ),
          Expanded(
            child: screens[selectedIndex],
          ),
        ]),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
