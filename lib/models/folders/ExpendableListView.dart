import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';

class ExpandableListView extends StatefulWidget {
  final Folder folder;
  final bool isRoot;

  const ExpandableListView({Key key, this.folder, this.isRoot}) : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[buildTitleTile(), buildChildrenTiles()],
      ),
    );
  }

  ExpandableContainer buildChildrenTiles() {
    var subFolders = widget.folder.subFolders;
    return new ExpandableContainer(
        expanded: expandFlag,
        isRoot: false,
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (subFolders[index].subFolders.length > 0) {
              return ExpandableListView(folder: subFolders[index]);
            } else {
              return new Container(
                decoration: new BoxDecoration(
                    border: new Border.all(width: 1.0, color: Colors.grey),
                    color: Colors.black),
                child: new ListTile(
                  title: new Text(
                    widget.folder.subFolders[index].name,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  leading: new Icon(
                    Icons.local_pizza,
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
          itemCount: widget.folder.subFolders?.length ?? 0,
        ));
  }

  Container buildTitleTile() {
    return new Container(
      color: Colors.blue,
      padding: new EdgeInsets.symmetric(horizontal: 5.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new IconButton(
              icon: new Container(
                height: 50.0,
                width: 50.0,
                child: new Center(
                  child: new Icon(
                    expandFlag
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 30.0,
                  ),
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
    );
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
    this.childrenCount = 1,
    this.isRoot = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded && isRoot ? double.infinity : collapsedHeight,
      child: new Container(
        child: child,
        decoration: new BoxDecoration(
            border: new Border.all(width: 1.0, color: Colors.blue)),
      ),
    );
  }
}
