import 'package:credito_inteligente/screens/history.dart';
import 'package:credito_inteligente/screens/home.dart';
import 'package:credito_inteligente/screens/profile.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../styles/styles.dart';

class MainMenu extends StatefulWidget {
  final User user;
  final int firstScreen;
  const MainMenu({
    super.key,
    this.firstScreen = 0,
    required this.user,
  });

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late List<Widget> screens;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.firstScreen;
    screens = [
      Home(user: widget.user),
      History(user: widget.user),
      Profile(user: widget.user),
    ];
    print(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: selectedIndex,
              unselectedItemColor: const Color.fromARGB(255, 188, 188, 188),
              selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
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
            backgroundColor: Colors.white,
            selectedIconTheme: const IconThemeData(color: Colors.indigo),
            unselectedIconTheme:
                const IconThemeData(color: Color.fromARGB(255, 131, 141, 206)),
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
    );
  }
}
