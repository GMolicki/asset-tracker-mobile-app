class Folder {
  int id;
  String name;
  List<Folder> subFolders = List();
  bool isExpanded = false;
  Folder parent;
  int level;

  Folder({this.id, this.name, this.subFolders});

  static Folder fromJson(Map<String, dynamic> folderMap) {
    Iterable l = folderMap["subFolders"];
    List<Folder> subFolders = l.map((f) => fromJson(f)).toList();
    Folder root = new Folder(id: folderMap["id"], name: folderMap["name"], subFolders: subFolders);
    if(root.name == 'All') {
      root.isExpanded = true;
    }
    root.subFolders.forEach((sub) => sub.parent = root);
    return root;
  }
}
