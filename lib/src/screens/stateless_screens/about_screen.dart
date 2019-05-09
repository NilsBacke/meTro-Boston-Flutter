import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            "Special thanks to the following libraries:\nflutter\ngoogle_maps_flutter\nlocation\nhttp\ngreat_circle_distance\nsqflite\npath\nurl_launcher\npath_provider\nrxdart\nflutter_datetime_picker\npackage_info\ncupertino_icons",
            style: Theme.of(context).textTheme.body2,
          ),
        ],
      ),
    );
  }
}
