import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({
    Key? key,
    required this.filePath,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    log("disposing off the video controller");
    _videoPlayerController.dispose();
    super.dispose();
  }

  Stream<bool> _initVideoPlayer() async* {
    yield false;
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    log(widget.filePath);
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    yield true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              log("i am sending the video nudge");
              Navigator.of(context).pop(widget.filePath);
            },
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: _initVideoPlayer(),
        builder: (context, state) {
          if (state.data == false ||
              state.connectionState == ConnectionState.waiting) {
            log("waiting for the video to load");
            return const Center(child: CircularProgressIndicator());
          } else {
            log("in the screen");

            var scale = _videoPlayerController.value.aspectRatio;

            if (scale < 1) scale = 1 / scale;

            return Transform.scale(
              scale: scale,
              child: VideoPlayer(
                _videoPlayerController,
              ),
            );
          }
        },
      ),
    );
  }
}
