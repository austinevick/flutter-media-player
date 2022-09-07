import 'package:flutter/cupertino.dart';
import 'package:flutter_media_player/src/custom_video_player_controller.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  VideoPlayerController? playerController;
  CustomVideoPlayerController? controller;

  void init(BuildContext context, String url) {
    playerController = VideoPlayerController.network(url)
      ..initialize().then((value) => notifyListeners());
    controller = CustomVideoPlayerController(
        context: context, videoPlayerController: playerController!);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
