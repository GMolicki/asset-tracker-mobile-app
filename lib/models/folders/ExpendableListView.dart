import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';
import 'package:asset_tracker_mobile/models/folders/tree_view.dart';

class FoldersTree extends StatelessWidget {
  final Folder root;
  FoldersTree({this.root});

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (a, b) {
      },
        animationDuration: Duration(milliseconds: 250),
        children: [
          ExpansionPanel(
            isExpanded: true,
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(this.root.name),
              );
            },
            body: ExpansionTile(title: Text("expansion Title")),
          ),
          ExpansionPanel(
            isExpanded: true,
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("All"),
                );
            },
            body: Text("Body"),
            ),
        ]);
//    return new Scaffold(
//      appBar: AppBar(),
//      body: ListView(
//      children: [])
//      );
//    return Card(
//      shape: Border.all(),
//
//      child: TreeView(folder: Folder(id: 1, name: "All", subFolders: [])),
//    );
//    return new Card(
//      child: Scaffold(      resizeToAvoidBottomPadding: true,
//      backgroundColor: Color.fromRGBO(244, 245, 247, 1.0),
//      appBar: new AppBar(
//        title: new Text("Assets"),
//        backgroundColor: Color.fromRGBO(0, 82, 204, 1.0),
//      ),
////      body: new TreeView(folder: this.root, expandFlag: true, level: 0),
//    ));
  }
}

/*
ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Expansion"),
            );
          },
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Card()
          ),
      ));
 */
