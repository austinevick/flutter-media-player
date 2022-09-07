import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends FutureViewModel<List<FileSystemEntity>> {
  String title = 'Media Player';
  int selectedIndex = 0;

  void setIndexValue(int i) {
    selectedIndex = i;
    notifyListeners();
  }

  List<String> videos = [
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4",
  ];

  Future<List<FileSystemEntity>> dirContents() async {
    if (await requestPermission(Permission.storage)) {
      var dir = Directory('/storage/emulated/0/');
      var files = <FileSystemEntity>[];
      var completer = Completer<List<FileSystemEntity>>();
      var lister = dir.list(recursive: false);
      lister.listen((file) => files.add(file),
          // should also register onError
          onDone: () => completer.complete(files));
      final l = await completer.future;
      for (var files in l) {
        print(files.path);
      }

      return completer.future;
    }
    return [];
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Future<List<FileSystemEntity>> futureToRun() async => await dirContents();
}
