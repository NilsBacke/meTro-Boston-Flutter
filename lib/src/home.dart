import 'package:flutter/material.dart';
import 'package:mbta_companion/src/app.dart';
import 'package:mbta_companion/src/screens/states/commute/commute_state.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Commute'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.save),
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
    CommuteScreen(),
    CommuteScreen(),
    CommuteScreen(),
    CommuteScreen()
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
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
