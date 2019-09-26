import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';

class TreeView extends StatefulWidget {
  final Folder folder;
  final int level;
  bool expandFlag;

  TreeView({Key key, this.folder, this.level = 0, this.expandFlag = true});

  @override
  _TreeViewState createState() => new _TreeViewState(this.folder, this.level);
}

class _TreeViewState extends State<TreeView> {
  final Folder folder;
  final int level;

  _TreeViewState(this.folder, this.level);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new ListView(
        children: buildSubfoldersWithFolderLabel(
            widget.folder, (level == null ? 0 : level) + 1),
      ),
    );
  }

  List<Widget> buildSubfoldersWithFolderLabel(Folder passedFolder, level) {
    List<Folder> subFolders =
        passedFolder.subFolders == null ? List() : passedFolder.subFolders;

    List<Widget> views = List();
    views.add(getFolderLabel(passedFolder));
    views.addAll(subFolders.map((subfolder) {
      return new ExpandableContainer(
        items: views.length,
        expanded: false,
        child: new TreeView(folder: subfolder, level: level + 1),
      );
    }).toList());
    return views;
  }

  ExpandableContainer getFolderLabel(Folder folder) {
    return new ExpandableContainer(child:
        new Container(
      color: Color.fromRGBO(244, 245, 247, 1.0),
      padding: new EdgeInsets.symmetric(horizontal: 12.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[getFolderTitle(folder), getDropdownIcon()],
      ),
    ), expanded: true);
  }

  Text getFolderTitle(Folder folder) {
    return new Text(
      folder.name,
      style: new TextStyle(color: Colors.black),
    );
  }

  IconButton getDropdownIcon() {
    return new IconButton(
        icon: new Container(
          height: 20.0,
          width: 50.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new Icon(
              widget.expandFlag
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            widget.expandFlag = !widget.expandFlag;
          });
        });
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;
  final int items;

  ExpandableContainer(
      {@required this.child,
      this.collapsedHeight = 0.0,
      this.expandedHeight = 100,
      this.expanded = true,
      this.items = 10});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: items * 50),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: 50,
      child: new Container(
        child: child,
      ),
    );
  }
}

double min(double a, double b) {
  if(a < b) {
    return a;
  }
  return b;
}
