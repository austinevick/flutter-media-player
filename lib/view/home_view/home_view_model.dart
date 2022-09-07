import 'package:flutter/cupertino.dart';

class HomeViewModel extends ChangeNotifier {
  String title = 'Video';

  List<String> videos = [
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4",
  ];
}
