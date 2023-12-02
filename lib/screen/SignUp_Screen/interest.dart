import 'dart:developer';

import 'package:dating_app/Config/config.dart';
import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/material.dart';
import '../../Widgets/widget.dart';

class Interest extends StatefulWidget {
  final bool editScreenChecker;
  const Interest({super.key, this.editScreenChecker = false});

  @override
  State<Interest> createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  List<List<dynamic>> interests = [];
  bool isLoading = true;
  final List<String> selectedInterests = [];
  late Map<String, dynamic> answer;
  Map<String, List<String>> selectedInterest = {};

  String interestUrl = "https://firstpluto.com/interests";
  String saveInterestUrl = "https://firstpluto.com/user/interests";

  @override
  void initState() {
    super.initState();
    ProfileApi().fetchInterestList().then((responseMap) {
      setState(() {
        answer = responseMap;
        isLoading = false;
        for (var key in answer.keys) {
          interests = [...interests, answer[key]];
        }
      });
    }).catchError((error) {
      log('Error fetching interests: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.editScreenChecker
                    ? const SizedBox()
                    : Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF034B48),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: (MediaQuery.of(context).size.width / 7) * 6,
                            height: 5,
                          )
                        ],
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 19,
                    ),
                    Text(
                      "Your interests",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Pick up to 5 things you love. it’ll help you match with people who love them too.",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isLoading
                        ? Container(
                            height: MediaQuery.of(context).size.height - 250,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List<Widget>.generate(answer.keys.length,
                                (index) {
                              String key = answer.keys.elementAt(index);
                              List<dynamic> interests = answer[key] ?? [];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    key
                                        .replaceAll("_", " ")
                                        .split(" ")
                                        .map((word) => word.isNotEmpty
                                            ? "${word[0].toUpperCase()}${word.substring(1)}"
                                            : "")
                                        .join(" "),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Wrap(
                                    spacing: 8.0,
                                    children: interests.map((interest) {
                                      bool isSelected = selectedInterests
                                          .contains(interest["interest_value"]);
                                      return ChoiceChip(
                                        avatar: Text(
                                          interest["emoticon"],
                                        ),
                                        selectedColor: const Color(0XFF034B48),
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                                fontSize: 14,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black),
                                        backgroundColor: Colors.white,
                                        label: Text(
                                          interest["interest_value"],
                                          textAlign: TextAlign.center,
                                        ),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected &&
                                                selectedInterests.length < 5) {
                                              if (selectedInterest
                                                  .containsKey(key)) {
                                                selectedInterest[key]!.add(
                                                    interest["interest_value"]);
                                              } else {
                                                selectedInterest[key] = [
                                                  interest["interest_value"]
                                                ];
                                              }

                                              selectedInterests.add(
                                                  interest["interest_value"]);
                                            } else if (!selected &&
                                                selectedInterest[key]!.contains(
                                                    interest[
                                                        "interest_value"])) {
                                              selectedInterest[key]!.remove(
                                                  interest["interest_value"]);
                                              selectedInterests.remove(
                                                  interest["interest_value"]);
                                            } else if (selected &&
                                                selectedInterests.length >= 5) {
                                              customSnackBar(
                                                  text:
                                                      "You can select upto 5 interests.",
                                                  context: context);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                ],
                              );
                            }),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ProfileApi().postInterest(selectedInterest);

          widget.editScreenChecker
              ? nextScreen(context, const EditProfile())
              : nextScreen(context, const ImageUploading());
        },
        backgroundColor: Colors.white.withOpacity(0.5),
        child: const Icon(
          Icons.arrow_forward_ios_sharp,
        ),
      ),
    );
  }
}
