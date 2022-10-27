import 'package:flutter/material.dart';
import '../../screens/category_screen.dart';

class NavigationBar extends StatefulWidget {
  static int _selectedIndex = 0;

  @override
  NavigationBarState createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBar> {
  void _onItemTapped(int index) {
    setState(() {
      NavigationBar._selectedIndex = index;
      if(NavigationBar._selectedIndex == 0) {
        Navigator.of(context).pushNamed(
          CategoryScreen.routeName,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
        elevation: 0, // to get rid of the shadow
        currentIndex: NavigationBar._selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: Color(0x00ffffff), // transparent, you could use 0x44aaaaff to make it slightly less transparent with a blue hue.
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Level',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

