import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/states/commute_state.dart';
import 'package:mbta_companion/src/screens/states/explore_state.dart';
import 'package:mbta_companion/src/screens/states/nearby_state.dart';
import 'package:mbta_companion/src/screens/states/saved_state.dart';
import 'package:connectivity/connectivity.dart';
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

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectionSubscription;
  ConnectivityResult _connectionState = ConnectivityResult.mobile;

  @override
  void initState() {
    super.initState();
    _connectionSubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionState = result;
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _connectionSubscription.cancel();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String titleForScreen(int index) {
    switch (index) {
      case 0:
        return 'Commute';
      case 1:
        return 'Saved';
      case 2:
        return 'Explore';
      case 3:
        return 'Nearby';
      case 4:
        return 'Settings';
      default:
        return 'Boston Subway Companion';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleForScreen(_currentIndex)),
      ),
      body: _connectionState == ConnectivityResult.none
          ? noInternetWidget
          : _children[_currentIndex],
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

  Widget noInternetWidget() {
    return Container(
      child: Center(
        child: Text("No Internet Connection"),
      ),
    );
  }
}
