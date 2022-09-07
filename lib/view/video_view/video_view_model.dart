import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_media_player/src/custom_video_player_controller.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends BaseViewModel {
  VideoPlayerController? playerController;
  CustomVideoPlayerController? controller;

  void init(BuildContext context, String url, bool isLocal) {
    playerController = isLocal
        ? VideoPlayerController.file(File(url))
        : VideoPlayerController.network(url)
      ..initialize().then((value) => notifyListeners())
      ..play();
    controller = CustomVideoPlayerController(
        context: context, videoPlayerController: playerController!);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
