import 'package:asset_tracker_mobile/models/asset.dart';
import 'package:flutter/material.dart';

class AssetPageView extends StatelessWidget {
  final Asset asset;

  AssetPageView(this.asset);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(asset.title,
            style: TextStyle(
                color: Colors.white, backgroundColor: Colors.blueAccent)),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _thumbnail(),
            _title(),
            _description(),
          ],
        ),
      ),
    );
  }

  Widget _thumbnail() {
    return Image.network(
      asset.imagePath,
      headers: {"Authorization": "Basic YWRtaW46YWRtaW4="},
      fit: BoxFit.contain,
      width: 250,
      height: 250,
    );
  }

  Widget _title() {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Text(
          asset.title,
          softWrap: true,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontWeight: FontWeight.bold,
                           ),
          textScaleFactor: 1.5,
        ));
  }

  Widget _description() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Text(
        asset.description,
        softWrap: true,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
