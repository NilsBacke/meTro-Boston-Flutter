import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/states/commute_state.dart';
import 'package:mbta_companion/src/screens/states/explore_state.dart';
import 'package:mbta_companion/src/screens/states/nearby_state.dart';
import 'package:mbta_companion/src/screens/states/saved_state.dart';

import 'screens/stateless_screens/settings_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.train),
      title: Text('Commute'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      title: Text('Saved'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      title: Text('Explore'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.near_me),
      title: Text('Nearby'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      title: Text('Settings'),
    )
  ];

  final List<Widget> _children = [
    CommuteScreen(),
    SavedScreen(),
    ExploreScreen(),
    NearbyScreen(),
    SettingsScreen()
  ];

  var _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MBTA Subway Companion'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: items,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
      ),
    );
  }
}
