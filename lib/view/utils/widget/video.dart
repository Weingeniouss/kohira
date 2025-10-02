// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print, unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.setVolume(0.0); // Mute video
        _controller.setLooping(true);
        _controller.play();
        setState(() {
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

    //Loading

    // if (!_isReady) {
    //   return Center(child: Lottie.asset(AppJson.loading2));
    // }

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

class VideoPlayerMenuContainer extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerMenuContainer({super.key, required this.videoUrl});

  @override
  _VideoPlayerMenuContainerState createState() => _VideoPlayerMenuContainerState();
}

class _VideoPlayerMenuContainerState extends State<VideoPlayerMenuContainer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Center(child: Lottie.asset(AppJson.loading2));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(Get.width * 0.02),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}

class VideoPlayerMenuSecond extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerMenuSecond({required this.videoUrl});

  @override
  State<VideoPlayerMenuSecond> createState() => _VideoPlayerMenuSecondState();
}

class _VideoPlayerMenuSecondState extends State<VideoPlayerMenuSecond> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = false;
  bool _isPlaying = false;
  bool _isMuted = true; // Track mute state separately
  late Duration _videoDuration;
  late Duration _currentPosition;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..setVolume(0.0) // Start muted
        ..setLooping(true);

      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = true;
          _videoDuration = _controller.value.duration;
          _currentPosition = _controller.value.position;
        });
        _controller.play();
        _controller.addListener(_updateVideoPosition);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
      print('Video initialization error: $error');
    }
  }

  void _updateVideoPosition() {
    if (mounted) {
      setState(() {
        _currentPosition = _controller.value.position;
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
    _showControlsTemporarily();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
    _showControlsTemporarily();
  }

  void _seekToPosition(double value) {
    final newPosition = _videoDuration * value;
    _controller.seekTo(newPosition);
    setState(() {
      _currentPosition = newPosition;
    });
    _showControlsTemporarily();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    _resetControlsTimer();
  }

  void _showControlsTemporarily() {
    if (!_showControls) {
      setState(() {
        _showControls = true;
      });
    }
    _resetControlsTimer();
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    if (_showControls) {
      _controlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _showControls) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _hideControls() {
    if (_showControls) {
      setState(() {
        _showControls = false;
      });
    }
  }

  @override
  void didUpdateWidget(VideoPlayerMenuSecond oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.removeListener(_updateVideoPosition);
      _isInitialized = false;
      _hasError = false;
      _showControls = false;
      _controlsTimer?.cancel();
      _controller.dispose();
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateVideoPosition);
    _controlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized && !_hasError) {
      return Container(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Icon(Icons.error_outline, color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Player
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),

          // Semi-transparent overlay when controls are visible
          if (_showControls || !_isPlaying)
            Container(color: Colors.black.withOpacity(0.3)),

          // Center Play/Pause Button (only when video is paused or controls are visible)
          if ((_showControls && !_isPlaying) || (!_showControls && !_isPlaying))
            Center(
              child: IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),

          // Progress Indicator at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _showControls ? 100 : 40,
              color: Colors.black.withOpacity(_showControls ? 0.7 : 0.5),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    if (_showControls)
                    // Progress Slider
                    Row(
                      children: [
                        // Current time
                        Text(
                          _formatDuration(_currentPosition),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),

                        Expanded(
                          child: Slider(
                            value: _videoDuration.inSeconds > 0 ? _currentPosition.inSeconds / _videoDuration.inSeconds : 0,
                            onChanged: _seekToPosition,
                            min: 0.0,
                            max: 1.0,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.3),
                          ),
                        ),

                        // Total time
                        Text(
                          _formatDuration(_videoDuration),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    // Additional controls (visible only when controls are shown)
                    if (_showControls)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _togglePlayPause,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            onPressed: _toggleMute,
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}