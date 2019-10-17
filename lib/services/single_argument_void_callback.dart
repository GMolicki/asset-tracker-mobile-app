import 'package:asset_tracker_mobile/models/folders/folder.dart';

typedef SingleArgumentVoidCallback = void Function(Folder);

class SingleArgumentCallback {
  final SingleArgumentVoidCallback callback;
  SingleArgumentCallback(this.callback);

  void call(Folder folder) {
    this.callback(folder);
  }
}
