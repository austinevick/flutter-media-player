import 'package:flutter/material.dart';

import '../custom_video_player_controller.dart';
import 'fullscreen_button.dart';
import 'play_button.dart';
import 'progress_bar.dart';

class CustomVideoPlayerControlBar extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateVideoState;
  final Function fadeOutOnPlay;
  const CustomVideoPlayerControlBar({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateVideoState,
    required this.fadeOutOnPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: customVideoPlayerController
          .customVideoPlayerSettings.controlBarPadding,
      decoration: customVideoPlayerController
          .customVideoPlayerSettings.controlBarDecoration,
      child: Row(
        children: [
          if (customVideoPlayerController
              .customVideoPlayerSettings.showPlayButton)
            CustomVideoPlayerPlayPauseButton(
              customVideoPlayerController: customVideoPlayerController,
              fadeOutOnPlay: fadeOutOnPlay,
            ),
          if (customVideoPlayerController
              .customVideoPlayerSettings.showDurationPlayed)
            Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: ValueListenableBuilder<Duration>(
                valueListenable:
                    customVideoPlayerController.videoProgressNotifier,
                builder: ((context, progress, child) {
                  return Text(
                    getDurationAsString(progress),
                    style: customVideoPlayerController
                        .customVideoPlayerSettings.durationPlayedTextStyle,
                  );
                }),
              ),
            ),
          Expanded(
            child: CustomVideoPlayerProgressBar(
              customVideoPlayerController: customVideoPlayerController,
            ),
          ),
          if (customVideoPlayerController
              .customVideoPlayerSettings.showDurationRemaining)
            Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: ValueListenableBuilder<Duration>(
                valueListenable:
                    customVideoPlayerController.videoProgressNotifier,
                builder: ((context, progress, child) {
                  return Text(
                    "-${getDurationAsString(customVideoPlayerController.videoPlayerController.value.duration - progress)}",
                    style: customVideoPlayerController
                        .customVideoPlayerSettings.durationRemainingTextStyle,
                  );
                }),
              ),
            ),
          if (customVideoPlayerController
              .customVideoPlayerSettings.showFullscreenButton)
            CustomVideoPlayerFullscreenButton(
              customVideoPlayerController: customVideoPlayerController,
            )
        ],
      ),
    );
  }

  String getDurationAsString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration > const Duration(hours: 1)) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
