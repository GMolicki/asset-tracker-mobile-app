import 'dart:async';
import 'dart:convert';
import 'package:asset_tracker_mobile/models/asset.dart';
import 'package:asset_tracker_mobile/models/folders/folder.dart';
import 'package:http/http.dart';

abstract class AssetTrackerRest {
  Future<List<Asset>> searchAssets(int folderId, String query);

  Future<Folder> getFoldersTree();
}

class AssetTrackerService implements AssetTrackerRest {
  String authHeader;

  AssetTrackerService(this.authHeader);

  @override
  Future<List<Asset>> searchAssets(int folderId, String query) {
    var uri = Uri.http("localhost:2990", "/jira/rest/com-spartez-ephor/2.0/assets",
        {"folderId": folderId.toString(), "query": query, "limit": "100"});
    return get(uri.toString(), headers: {"Authorization": authHeader, "Accept": "application/json"}).then((data) {
      try {
        Iterable l = json.decode(data.body);
        List<Asset> assets = l.map((model) => Asset.fromJson(model)).toList();
        return assets;
      } catch (e) {
        print(e);
        return List();
      }
    });
  }

  @override
  Future<Folder> getFoldersTree() {
    return get(
        "http://localhost:2990/jira/rest/com-spartez-ephor/2.0/folders?fields=id,name,subFolders&expand=subFolders",
        headers: {
          "Authorization": this.authHeader,
        }).then((data) {
      try {
        Map<String, dynamic> l = json.decode(data.body);
        Folder folder = Folder.fromJson(l);
        return folder;
      } catch (e) {
        return Folder(id: -1, name: "Unable to download folders", subFolders: List());
      }
    });
  }
}
