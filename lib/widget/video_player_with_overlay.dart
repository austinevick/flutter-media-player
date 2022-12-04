import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_player/widget/custom_button.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWithOverlay extends StatefulWidget {
  const VideoPlayerWithOverlay({super.key});

  @override
  State<VideoPlayerWithOverlay> createState() => _VideoPlayerWithOverlayState();
}

class _VideoPlayerWithOverlayState extends State<VideoPlayerWithOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final VideoPlayerController videoController;
  OverlayEntry? _overlayEntry;
  bool isPlaying = false;
  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  bool get isOverlayShown => _overlayEntry != null;

  void showOverlay(Widget child) =>
      isOverlayShown ? removeOverlay() : _insertOverlay(child);

  void _insertOverlay(Widget child) {
    _overlayEntry = OverlayEntry(
      builder: (_) => GestureDetector(
          onTap: () {
            removeOverlay();
          },
          child: Material(
            color: Colors.black54.withOpacity(0.5),
            child: child,
          )),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void fadeOutController() =>
      Future.delayed(const Duration(seconds: 10), () => removeOverlay());

  void playerHandler() => setState(() {
        isPlaying = !isPlaying;
        if (isPlaying) {
          animationController.forward();
          videoController.pause();
        } else {
          animationController.reverse();
          videoController.play();
        }
      });

  @override
  void initState() {
    videoController = VideoPlayerController.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
      ..initialize()
      ..play()
      ..addListener(() => setState(() {}));
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showOverlay(VideoPlayerControllers(
        videoController: videoController,
        animationController: animationController,
        onTap: () => playerHandler(),
      ));
    });
    fadeOutController();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showOverlay(VideoPlayerControllers(
            videoController: videoController,
            animationController: animationController,
            onTap: () => playerHandler()));
        fadeOutController();
      },
      child: Scaffold(
        body: Center(
          child: AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              child: VideoPlayer(videoController)),
        ),
      ),
    );
  }
}

class VideoPlayerControllers extends StatefulWidget {
  final VideoPlayerController videoController;
  final AnimationController animationController;
  final VoidCallback onTap;
  const VideoPlayerControllers(
      {super.key,
      required this.videoController,
      required this.animationController,
      required this.onTap});

  @override
  State<VideoPlayerControllers> createState() => _VideoPlayerControllersState();
}

class _VideoPlayerControllersState extends State<VideoPlayerControllers> {
  bool isFullScreenMode = false;
  bool reInitializePlayer = false;
  Connectivity connectivity = Connectivity();
  @override
  void initState() {
    connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 35),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackButton(),
              IconButton(
                  onPressed: () {
                    setState(() => isFullScreenMode = !isFullScreenMode);
                    if (isFullScreenMode) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft,
                      ]);
                    } else {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                    }
                  },
                  icon: const Icon(Icons.fullscreen)),
            ],
          ),
        ),
        const Spacer(flex: 2),
        !widget.videoController.value.isInitialized
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: IconButton(
                    iconSize: 120,
                    color: Colors.red,
                    onPressed: widget.onTap,
                    icon: AnimatedIcon(
                        icon: AnimatedIcons.pause_play,
                        progress: widget.animationController))),
        const Spacer(flex: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Text(getDurationAsString(widget.videoController.value.duration)),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 6, right: 6),
              child: SizedBox(
                  height: 10,
                  child: VideoProgressIndicator(widget.videoController,
                      allowScrubbing: true)),
            )),
            Text(getDurationAsString(widget.videoController.value.duration -
                widget.videoController.value.position))
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                iconSize: 65,
                onPressed: () {
                  Duration currentPosition =
                      widget.videoController.value.position;
                  Duration targetPosition =
                      currentPosition - const Duration(seconds: 10);
                  widget.videoController.seekTo(targetPosition);
                },
                icon: const Icon(Icons.skip_previous)),
            IconButton(
                iconSize: 65,
                onPressed: () {
                  Duration currentPosition =
                      widget.videoController.value.position;
                  Duration targetPosition =
                      currentPosition + const Duration(seconds: 10);
                  widget.videoController.seekTo(targetPosition);
                },
                icon: const Icon(Icons.skip_next, size: 65)),
          ],
        ),
        const SizedBox(height: 30)
      ],
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

  SnackBar get snackBar => SnackBar(
      duration: const Duration(days: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'No Connection',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          TextButton(
              onPressed: () => widget.videoController
                ..initialize()
                ..play(),
              child: const Text('Retry',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.w700)))
        ],
      ));
}
