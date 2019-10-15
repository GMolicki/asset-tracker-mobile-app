import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/services/authentication.dart';
import 'package:asset_tracker_mobile/pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Asset Tracker for Jira',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromRGBO(0, 82, 204, 1.0)
      ),
      home: new RootPage(auth: new Auth())
    );
  }
}

