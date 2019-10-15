import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/services/authentication.dart';
import 'package:asset_tracker_mobile/services/asset_tracker_rest.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';
import 'package:asset_tracker_mobile/models/folders/ExpendableListView.dart';

class HomePage extends StatefulWidget {
  HomePage({this.userId, this.auth, this.onSignedOut, this.baseAuth});

  final String userId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String baseAuth;

  Folder currentFolder;
  List<Widget> foundAssets = List();
  Drawer foldersTree;
  bool isExpanded = true;

  @override
  State createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          primary: true,
          title: Text("All", style: TextStyle(color: Colors.white)),
        ),
        body: new ListView(
          children: widget.foundAssets,
        ),
        drawer: getDrawer());
  }

  Drawer getDrawer() {
    var folderName = widget.currentFolder?.name ?? "Unknown";
    return Drawer(
        child: Scaffold(
            backgroundColor: Colors.grey,
            appBar: new AppBar(
              title: new Text(folderName),
              backgroundColor: Colors.blueAccent,
            ),
            body: new Scaffold(
              body: ExpandableListView(folder: widget.currentFolder),
            )));
  }

  @override
  void initState() {
    super.initState();
    buildFoldersTree();
    searchForAssets();
  }

  void searchForAssets() async {
    final restService =
        new AssetTrackerService(authHeader: widget.auth.getAuthHeader());
    restService.searchAssets(10000, "").then((foundAssets) {
      List<Widget> assets = new List();
      for (var asset in foundAssets) {
        assets.add(Container(
            height: 50,
            alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.only(left: 1.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Color.fromRGBO(0, 82, 204, 1.0), width: 0.4)),
            child: Text("Asset ${asset.title}")));
      }
      setState(() {
        widget.foundAssets = assets;
      });
    });
  }

  void buildFoldersTree() {
    final restService =
        new AssetTrackerService(authHeader: widget.auth.getAuthHeader());
    restService.getFoldersTree().then((foldersTree) {
      setState(() {
        widget.currentFolder = foldersTree;
      });
    });
  }

  Card parseFolderToTree(Folder folder) {
    if (folder.subFolders.isEmpty || !folder.isExpanded) {
      return folderAsCard(folder);
    } else {
      Card folderCard = folderAsCard(folder);
      List<Card> subFolderCards =
          folder.subFolders.map(parseFolderToTree).toList();
      subFolderCards.insert(0, folderCard);
      return Card(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (ctx, i) {
            return parseFolderToTree(folder);
          },
        ),
      );
    }
  }

  Card folderAsCard(Folder folder) {
    return Card(
        child: GestureDetector(
            onTap: () {
              build(context);
              setState(() {
                folder.isExpanded = !folder.isExpanded;
              });
            },
            child: Card(
              child: Text(folder.name),
            )));
  }
}