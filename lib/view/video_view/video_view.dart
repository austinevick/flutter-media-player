import 'package:flutter/material.dart';
import 'package:flutter_media_player/src/custom_video_player.dart';
import 'package:flutter_media_player/view/video_view/video_view_model.dart';
import 'package:stacked/stacked.dart';

class VideoView extends StatelessWidget {
  final String url;
  final bool isLocal;
  const VideoView({Key? key, required this.url, required this.isLocal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VideoViewModel>.reactive(
        viewModelBuilder: () => VideoViewModel(),
        onDispose: (model) => model.dispose(),
        onModelReady: (model) => model.init(context, url, isLocal),
        builder: (context, model, child) => Scaffold(
              body: Center(
                child: CustomVideoPlayer(
                    customVideoPlayerController: model.controller!),
              ),
            ));
  }
}
