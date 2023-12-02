import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:dating_app/screen/Edit_Profile/video_player.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.question, required this.order})
      : super(key: key);

  final String question;
  final int order;

  @override
  // ignore: library_private_types_in_public_api
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    log("waiting for camera");
    final cameras = await availableCameras();
    log("camera found");
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    log("setting max resolution");
    _cameraController = CameraController(front, ResolutionPreset.max);
    log("initializing the camera");
    await _cameraController.initialize();
    log("camera init");
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      setState(() => _isRecording = false);
      final file = await _cameraController.stopVideoRecording();
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(
          filePath: file.path,
        ),
      );
      // ignore: use_build_context_synchronously
      String path = await Navigator.push(context, route);

      // ignore: use_build_context_synchronously
      if (path.isNotEmpty) Navigator.pop(context, path);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
