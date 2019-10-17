import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/pages/asset_view_page.dart';

class Asset {
  int id;
  String title;
  String description;
  String imagePath;

  Asset({this.id, this.title, this.description, this.imagePath});

  static Asset fromJson(Map<String, dynamic> json) {
    return new Asset(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imagePath: json["imagePath"]);
  }
}

class AssetWidget extends StatelessWidget {
  final Asset asset;

  AssetWidget(this.asset);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AssetPageView(asset)));
        },
        child: Container(
            height: 50,
            alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.only(left: 1.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Color.fromRGBO(0, 82, 204, 1.0), width: 0.4)),
            child: Row(
              children: <Widget>[
                Image.network(
                  asset.imagePath,
                  headers: {"Authorization": "Basic YWRtaW46YWRtaW4="},
                  fit: BoxFit.fill,
                  width: 50,
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.only(left: 2.0),
                  child: Text(asset.title),
                )
              ],
            )));
  }
}
