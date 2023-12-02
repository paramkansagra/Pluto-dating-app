import 'dart:async';
import 'dart:developer';
import 'package:dating_app/screen/audio_play.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioRecord extends StatefulWidget {
  const AudioRecord({
    super.key,
    this.minutes = 0, // initilize with 0 minute and 30 seconds
    this.seconds = 30,
  });

  // making it modular so that we can have variable number of minutes and seconds to record
  final int minutes;
  final int seconds;

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  // the controller we would be using for recording
  late final RecorderController recorderController;

  @override
  void initState() {
    super.initState(); // calling the init state of super classes
    recorderController = RecorderController() // init the recorder
      ..androidEncoder = AndroidEncoder
          .aac // the encoder we should be using for android for performance and support
      ..androidOutputFormat =
          AndroidOutputFormat.mpeg4 // the output format for android support
      ..iosEncoder = IosEncoder
          .kAudioFormatMPEG4AAC // ios encoder which basically has both the output format and encoder in onc
      ..sampleRate = 44100 // best sample rate for voice
      ..updateFrequency = const Duration(
          milliseconds: 180); // aprox 3fps for recording waveform
  }

  @override
  void dispose() {
    recorderController
        .dispose(); // disposing the recorder as it may have performance impact
    super.dispose();
  }

  // if i have previously recorded
  bool recorded = false;
  // path to the storage of voice we recorded
  late String? path = "";
  // we would have a timer for limit of recording we can do
  Timer? _timer;

  // making a function to start recording
  Future<void> startRecording() async {
    log("Long press start recording");
    recorderController.refresh(); // bring the wave form to the right
    await recorderController.record(); // start recording
  }

  // making a function for stop recording
  Future<void> stopRecording() async {
    // getting the path after recording
    path = await recorderController.stop();
    log(path.toString()); // loging the path for debug purposes
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayingAudio(path: path!),
      ),
    ); // pushing to next page for debug
    setState(() {}); // setting state to send the voice note
  }

  @override
  Widget build(BuildContext context) {
    // init the scaffold
    return Scaffold(
      // init the center widget to present in center
      body: Center(
        // init the row for showing
        child: Row(
          // for keeping everything in center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // we are having expanded so that it takes the space it wants and other space is given to icons
            Expanded(
              // audio wave forms for showing the wave form
              child: AudioWaveforms(
                size: Size(MediaQuery.of(context).size.width,
                    50), // complete width and 50px size of height for window
                padding: const EdgeInsets.symmetric(
                    horizontal: 10), // padding for wave form
                decoration: BoxDecoration(
                  color: Colors.white, // having white box
                  borderRadius: BorderRadius.circular(100), // circular borders
                ),
                recorderController:
                    recorderController, // controller that is generating the wave forms
                enableGesture: true, // can we scroll the wave form
                waveStyle: const WaveStyle(
                  waveColor: Colors.black, // color of the wave form
                  spacing: 8.0, // spacing between the wave forms
                  showBottom:
                      false, // we only want vertical wave forms and not the bottom ones
                  extendWaveform: true,
                  showMiddleLine:
                      false, // we dont want the middle line under the wave form
                  waveThickness: 7, // thickness of the waveform
                  scaleFactor:
                      20, // how much is the sound scaled for the wave form
                  bottomPadding: 10, // bottom padding for wave form
                ),
              ),
            ),
            StreamBuilder(
              stream: recorderController
                  .onRecorderStateChanged, // stream builder for time that we are showing
              builder: (context, snapshot) {
                log(snapshot.data
                    .toString()); // loging if the snapshot has data for debug
                if (snapshot.data ==
                        null || // if the snapshot is null or if the recording has stopped we would show 0 time
                    snapshot.data == RecorderState.stopped) {
                  return const Text("00:00");
                }
                return StreamBuilder(
                  // else we would show the current time duration
                  stream: recorderController.onCurrentDuration,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Text(snapshot.data!.inSeconds.toMMSS().toString());
                    } else {
                      return const Text("00:00");
                    }
                  },
                );
              },
            ),
            SizedBox(
              // sized box for the mic icon and its related functions
              height: 50,
              width: 50,
              child: GestureDetector(
                // we will have a gesture dector for different gestures
                child: InkWell(
                  // using ink well for the background effect that it has when we tap the icon
                  onTap:
                      () {}, // need to pass a function to get the background effect
                  borderRadius: BorderRadius.circular(
                      100), // circular border when we long tap

                  child: const Icon(Icons.mic,
                      color: Colors.white), // mic icon and its color
                ),
                onLongPressDown: (details) async {
                  // when we long press down for the first time for starting to record
                  if (recorded) {
                    return; // if we have already recorded just return and dont do anything
                  }
                  await startRecording(); // else start recording
                  _timer = Timer(
                    // setting a timer so that we only have limited amount of time to record
                    Duration(
                      minutes: widget.minutes,
                      seconds: widget.seconds,
                    ),
                    () async {
                      await stopRecording(); // after timer has finished stop recording
                      recorded = true; // and mark as recorded
                    },
                  );
                },
                onLongPressUp: () async {
                  // else if we pull our finger up
                  if (_timer != null) {
                    _timer!
                        .cancel(); // maybe before timer has finished then stop the timer
                  }
                  if (!recorded) {
                    await stopRecording(); // if we have stopped before finishing the timer then we should stop recording
                  }
                  recorded = true; // and mark as we have recorded
                },
              ),
            ),
            // now if the path is not null and not empty
            if (path != null && path!.isNotEmpty)
              // show an icon button
              IconButton(
                // which on pressed would go to the next screen
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PlayingAudio(path: path!), // go to playing the audio
                    ),
                  );
                },
                // show the icon and its color
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
