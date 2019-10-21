import 'dart:async';
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

  @override
  State createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  Folder currentFolder;
  Folder foldersTree;
  List<Widget> foundAssets = List();
  bool isExpanded = true;
  SingleArgumentCallback searchCallback;

  @override
  Widget build(BuildContext context) {
    var scaffold = new Scaffold(
      appBar: _appBar(),
      body: new ListView(children: foundAssets),
      endDrawer: _endDrawer(),
      drawer: Drawer(child: SimpleDrawerBuilder(currentFolder, foldersTree, searchCallback)),
    );
    return scaffold;
  }

  Widget _endDrawer() => Container(
      margin: EdgeInsets.only(left: 50.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
          color: Colors.blueAccent),
      alignment: AlignmentDirectional.center,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(border: InputBorder.none, fillColor: Colors.white, labelText: "Search..."),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: InputBorder.none, fillColor: Colors.white, labelText: "Page size"),
              style: TextStyle(color: Colors.white),
            ),
          ),

        ],
      ));

  AppBar _appBar() {
    return new AppBar(
      primary: true,
      title: _title(),
      actions: [_sortButton()],
    );
  }

  Text _title() => Text(currentFolder?.name ?? "Unknown", style: TextStyle(color: Colors.white));

  Widget _sortButton() => Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: GestureDetector(
        onTap: () => Scaffold.of(context).openEndDrawer(),
        child: Icon(Icons.sort),
      ));

  @override
  void initState() {
    super.initState();
    searchCallback = new SingleArgumentCallback(this.searchForAssetsInFolder);
    buildFoldersTree().then((_) => searchForAssetsInFolder(this.currentFolder ?? foldersTree));
  }

  void searchForAssetsInFolder(Folder folder) {
    setState(() {
      currentFolder = folder;
      searchForAssets(folder?.id ?? -1);
    });
  }

  void searchForAssets(int id) {
    final restService = new AssetTrackerService(widget.auth.getAuthHeader());
    restService.searchAssets(id, "").then((foundAssets) {
      List<Widget> assets = new List();
      for (var asset in foundAssets) {
        assets.add(AssetWidget(asset));
      }
      setState(() {
        this.foundAssets = assets;
      });
    });
  }

  Future<void> buildFoldersTree() {
    final restService = new AssetTrackerService(widget.auth.getAuthHeader());
    return restService.getFoldersTree().then((foldersTree) {
      setState(() {
        this.foldersTree = foldersTree;
      });
    });
  }
}
