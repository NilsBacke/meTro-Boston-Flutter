import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/states/settings_state.dart';

class SettingsScreenView extends SettingsScreenState {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.map),
            title: Text('See Map'),
          ),
          Divider(),
          SizedBox(
            height: 75.0,
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            subtitle: Text(
              'Version number, about the author, acknowledgements',
              style: TextStyle(fontSize: 14.0),
            ),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('Manage Permissions'),
            onTap: () {},
          ),
          Divider(),
        ],
      ),
    );
  }
}
