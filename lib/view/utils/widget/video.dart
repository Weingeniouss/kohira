// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../app_json.dart';

class VideoPlayerMenu extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerMenu({required this.videoUrl});

  @override
  State<VideoPlayerMenu> createState() => _VideoPlayerMenuState();
}

class _VideoPlayerMenuState extends State<VideoPlayerMenu> {
  late VideoPlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.setVolume(0.0); // Mute video
        _controller.setLooping(true);
        _controller.play();
        setState(() {
          _isReady = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return Center(child: Lottie.asset(AppJson.loading2));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
        Container(color: Colors.black.withOpacity(0.0)),
      ],
    );
  }
}
