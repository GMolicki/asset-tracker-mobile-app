import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/models/folders/ExpendableListView.dart';
import 'package:asset_tracker_mobile/services/authentication.dart';
import 'package:asset_tracker_mobile/pages/root_page.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Folder> subs = [
      Folder(id: 4, name: "sub"),
      Folder(id: 4, name: "sub"),
      Folder(id: 4, name: "sub")
    ];
    List<Folder> folders = [
      Folder(id: 2, name:"Electronics", subFolders: subs),
      Folder(id: 3, name:"NotElectronics", subFolders: subs)
    ];

    print("folders: ${folders}");
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

