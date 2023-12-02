import 'dart:developer';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class PlayingAudio extends StatefulWidget {
  const PlayingAudio({super.key, required this.path});

  // we would be using the cache memory to store the music so save the path
  final String path;

  @override
  State<PlayingAudio> createState() => _PlayingAudioState();
}

class _PlayingAudioState extends State<PlayingAudio> {
  late PlayerController playerController; // init the player controller
  @override
  void initState() {
    super.initState(); // init the parent states
    playerController = PlayerController(); // init the player contoller
  }

  @override
  void dispose() {
    playerController
        .dispose(); // before deleting the state dispose the controller
    super.dispose(); // dispose the parent states now
  }

  // before playing we need to prep the player
  // by giving the path and extracting the wave form and all
  void prepPlayer() async {
    await playerController.preparePlayer(
      path: widget.path, // path for the audio
      shouldExtractWaveform: true, // for the waveform
      noOfSamples: 100, // number of samples for waveform
    );
  }

  @override
  Widget build(BuildContext context) {
    prepPlayer();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // center the main axis of column
          crossAxisAlignment:
              CrossAxisAlignment.center, // center the cross axis of column
          children: [
            AudioFileWaveforms(
              // showing the wave from
              size: Size(MediaQuery.of(context).size.width,
                  100.0), // size of the waveform
              playerController:
                  playerController, // controller controlling the player
              enableSeekGesture: true, // enable seeking
              waveformType: WaveformType.long, // long waveform
              playerWaveStyle: const PlayerWaveStyle(
                // have blue accents and white wave
                fixedWaveColor: Colors.white54,
                liveWaveColor: Colors.blueAccent,
                spacing: 6,
              ),
            ),
            StreamBuilder(
              // stream builder to show the current state
              stream: playerController.onPlayerStateChanged,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Wait till we have our controller started");
                } else {
                  return Text(snapshot.data.toString());
                }
              },
            ),
            // making an icon button to play the audio
            IconButton(
              onPressed: () {
                log("playing");
                playerController.startPlayer(finishMode: FinishMode.loop);
              },
              icon: const Icon(Icons.play_arrow),
            ),
            // making an icon button to pause the audio
            IconButton(
              onPressed: () {
                log("paused");
                playerController.pausePlayer();
              },
              icon: const Icon(Icons.pause_sharp),
            ),
          ],
        ),
      ),
    );
  }
}
