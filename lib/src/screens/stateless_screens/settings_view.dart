import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/stateless_screens/about_screen.dart';
import 'package:mbta_companion/src/screens/stateless_screens/map_image_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.map),
            title: Text('See Map'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MapImageScreen()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            subtitle: Text(
              'Build info, version number, acknowledgements',
              style: TextStyle(fontSize: 14.0),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutScreen()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Manage Permissions'),
            onTap: () {
              PermissionHandler().openAppSettings();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
