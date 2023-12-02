import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dating_app/api/send_nudge_api.dart';
import 'package:dating_app/screen/Edit_Profile/video_player.dart';
import 'package:dating_app/screen/Edit_Profile/video_recording.dart';
import 'package:flutter/material.dart';

// we have the state of the window in which we are in
enum ContainerState { empty, text, audio }

class EditAnswer extends StatefulWidget {
  const EditAnswer({
    super.key,
    required this.question,
    this.order = 0,
    this.nudgeId,
    this.prebuiltAnswer = "",
    this.audioPath = "",
    this.videoPath = "",
  });

  // getting the previous answer that we had in here
  final String? prebuiltAnswer;
  // getting the previous audio that we had in here
  final String? audioPath;
  // getting the previous video that we had in here
  final String? videoPath;
  // getting the nudge id if we are updating the nudge
  final int? nudgeId;
  // getting the question
  final String question;

  // getting the order of the question
  final int order;

  @override
  State<EditAnswer> createState() => _EditAnswerState();
}

class _EditAnswerState extends State<EditAnswer> {
  // we have 2 controllers
  late final TextEditingController
      textEditingController; // for editing the text
  late final RecorderController recorderController; // for recording
  late ContainerState prevTextState; // this stores the state of the screen
  late PlayerController playerController; // init the player controller

  final SendNudge sendNudge = SendNudge();

  // how much time do we need to recording
  final _minutes = 0;
  final _seconds = 30;

  // if i have previously recorded
  bool recorded = false;
  // path to the storage of voice we recorded
  late String? path = "";
  // we would have a timer for limit of recording we can do
  Timer? _timer;

  // have i completed the recording
  bool recordingCompleted = false;

  // if we are sending just show a rotating indicator
  bool isSending = false;

  // have i completed recording

