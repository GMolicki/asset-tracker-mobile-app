import 'package:asset_tracker_mobile/models/folders/drawer.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/services/authentication.dart';
import 'package:asset_tracker_mobile/services/asset_tracker_rest.dart';
import 'package:asset_tracker_mobile/services/single_argument_void_callback.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';
import 'package:asset_tracker_mobile/models/asset.dart';

class HomePage extends StatefulWidget {
  HomePage({this.userId, this.auth, this.onSignedOut, this.baseAuth});

  final String userId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String baseAuth;

  Folder currentFolder;
  Folder foldersTree;
  List<Widget> foundAssets = List();
  bool isExpanded = true;

  @override
  State createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    buildFoldersTree();
    searchForAssetsInFolder(widget.currentFolder ?? widget.foldersTree);
    var callback = new SingleArgumentCallback(this.searchForAssetsInFolder);
    return new Scaffold(
        appBar: new AppBar(
          primary: true,
          title: Text(widget.currentFolder?.name ?? "Unknown", style: TextStyle(color: Colors.white)),
        ),
        body: new ListView(children: widget.foundAssets),
        drawer: Drawer(
          child: SimpleDrawerBuilder(widget.currentFolder, widget.foldersTree, callback)),
        );
  }

  @override
  void initState() {
    super.initState();
    buildFoldersTree();
    searchForAssetsInFolder(widget.foldersTree);
  }

  void searchForAssetsInFolder(Folder folder) async {
    setState(() {
      widget.currentFolder = folder;
    });
    searchForAssets(folder.id);
  }

  void searchForAssets(int id) async {
    final restService =
        new AssetTrackerService(authHeader: widget.auth.getAuthHeader());
    restService.searchAssets(id, "").then((foundAssets) {
      List<Widget> assets = new List();
      for (var asset in foundAssets) {
        assets.add(AssetWidget(asset));
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
        widget.foldersTree = foldersTree;
      });
    });
  }
}
