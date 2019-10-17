import 'package:asset_tracker_mobile/services/single_argument_void_callback.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';
import 'package:flutter/rendering.dart';

class ExpandableListView extends StatefulWidget {
  final Folder folder;
  final bool isRoot;
  final int level;
  final SingleArgumentCallback onFolderSelected;

  const ExpandableListView(
      {Key key, this.folder, this.isRoot, this.level, this.onFolderSelected})
      : super(key: key);

  @override
  _ExpandableListViewState createState() =>
      new _ExpandableListViewState(isRoot: isRoot, level: level);
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
  final bool isRoot;
  final int level;

  _ExpandableListViewState({this.isRoot = false, this.level = 0});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[
          buildTitleTile(level),
          buildChildrenTiles(level + 1)
        ],
      ),
    );
  }

  ExpandableContainer buildChildrenTiles(int level) {
    var subFolders = widget.folder.subFolders;
    return new ExpandableContainer(
        expanded: expandFlag,
        isRoot: widget.isRoot == true,
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (subFolders[index].subFolders.length > 0) {
              return ExpandableListView(
                folder: subFolders[index],
                level: this.level + 1,
                onFolderSelected: widget.onFolderSelected,
              );
            } else {
              return GestureDetector(
                child: new Container(
                  padding: EdgeInsets.only(left: 5.0 * level),
                  decoration: new BoxDecoration(color: Colors.white),
                  child: new ListTile(
                    title: new Text(
                      widget.folder.subFolders[index].name ?? "Unknown",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black26),
                    ),
                    leading: new Icon(
                      Icons.folder,
                      color: Colors.black26,
                    ),
                  ),
                ),
                onTap: () => (widget.onFolderSelected.call(widget.folder)),
              );
            }
          },
          itemCount: widget.folder.subFolders?.length ?? 0,
        ));
  }

  Widget buildTitleTile(int level) {
    var leadingIcon;
    if (widget.isRoot == true) {
      leadingIcon = null;
    } else {
      leadingIcon = new Icon(
        expandFlag ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: Colors.white,
        size: 30.0,
      );
    }
    return new GestureDetector(
      onTap: () => (widget.onFolderSelected.call(widget.folder)),
        child: Container(
      color: Colors.blue,
      padding: new EdgeInsets.symmetric(horizontal: 2.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new IconButton(
              icon: new Container(
                padding: EdgeInsets.only(left: 7.0 * level),
                height: 50.0,
                width: 50.0,
                child: new Center(
                  child: leadingIcon,
                ),
              ),
              onPressed: () {
                setState(() => expandFlag = !expandFlag);
              }),
          new Text(
            widget.folder.name,
            style:
                new TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    ));
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final int childrenCount;
  final Widget child;
  final bool isRoot;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expanded = true,
    this.childrenCount = 2,
    this.isRoot = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 100),
      curve: Curves.linear,
      width: screenWidth,
      height: isRoot ? screenHeight : expanded ? screenHeight : collapsedHeight,
      child: new Container(child: child),
    );
  }
}
