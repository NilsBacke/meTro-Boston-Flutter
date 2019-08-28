import 'package:flutter/material.dart';
import 'package:mbta_companion/src/services/config.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('About'),
      ),
      body: Container(
        child: FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
              return ListView(
                children: <Widget>[
                  ListTile(
                    title: Text("App Name"),
                    subtitle: snapshot.hasData
                        ? Text(snapshot.data.appName ?? "---")
                        : Text("---"),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Build Number"),
                    subtitle: snapshot.hasData
                        ? Text(snapshot.data.buildNumber ?? "---")
                        : Text("---"),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Version Number"),
                    subtitle: snapshot.hasData
                        ? Text(snapshot.data.version ?? "---")
                        : Text("---"),
                  ),
                  Divider(),
                  acknowledgements(context),
                  Divider(),
                  ListTile(
                    title: Text("API Version"),
                    subtitle: Text(AWS_API_URL
                        .substring(AWS_API_URL.lastIndexOf("/") + 1)),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Database endpoint"),
                    subtitle: Text(FIREBASE_STAGE),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget acknowledgements(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Acknowledgements",
            style: Theme.of(context).textTheme.body1,
          ),
          Text(
            "Thank you to Caroline Thibault for all her app icon design and creative efforts. All credit for the app icon should go to her.\n\n\nSpecial thanks to the following libraries:\nflutter\ngoogle_maps_flutter\nlocation\nhttp\ngreat_circle_distance\nsqflite\npath\nurl_launcher\npath_provider\nrxdart\nflutter_datetime_picker\npackage_info\ncupertino_icons\nwebview_flutter\nconnectivity\npermission_handler\ngeolocator\neventsource\nshared_preferences\nfirebase_core\nflutter_udid\ncloud_firestore\nredux\nflutter_redux\nredux_thunk\nredux_logging\nshare\nsentry\nflutter_polyline_points\nflutter_icons",
            style: Theme.of(context).textTheme.body2,
          ),
        ],
      ),
    );
  }
}