  // when the screen is initialized
  @override
  void initState() {
    // initializing the other super states
    super.initState();

    // we will push the prebuilt answer in here if we have a answer prebuilt
    if (widget.prebuiltAnswer != null && widget.prebuiltAnswer!.isNotEmpty) {
      prevTextState = ContainerState.text;
    } else if (widget.audioPath != null && widget.audioPath!.isNotEmpty) {
      prevTextState = ContainerState.audio;
      path = widget.audioPath;
      recordingCompleted = true;
    } else if (widget.videoPath != null && widget.videoPath!.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VideoPage(
            filePath: widget.videoPath!,
          ),
        ),
      );
    } else {
      prevTextState = ContainerState.empty;
    }

    // when we are doing any changes in the text feild we will listen to it
    textEditingController = TextEditingController()
      ..addListener(textEditingListner);

    // we are configuring the text editing controller if we have any text incoming
    textEditingController.text = widget.prebuiltAnswer ?? "";
    // we will move the position of the cursor to the final position
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: textEditingController.text.length),
    );

    // initalizing the recorder
    recorderController = RecorderController();
    recorderController.androidEncoder = AndroidEncoder
        .aac; // the encoder we should be using for android for performance and support
    recorderController.androidOutputFormat =
        AndroidOutputFormat.mpeg4; // the output format for android support
    recorderController.iosEncoder = IosEncoder
        .kAudioFormatMPEG4AAC; // ios encoder which basically has both the output format and encoder in onc
    recorderController.bitRate = 44100; // bit rate for good recording

    // init the player contoller
    playerController = PlayerController();
  }

  // when closing the screen we need to dispose off the controllers
  @override
  void dispose() {
    log("the controllers are disposed");

    textEditingController.dispose();
    recorderController.dispose();
    playerController.dispose();
    super.dispose();
  }

  // making a function to start recording
  Future<void> startRecording() async {
    log("Long press start recording");
    recorderController.refresh(); // bring the wave form to the right
    await recorderController.record(); // start recording

    _timer = Timer(
      // setting a timer so that we only have limited amount of time to record
      Duration(
        minutes: _minutes,
        seconds: _seconds,
      ),
      () async {
        await stopRecording(); // after timer has finished stop recording
        recorded = false; // and mark as recorded
      },
    );
  }

  // making a function for stop recording
  Future<void> stopRecording() async {
    // getting the path after recording
    path = await recorderController.stop();
    log("stop recording");
    log(path.toString()); // loging the path for debug purposes

    recordingCompleted = true;
    await prepPlayer();
    setState(() {}); // setting state to send the voice note
  }

  // before playing we need to prep the player
  // by giving the path and extracting the wave form and all
  Future<void> prepPlayer() async {
    log("preparing the player");
    log("prep player path -> $path");
    // dispose the player if it previously played some track
    playerController.dispose();
    // init the player contoller
    playerController = PlayerController();
    // again prepare the player
    log("path of audio is -> $path");
    await playerController.preparePlayer(
      path: path!, // path for the audio
      shouldExtractWaveform: true, // for the waveform
      noOfSamples: 100, // number of samples for waveform
    );
    log("player prepared");
  }

  void textEditingListner() {
    log("text editing listner -> ${textEditingController.text}");
    log("prev state -> $prevTextState");

    if (prevTextState == ContainerState.audio) {
      log("got notified by the audio");
      setState(() {});
    }

    if (textEditingController.text.isEmpty &&
        prevTextState == ContainerState.text) {
      prevTextState = ContainerState.empty;
      setState(() {});
    } else if (textEditingController.text.isNotEmpty &&
        prevTextState == ContainerState.empty) {
      prevTextState = ContainerState.text;
      setState(() {});
    } else if (prevTextState == ContainerState.empty) {
      setState(() {});
    }
  }

  TextFormField textFeild() {
    return TextFormField(
      autofocus: true,
      controller: textEditingController,
      keyboardType: TextInputType.name,
      maxLength: 100,
      cursorColor: Theme.of(context).textTheme.headlineMedium!.color,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.black,
            fontSize: 20,
          ),
    );
  }

  Widget allThree() {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            log("i am video recording");
            String path = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CameraPage(
                  question: widget.question,
                  order: widget.order,
                ),
              ),
            );

            isSending = true;
            setState(() {});

            bool sent = await sendNudge.sendVideoNudge(
              question: widget.question,
              videoPath: path,
              order: widget.order,
              nudgeId: widget.nudgeId ?? -1,
            );

            if (sent) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Your nudge has been sent"),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              int count = 1;
              while (!sent && count < 9) {
                log("Sending nudge unsuccessful sent$count times sending again");
                sent = await sendNudge.sendVideoNudge(
                  question: widget.question,
                  videoPath: path,
                  order: widget.order,
                  nudgeId: widget.nudgeId ?? -1,
                );
                count++;
              }

              if (sent) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Your nudge has been sent"),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Sorry not able to send your nudge"),
                    duration: Duration(seconds: 2),
                  ),
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            }
          },
          icon: const Icon(Icons.camera_alt_sharp),
        ),
        Expanded(
          child: textFeild(),
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: InkWell(
            onTap: () async {
              prevTextState = ContainerState.audio;
              recorded = true;
              await startRecording();
              textEditingListner();
            },
            borderRadius: BorderRadius.circular(50),
            child: const Icon(Icons.mic_sharp),
          ),
        ),
      ],
    );
  }

  Widget onlyText() {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(child: textFeild()),
        IconButton(
            onPressed: () async {
              log("i am sending text nudge");
              String answer = textEditingController.text;

              isSending = true;
              setState(() {});

              bool sent = await sendNudge.sendTextNudge(
                question: widget.question,
                answer: answer,
                order: widget.order,
                nudgeId: widget.nudgeId ?? -1,
              );

              if (sent) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Your nudge has been sent"),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                int count = 1;
                while (!sent && count < 9) {
                  log("Sending nudge unsuccessful sent$count times sending again");
                  sent = await sendNudge.sendTextNudge(
                    question: widget.question,
                    answer: answer,
                    order: widget.order,
                    nudgeId: widget.nudgeId ?? -1,
                  );
                  count++;
                }

                if (sent) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Your nudge has been sent"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sorry not able to send your nudge"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              }
            },
            icon: const Icon(Icons.send_sharp)),
      ],
    );
  }

  Widget voiceRecording() {
    return Row(
      children: [
        Expanded(
          // audio wave forms for showing the wave form
          child: AudioWaveforms(
            size: Size(
              MediaQuery.of(context).size.width,
              50,
            ), // complete width and 50px size of height for window
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ), // padding for wave form
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
              scaleFactor: 80, // how much is the sound scaled for the wave form
              bottomPadding: 10, // bottom padding for wave form
            ),
          ),
        ),
        StreamBuilder(
          stream: recorderController
              .onRecorderStateChanged, // stream builder for time that we are showing
          builder: (context, snapshot) {
            log("recorder controller data -> ${snapshot.data.toString()}"); // loging if the snapshot has data for debug
            if (snapshot.data == RecorderState.stopped) {
              return Text(
                "00:00",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                    ),
              );
            }
            return StreamBuilder(
              // else we would show the current time duration
              stream: recorderController.onCurrentDuration,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Text(
                    snapshot.data!.inSeconds.toMMSS().toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                        ),
                  );
                } else {
                  return Text(
                    "00:00",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                        ),
                  );
                }
              },
            );
          },
        ),
        IconButton(
            onPressed: () async {
              if (recorded == false) {
                await startRecording();
                recorded = true;
                _timer = Timer(
                  // setting a timer so that we only have limited amount of time to record
                  Duration(
                    minutes: _minutes,
                    seconds: _seconds,
                  ),
                  () async {
                    await stopRecording(); // after timer has finished stop recording
                    recorded = false; // and mark as recorded
                  },
                );
              } else {
                if (_timer != null) {
                  _timer!
                      .cancel(); // maybe before timer has finished then stop the timer
                }
                recorded = false;
                await stopRecording();
              }
            },
            icon: const Icon(Icons.mic_sharp)),
      ],
    );
  }

  Widget showRecording() {
    prepPlayer();
    return Center(
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // center the main axis of column
        crossAxisAlignment:
            CrossAxisAlignment.center, // center the cross axis of column
        children: [
          Expanded(
            child: AudioFileWaveforms(
              // showing the wave from
              size: Size(
                MediaQuery.of(context).size.width,
                100.0,
              ), // size of the waveform
              playerController:
                  playerController, // controller controlling the player
              enableSeekGesture: true, // enable seeking
              waveformType: WaveformType.long, // long waveform
              animationCurve: Curves.easeIn, // animation style
              continuousWaveform: true,
              playerWaveStyle: const PlayerWaveStyle(
                spacing: 8.0, // spacing between the wave forms
                showBottom:
                    false, // we only want vertical wave forms and not the bottom ones
                showSeekLine: false, // middle line
                // have blue accents and white wave
                fixedWaveColor: Colors.black,
                liveWaveColor: Colors.blue,
                waveThickness: 7, // thickness of the waveform
                scaleFactor:
                    300, // how much is the sound scaled for the wave form
              ),
            ),
          ),
          StreamBuilder(
            // stream builder to show the current state
            stream: playerController.onCurrentDurationChanged,
            builder: (context, snapshot) {
              log("player controller connection state -> ${snapshot.connectionState}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  "00:00",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                      ),
                );
              } else {
                Duration durationCompleted =
                    Duration(milliseconds: snapshot.data!);
                final mm = (durationCompleted.inMinutes % 60)
                    .toString()
                    .padLeft(2, '0');
                final ss = (durationCompleted.inSeconds % 60)
                    .toString()
                    .padLeft(2, '0');
                return Text(
                  "$mm:$ss",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                      ),
                );
              }
            },
          ),
          // making an icon button to play the audio
          StreamBuilder(
            stream: playerController.onPlayerStateChanged,
            builder: ((context, snapshot) {
              log("player controller data -> ${snapshot.data.toString()}");
              if (snapshot.data == PlayerState.playing) {
                return IconButton(
                  onPressed: () {
                    log("paused");
                    playerController.pausePlayer();
                  },
                  icon: const Icon(Icons.pause_sharp),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    playerController.startPlayer(finishMode: FinishMode.stop);
                  },
                  icon: const Icon(Icons.play_arrow),
                );
              }
            }),
          ),

          IconButton(
              onPressed: () {
                recorded = false;
                recordingCompleted = false;
                prevTextState = ContainerState.empty;
                setState(() {});
              },
              icon: const Icon(Icons.close_sharp)),
          IconButton(
            onPressed: () async {
              log("i am sending audio");
              File fileFormat = File(path!);

              isSending = true;
              setState(() {});

              bool sent = await sendNudge.sendAudioNudge(
                question: widget.question,
                audioPath: fileFormat.path,
                order: widget.order,
                nudgeId: widget.nudgeId ?? -1,
              );

              if (sent) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              } else {
                int count = 1;
                while (!sent && count < 9) {
                  log("Sending nudge unsuccessful sent$count times sending again");
                  sent = await sendNudge.sendAudioNudge(
                    question: widget.question,
                    audioPath: fileFormat.path,
                    order: widget.order,
                    nudgeId: widget.nudgeId ?? -1,
                  );
                  count++;
                }

                if (sent) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sorry not able to send your nudge"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              }
            },
            icon: const Icon(Icons.check_sharp),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log(" prev text state -> $prevTextState recording completed -> $recordingCompleted");
    if (isSending) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (prevTextState == ContainerState.audio &&
        recordingCompleted == false) {
      return voiceRecording();
    } else if (prevTextState == ContainerState.audio && recordingCompleted) {
      return showRecording();
    } else if (prevTextState == ContainerState.empty) {
      return allThree();
    } else {
      return onlyText();
    }
  }
}
