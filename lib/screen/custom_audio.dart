import "package:audio_waveforms/audio_waveforms.dart";
import "package:flutter/material.dart";

class AudioForm extends StatefulWidget {
  const AudioForm({super.key});

  @override
  State<AudioForm> createState() => _AudioFormState();
}

class _AudioFormState extends State<AudioForm> {
  // late final RecorderController recorderController;
  // void _initialiseController() {
  //   recorderController = RecorderController()
  //     ..androidEncoder = AndroidEncoder.aac
  //     ..androidOutputFormat = AndroidOutputFormat.mpeg4
  //     ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
  //     ..sampleRate = 16000;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _initialiseController();
  // }

  // void _startRecording() async {
  //   await recorderController.record();

  // AudioWaveforms(
  //   recorderController: recorderController,
  //   enableGesture: true,
  //   size: ,
  //   waveStyle: const WaveStyle(
  //     waveColor: Colors.white,
  //     extendWaveform: true,
  //     showMiddleLine: false,
  //   ),
  //   decoration: BoxDecoration(
  //     borderRadius: BorderRadius.circular(12.0),
  //     color: const Color(0xFF1E1B26),
  //   ),
  //   padding: const EdgeInsets.only(left: 18),
  //   margin: const EdgeInsets.symmetric(horizontal: 15),
  // );

  //   // update state here to, for eample, change the button's state
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //         child: Column(
  //       children: [
  //         const Text(
  //           "GG",
  //           style: TextStyle(color: Colors.amber),
  //         ),
  //         IconButton(
  //             icon: Icon(Icons.mic),
  //             tooltip: 'Start recording',
  //             onPressed: _startRecording)
  //       ],
  //     )),
  //   );
  // }

  RecorderController _recordController = RecorderController();

  void _initialiseController() {
    _recordController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  @override
  void initState() {
    super.initState();
    // _recordController.(sampleRate: 44100, encoder: AudioEncoder.AAC);
    _initialiseController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Waveforms Example'),
      ),
      body: Center(
        child: AudioWaveforms(
          recorderController: _recordController,
          enableGesture: true,
          size: Size(MediaQuery.of(context).size.width, 100),
          waveStyle: const WaveStyle(
            waveColor: Colors.white,
            extendWaveform: true,
            showMiddleLine: false,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF1E1B26),
          ),
          padding: const EdgeInsets.only(left: 18),
          margin: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_recordController.isRecording) {
            _recordController.stop();
          } else {
            _recordController.record();
          }
        },
        child: Icon(_recordController.isRecording ? Icons.stop : Icons.mic),
      ),
    );
  }

  @override
  void dispose() {
    _recordController.dispose();
    super.dispose();
  }
}
