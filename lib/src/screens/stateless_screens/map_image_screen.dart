import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boston T Map"),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl:
              "https://freetoursbyfoot.com/wp-content/uploads/2016/01/Boston-Subway-Map-1011x1024.jpg",
        ),
      ),
    );
  }
}
