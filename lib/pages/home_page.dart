import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/services/authentication.dart';
import 'package:asset_tracker_mobile/services/asset_tracker_rest.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';
import 'package:asset_tracker_mobile/models/folders/ExpendableListView.dart';
import 'package:expandable/expandable.dart';

class HomePage extends StatefulWidget {
  HomePage({this.userId, this.auth, this.onSignedOut, this.baseAuth});

  final String userId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String baseAuth;

  Folder currentFolder;
  List<Widget> foundAssets = List();
  Drawer foldersTree;
  Widget foldersDrawer;
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
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          getPanel()
        ],
      ),
    );
  }

  Widget getPanel() {
    return ExpandablePanel(
      collapsed: Text("Collapsed text", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
      expanded: getMoarPanels(),
      tapHeaderToExpand: true,
      hasIcon: true,
      );
  }
  
  Widget getMainPanel() {
    return ExpandablePanel(
      collapsed: Text("Collapsed text", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
      expanded: Text("Expanded text", softWrap: true, ),
      tapHeaderToExpand: true,
      hasIcon: true,
      );
  }
  
  
  Widget getMoarPanels() {
    return ListView(
      children: <Widget>[getMainPanel(), getMainPanel()],
    );
  }

  @override
  void initState() {
    super.initState();
    buildFoldersTree();
    searchForAssets();
  }

  void searchForAssets() async {
    print("Auth Header");
    print(widget.auth.getAuthHeader());
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
        widget.foldersDrawer = folderAsHierarchy(foldersTree);
//        widget.currentFolder = foldersTree;
      });
    });
  }

  Widget folderAsHierarchy(Folder folder) {
    return Container(child: _buildFoldersTree(folder));
  }

  List<Card> subFoldersAsList(List<Folder> subFolders) {
    List<Card> cards = new List();
    for (Folder folder in subFolders) {
      cards.add(folderAsHierarchy(folder));
    }
    return cards;
  }

  Widget _buildFoldersTree(Folder folder) {
    return parseFolderToTree(folder);
  }

  Widget buildSubfolders(Folder folder) {
    if (folder.subFolders.isNotEmpty) {
      return _buildFoldersTree(folder.subFolders.elementAt(0));
    }
    return SizedBox.shrink();
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

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}
