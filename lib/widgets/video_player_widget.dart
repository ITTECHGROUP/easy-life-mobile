import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            showControlsOnInitialize: false,
          );
          _videoPlayerController.play();
      });

    

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        setState(() {});  // Actualiza el estado para cambiar el ícono al finalizar
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoPlayerController.value.size.width,
                          height: _videoPlayerController.value.size.height,
                          child: Chewie(
                            controller: _chewieController!,
                          ),
                        ),
                      ),
                    ),
                    // ignore: lines_longer_than_80_chars
                    Positioned.fill(child: CustomControls(controller: _chewieController!,)),
                  ],
                ),
              )
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

class CustomControls extends StatefulWidget {
  final ChewieController controller;

  const CustomControls({required this.controller, super.key});

  @override
  State<CustomControls> createState() => _CustomControlsState();
}

class _CustomControlsState extends State<CustomControls> {
  bool _visible = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _visible = false;
        });
      }
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _visible = true;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_visible) {
          setState(() {
            _visible = false;
          });
          _timer.cancel();
        } else {
          _resetTimer();
        }
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: double.infinity,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    widget.controller.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (widget.controller.isPlaying) {
                      widget.controller.pause();
                    } else {
                      widget.controller.play();
                    }
                    _resetTimer();
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.controller.enterFullScreen();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}