import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';
import 'package:asset_tracker_mobile/services/single_argument_void_callback.dart';
import 'package:asset_tracker_mobile/models/folders/ExpendableListView.dart';

class DrawerBuilder {
  static Drawer fromFolderRoot(
      Folder folder, Folder tree, SingleArgumentCallback onFolderTapCallback) {
    var folderName = folder?.name ?? "Unknown";
    return Drawer(
        child: Scaffold(
            backgroundColor: Colors.grey,
            appBar: new AppBar(
              title: new Text(folderName),
              backgroundColor: Colors.blueAccent,
            ),
            body: new Scaffold(
              body: ExpandableListView(
                folder: tree,
                isRoot: true,
                level: 0,
                onFolderSelected: onFolderTapCallback,
              ),
            )));
  }
}

class SimpleDrawerBuilder extends StatefulWidget {
  final Folder root;
  SingleArgumentCallback onFolderTapCallback;
  List<Folder> foldersList;
  Folder currentFolder;

  SimpleDrawerBuilder(this.currentFolder, this.root, this.onFolderTapCallback)
      : super();

  @override
  _SimpleDrawerBuilderState createState() => new _SimpleDrawerBuilderState(
      this.root, onFolderTapCallback, this.currentFolder);
}

class _SimpleDrawerBuilderState extends State<SimpleDrawerBuilder> {
  final Folder root;
  SingleArgumentCallback onFolderTapCallback;
  List<Folder> foldersList;
  Folder currentFolder;

  _SimpleDrawerBuilderState(
      this.root, this.onFolderTapCallback, this.currentFolder);

  @override
  Widget build(BuildContext context) {
    foldersList = _flattenFoldersStructure(this.root, 0, List());
    var folderName = currentFolder?.name ?? "Unknown";
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: new AppBar(
          title: new Text(folderName),
          backgroundColor: Colors.blueAccent,
        ),
        body: new Scaffold(
          body: ListView.builder(
            itemBuilder: (context, i) => GestureDetector(
              child: AnimatedContainer(
                child: _buildFolderRow(foldersList[i]),
                duration: Duration(milliseconds: 1000),
                curve: Curves.ease,
                height: foldersList[i].parent?.isExpanded ?? true ? 50 : 0,
              ),
              onTap: () {
                setState(() {
                  foldersList[i].isExpanded = !foldersList[i].isExpanded;
                });
              },
              onDoubleTap: () {
                this.onFolderTapCallback.call(foldersList[i]);
                Navigator.of(context).pop();
              },
            ),
            itemCount: foldersList.length,
            scrollDirection: Axis.vertical,
          ),
        ));
  }

  Widget _buildFolderRow(Folder folder) {
    if (folder.subFolders?.length == 0 ?? false) {
      return Container(
        padding: EdgeInsets.only(left: folder.level * 7.0),
        decoration: BoxDecoration(color: Colors.blue[100]),
        child: ListTile(
          title: Text(folder.name),
          leading: Icon(
            Icons.folder,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 1.0),
        padding: EdgeInsets.only(left: folder.level * 7.0),
        decoration: BoxDecoration(color: Colors.blueAccent),
        child: ListTile(
          title: Text(
            folder.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: Icon(
            folder.isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  List<Folder> _flattenFoldersStructure(
      Folder folder, int level, List<Folder> foldersList) {
    folder.level = level;
    if (folder.parent?.isExpanded ?? true) {
      foldersList.add(folder);
      folder.subFolders.forEach((subfolder) =>
          _flattenFoldersStructure(subfolder, level + 1, foldersList));
    }
    return foldersList;
  }
}
