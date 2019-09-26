class Asset {
  int id;
  String title;
  String description;

  Asset({this.id, this.title, this.description});

  static Asset fromJson(Map<dynamic, dynamic> json) {
    return new Asset(
        id: json["id"], title: json["title"], description: json["description"]);
  }
}
