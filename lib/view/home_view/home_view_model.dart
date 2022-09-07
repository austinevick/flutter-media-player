import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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
  ];

  Future<List<FileSystemEntity>> dirContents() async {
    if (await requestPermission(Permission.storage)) {
      var dir = Directory(
          '/storage/emulated/0/famenet'); //You can change this path to your use case
      var files = <FileSystemEntity>[];
      var completer = Completer<List<FileSystemEntity>>();
      var lister = dir.list();
      lister.listen((file) => files.add(file),
          onDone: () => completer.complete(files));
      final l = await completer.future;
      for (var entity in l) {
        print(entity.path.endsWith('.mp4'));
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
