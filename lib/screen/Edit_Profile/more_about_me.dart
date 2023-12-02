import 'dart:developer';

import 'package:dating_app/models/profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreAboutMe extends StatefulWidget {
  final ProfileModel profileModel;
  final int optionIndex;
  final Map<String, dynamic> optionResponse;
  const MoreAboutMe(
      {Key? key,
      required this.optionIndex,
      required this.profileModel,
      required this.optionResponse})
      : super(key: key);

  @override
  State<MoreAboutMe> createState() => MoreAboutMeState();
}

class MoreAboutMeState extends State<MoreAboutMe> {
  // Capitalize only staring word
  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  // Capitalize first word of sentence
  String capitalizeWords(String input) {
    if (input.isEmpty) {
      return input;
    }

    List<String> words = input.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1)}';
      } else {
        return '';
      }
    }).toList();

    return capitalizedWords.join(' ');
  }

  late Map<String, dynamic> optionResponse = widget.optionResponse;
  late Map<String, dynamic> profileModelResponse =
      Map.from(widget.profileModel.toJson());

  late FixedExtentScrollController scrollController =
      FixedExtentScrollController(
          initialItem: (int.parse(selectedHeight ?? "160") - 90));
  // Initial selected height index
  List<String> heightOptions =
      List.generate(131, (index) => (index + 90).toString());
  // Height options from 90 to 220 cm
  String? selectedHeight;

  List<List<dynamic>> heading = [
    [
      const Icon(
        Icons.sports_gymnastics_outlined,
        size: 40,
      ),
      "Do you work out?",
      "exercise"
    ],
    [
      const Icon(
        Icons.school_outlined,
        size: 40,
      ),
      "What's your education?",
      "education_level"
    ],
    [
      const Icon(
        Icons.wine_bar_outlined,
        size: 40,
      ),
      "Do you drink?",
      "drink"
    ],
    [
      const Icon(
        Icons.smoking_rooms_outlined,
        size: 40,
      ),
      "Do you smoke?",
      "smoke"
    ],
    [
      const Icon(
        Icons.search,
        size: 40,
      ),
      "What do you want from your dates?",
      "looking_for"
    ],
    [
      const Icon(
        Icons.man_2_outlined,
        size: 40,
      ),
      "What are your ideal plan for children?",
      "child"
    ],
    [
      const Icon(
        Icons.sign_language,
        size: 40,
      ),
      "What's your zodiac sign?",
      "zodiac_sign"
    ],
    [
      const Icon(
        Icons.policy_outlined,
        size: 40,
      ),
      "What are your political learning?",
      "politics"
    ],
    [
      const Icon(
        Icons.handshake,
        size: 40,
      ),
      "Do you identify with a religion?",
      "religion"
    ]
  ];

  List<List<String>> options = [];

  @override
  void initState() {
    super.initState();
    options = [
      [...optionResponse["exercise"], "skip"],
      [...optionResponse["education"], "skip"],
      [...optionResponse["drink"], "skip"],
      [...optionResponse["smoke"], "skip"],
      [...optionResponse["looking_for"], "skip"],
      [...optionResponse["children"], "skip"],
      [...optionResponse["star_sign"], "skip"],
      [...optionResponse["politics_likes"], "skip"],
      [...optionResponse["religion"], "skip"]
    ];
    log(profileModelResponse.toString());
    log(options.toString());
    selectedHeight = profileModelResponse["height"].toString();

    // log(
    //     "Hello  ${options[widget.optionIndex].indexOf(capitalize(profileModelResponse[heading[widget.optionIndex][2]]))}");
  }

  late int selectedIndex =
      profileModelResponse[heading[widget.optionIndex][2]] != null
          ? options[widget.optionIndex].indexOf(
              capitalize(profileModelResponse[heading[widget.optionIndex][2]]))
          : -1;
  // late int selectedIndex = int.parse(options[widget.optionIndex][
  //     options[widget.optionIndex].indexOf(
  //         capitalize(profileModelResponse[heading[widget.optionIndex][2]]))]);

  @override
  Widget build(BuildContext context) {
    return widget.optionIndex != -1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: heading[widget.optionIndex][0],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      heading[widget.optionIndex][1],
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                wordSpacing: 1.25,
                              ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: options[widget.optionIndex].length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedIndex = index;
                        if (selectedIndex ==
                            options[widget.optionIndex].length - 1) {
                          Navigator.of(context).pop();
                        } else {
                          if (heading[widget.optionIndex][2] ==
                              "education_level") {
                            profileModelResponse["education"]
                                    ["education_level"] =
                                options[widget.optionIndex][index]
                                    .toLowerCase();
                            Navigator.of(context).pop(profileModelResponse);
                          } else {
                            profileModelResponse[heading[widget.optionIndex]
                                [2]] = options[widget.optionIndex]
                                    [index]
                                .toLowerCase();

                            Navigator.of(context).pop(profileModelResponse);
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              index != options[widget.optionIndex].length - 1
                                  ? Border.all(
                                      color: selectedIndex == index
                                          ? Theme.of(context)
                                              .scaffoldBackgroundColor
                                          : Colors.black,
                                      width: selectedIndex == index ? 2 : 0.25,
                                    )
                                  : const Border(),
                        ),
                        child: ListTile(
                          title: Text(
                            options[widget.optionIndex][index],
                            style:
                                index != options[widget.optionIndex].length - 1
                                    ? Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: Colors.black,
                                        )
                                    : Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: const Color(0XFF525252),
                                        ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Icon(Icons.man_3_outlined),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            "What's your height",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  wordSpacing: 1.25,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.25, color: Colors.black)),
                      child: ListTile(
                        title: Text(
                          "$selectedHeight cm",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: CupertinoPicker(
                        scrollController: scrollController,
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHeight = heightOptions[index];
                            profileModelResponse["height"] =
                                int.parse(selectedHeight!);
                          });
                        },
                        children: heightOptions.map((height) {
                          return Center(
                            child: Text(
                              '$height cm',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 20, 40),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () {
                        Navigator.of(context).pop(profileModelResponse);
                      },
                      child: const Text(
                        "Save",
                        textAlign: TextAlign.center,
                      )),
                )
              ]);
  }
}
