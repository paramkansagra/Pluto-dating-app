import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:dating_app/api/download_nudge_api.dart';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dating_app/Config/config.dart';
import 'package:dating_app/api/like_dislike_api.dart';
import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/models/user_media_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:video_player/video_player.dart';
import '../models/prompt_answer_model.dart';
import 'custom_choice_button.dart';

class ProfileCardWidget extends StatefulWidget {
  final ProfileModel profileData;
  final String city;
  final int check;
  final List<String> interestElement;
  final Map<String, String> interestEmoticons;
  final PromptAnswerModel promptAnswerModel;
  final UserMediaModel userMediaModel;

  const ProfileCardWidget({
    super.key,
    required this.city,
    required this.check,
    required this.userMediaModel,
    required this.profileData,
    required this.interestElement,
    required this.interestEmoticons,
    required this.promptAnswerModel,
  });

  @override
  State<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {
  double headAndSubheadDist = 12;
  double iconAndTextDist = 6;
  // not used any where
  Future<String> getCityName(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    return placemarks[0].name!;
  }

  List<dynamic> getNonNullProperties(ProfileModel profileData) {
    final List<dynamic> nonNullProperties = [];
    if (profileData.data != null) {
      dynamic data = profileData.data!;
      if (data.occupation != null) {
        nonNullProperties.add(data.occupation!);
      }
      if (data.drink != null) {
        nonNullProperties.add(data.drink!);
      }
      if (data.smoke != null) {
        nonNullProperties.add(data.smoke!);
      }
      if (data.exercise != null) {
        nonNullProperties.add(data.exercise!);
      }
      if (data.lookingFor != null) {
        nonNullProperties.add(data.lookingFor!);
      }
      if (data.weight != null) {
        nonNullProperties.add("${data.weight!} kg");
      }
      if (data.height != null) {
        nonNullProperties.add("${data.height!}cm");
      }
      if (data.educationLevel != null) {
        nonNullProperties.add(data.educationLevel!);
      }
      if (data.religion != null) {
        nonNullProperties.add(data.religion!);
      }
    }
    return nonNullProperties;
  }

  Stack imageAndText(
      BuildContext context, String text, /*File imageFile*/ String url) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 18.0),
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                  image: NetworkImage(url),
                  // FileImage(imageFile),
                  fit: BoxFit.fill)),
        ),
        (text.isNotEmpty)
            ? Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.5)),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 14, letterSpacing: 1.2, wordSpacing: 1.2),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  @override
  void dispose() {
    dev.log("parent the widget");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.76,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      image: DecorationImage(
                          //change down
                          image:
                              // FileImage(firstImage!),
                              NetworkImage(widget.userMediaModel.data!
                                      .elementAt(0)
                                      .url ??
                                  ""),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  bottom: 10,
                  left: 26,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.profileData.data?.firstName ?? "Undefined"},${widget.profileData.data!.age ?? "20"}",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                        ),

                        // Hard Coding pronounce
                        Wrap(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: iconAndTextDist,
                            ),
                            const Text("he/him")
                          ],
                        ),
                        widget.profileData.data!.occupation != null
                            ? Wrap(
                                children: [
                                  const Icon(
                                    Icons.work_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: iconAndTextDist,
                                  ),
                                  Text(
                                      widget.profileData.data!.occupation ?? "")
                                ],
                              )
                            : const SizedBox(),

                        widget.profileData.data!.college != null
                            ? Wrap(
                                children: [
                                  const Icon(
                                    Icons.school_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: iconAndTextDist,
                                  ),
                                  Text(widget.profileData.data!.college!)
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 18,
                    right: 18,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        "assets/images/icons/share.svg",
                        height: 24,
                        width: 24,
                      ),
                      onPressed: () {},
                    ))
              ],
            ),
            (widget.profileData.data != null &&
                    widget.profileData.data!.about != null)
                ? ListTile(
                    minLeadingWidth: 0,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Text(
                        "Intro",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: headAndSubheadDist),
                      child: Text(widget.profileData.data!.about!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.black)),
                    ),
                  )
                : const SizedBox(),
            getNonNullProperties(widget.profileData).isNotEmpty
                ? Wrap(
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text(
                            "Basics",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(headAndSubheadDist),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                              getNonNullProperties(widget.profileData).length,
                              (index) {
                            return customChoiceButton(
                              (getNonNullProperties(widget.profileData))[index]
                                  .toString(),
                              Theme.of(context).scaffoldBackgroundColor,
                              Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                            );
                          }),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            widget.interestElement.isNotEmpty
                ? Wrap(
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text(
                            "Interest",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(headAndSubheadDist),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List<Widget>.generate(
                            widget.interestElement.length,
                            (index) => customChoiceButton(
                              widget.interestElement[index],
                              Theme.of(context).scaffoldBackgroundColor,
                              Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.white, fontSize: 12),
                              emoji: widget.interestEmoticons[
                                  widget.interestElement[index]]!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            Wrap(
              direction: Axis.vertical,
              children: List.generate(
                max(widget.userMediaModel.data!.length - 1,
                    widget.promptAnswerModel.data?.length ?? 0),
                (index) {
                  return Wrap(
                    direction: Axis.vertical,
                    children: [
                      index < widget.userMediaModel.data!.length
                          ? imageAndText(
                              context,
                              widget.userMediaModel.data!
                                  .elementAt(index + 1)
                                  .imageText!,
                              widget.userMediaModel.data!
                                  .elementAt(index + 1)
                                  .url!)
                          : const SizedBox(),
                      index < widget.promptAnswerModel.data!.length
                          ? UserPrompt(
                              promptAnswerModel: widget.promptAnswerModel,
                              index: index,
                            )
                          : const SizedBox()
                    ],
                  );
                },
              ),
            ),
            widget.check == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(6),
                          onPressed: () async {
                            bool responce =
                                await LikeDislikeApi().likedDisliked(
                              likeeId: ApiData().userId,
                              liked: true,
                            );
                            if (responce == true) {
                              dev.log("Like sent successful");
                            } else {
                              int count = 1;
                              bool sent = false;
                              while (count < 9) {
                                bool responce =
                                    await LikeDislikeApi().likedDisliked(
                                  likeeId: ApiData().userId,
                                  liked: true,
                                );
                                if (responce == false) {
                                  count++;
                                } else {
                                  sent = true;
                                  break;
                                }
                              }
                              if (sent) {
                                dev.log("Like sent successful");
                              } else {
                                dev.log("Like send uncessful");
                              }
                            }
                          },
                          icon:
                              SvgPicture.asset("assets/images/icons/heart.svg"),
                          iconSize: 33.33,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: IconButton(
                          color: Colors.white,
                          padding: const EdgeInsets.all(6),
                          onPressed: () async {
                            bool responce =
                                await LikeDislikeApi().likedDisliked(
                              likeeId: ApiData().userId,
                              liked: false,
                            );
                            if (responce == true) {
                              dev.log("Dislike sent successful");
                            } else {
                              int count = 1;
                              bool sent = false;
                              while (count < 9) {
                                bool responce =
                                    await LikeDislikeApi().likedDisliked(
                                  likeeId: ApiData().userId,
                                  liked: false,
                                );
                                if (responce == false) {
                                  count++;
                                } else {
                                  sent = true;
                                  break;
                                }
                              }
                              if (sent) {
                                dev.log("Dislike sent successful");
                              } else {
                                dev.log("Dislike send uncessful");
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          iconSize: 33.33,
                        ),
                      )
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class UserPrompt extends StatefulWidget {
  final int index;

  const UserPrompt({
    super.key,
    required this.index,
    required this.promptAnswerModel,
  });

  final PromptAnswerModel promptAnswerModel;

  @override
  State<UserPrompt> createState() => _UserPromptState();
}

class _UserPromptState extends State<UserPrompt> {
  PlayerController? _playerController; // init the player controller
  VideoPlayerController? _videoPlayerController;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.promptAnswerModel.data![widget.index].type == "audio") {
      _playerController = PlayerController();
    }
  }

  @override
  void dispose() {
    dev.log("i am disposing off the controllers");
    dev.log("is player controller null ? ${_playerController == null}");
    dev.log("is video controller null ? ${_videoPlayerController == null}");

    if (_playerController != null) _playerController!.dispose();
    if (_videoPlayerController != null) _videoPlayerController!.dispose();
    super.dispose();
  }

  Future<bool> downloadAndInitAudioPlayer() async {
    final filePath = await DefaultCacheManager().getSingleFile(
      widget.promptAnswerModel.data![widget.index].mediaUrl!,
    );
    dev.log(widget.promptAnswerModel.data![widget.index].question!);
    await _playerController!.preparePlayer(path: filePath.path);
    return true;
  }

  Stream<bool> _initVideoPlayer() async* {
    dev.log("init the controller start");

    yield false;

    final downloadPath = await DownloadNudgeApi()
        .downloadNudge(widget.promptAnswerModel, widget.index);

    _videoPlayerController = VideoPlayerController.file(File(downloadPath));
    dev.log("video controller init");
    await _videoPlayerController!.initialize();
    dev.log("init the controller end");
    await _videoPlayerController!.setLooping(true);

    yield true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.promptAnswerModel.data![widget.index].question ?? "",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.black,
                  ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            widget.promptAnswerModel.data![widget.index].type == "text"
                ? Text(
                    widget.promptAnswerModel.data![widget.index].answer,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  )
                : widget.promptAnswerModel.data![widget.index].type == "audio"
                    ? FutureBuilder(
                        future: downloadAndInitAudioPlayer(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator.adaptive();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // center the main axis of column
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // center the cross axis of column
                              children: [
                                Expanded(
                                  child: AudioFileWaveforms(
                                    // showing the wave from
                                    size: Size(
                                        MediaQuery.of(context).size.width,
                                        100.0), // size of the waveform
                                    playerController:
                                        _playerController!, // controller controlling the player
                                    enableSeekGesture: true, // enable seeking
                                    waveformType:
                                        WaveformType.long, // long waveform
                                    playerWaveStyle: const PlayerWaveStyle(
                                      // have blue accents and white wave
                                      fixedWaveColor: Colors.black,
                                      liveWaveColor: Colors.blueAccent,
                                      spacing: 6,
                                      showBottom: false,
                                      showSeekLine: false,
                                    ),
                                  ),
                                ),
                                // making an icon button to play the audio
                                StreamBuilder(
                                  // stream builder to show the current state
                                  stream: _playerController!
                                      .onCurrentDurationChanged,
                                  builder: (context, snapshot) {
                                    dev.log(
                                        "player controller connection state -> ${snapshot.connectionState}");
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text(
                                        "00:00",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.black,
                                            ),
                                      );
                                    } else {
                                      Duration durationCompleted = Duration(
                                          milliseconds: snapshot.data!);
                                      final mm =
                                          (durationCompleted.inMinutes % 60)
                                              .toString()
                                              .padLeft(2, '0');
                                      final ss =
                                          (durationCompleted.inSeconds % 60)
                                              .toString()
                                              .padLeft(2, '0');
                                      return Text(
                                        "$mm:$ss",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.black,
                                            ),
                                      );
                                    }
                                  },
                                ),
                                // making an icon button to play the audio
                                StreamBuilder(
                                  stream:
                                      _playerController!.onPlayerStateChanged,
                                  builder: ((context, snapshot) {
                                    dev.log(
                                        "player controller data -> ${snapshot.data.toString()}");
                                    if (snapshot.data == PlayerState.playing) {
                                      return IconButton(
                                        onPressed: () {
                                          dev.log("paused");
                                          _playerController!.pausePlayer();
                                        },
                                        icon: const Icon(Icons.pause_sharp),
                                      );
                                    } else {
                                      return IconButton(
                                        onPressed: () {
                                          _playerController!.startPlayer(
                                            finishMode: FinishMode.loop,
                                          );
                                        },
                                        icon: const Icon(Icons.play_arrow),
                                      );
                                    }
                                  }),
                                ),
                                const SizedBox(width: 10),
                              ],
                            );
                          }
                        }),
                      )
                    : StreamBuilder(
                        stream: _initVideoPlayer(),
                        builder: (context, state) {
                          if (state.connectionState != ConnectionState.done &&
                              state.data != true) {
                            dev.log("video is waiting");
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            dev.log("video done");
                            // aspect ratio => width / height
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: () async {
                                  dev.log("i am tapping");
                                  if (!isPlaying) {
                                    dev.log("start playing");
                                    isPlaying = true;
                                    await _videoPlayerController!.play();
                                  } else {
                                    dev.log("stop playing");
                                    isPlaying = false;
                                    await _videoPlayerController!.pause();
                                  }
                                },
                                child: AspectRatio(
                                    aspectRatio: _videoPlayerController!
                                        .value.aspectRatio,
                                    child:
                                        VideoPlayer(_videoPlayerController!)),
                              ),
                            );
                          }
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
