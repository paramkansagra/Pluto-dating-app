import 'dart:convert';
import 'dart:developer';

import 'package:dating_app/Config/config.dart';
import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/material.dart';

import '../../models/profile_creation_model.dart';

enum InterestType { relationship, casual, notSure, notSay }

class Hope extends StatefulWidget {
  final ProfileCreationModel profileObject;
  const Hope({super.key, required this.profileObject});

  @override
  State<Hope> createState() => _HopeState();
}

class _HopeState extends State<Hope> {
  List<String> hopeOptions = [
    "relationship",
    "marriage",
    "casual",
    "NotKnownYet"
  ];
  String hope = "relationship";

  // final Color _FloatingButton = Colors.white;
  Color iconColor = Colors.white;
  InterestType groupValue = InterestType.relationship;
  InterestType value = InterestType.relationship;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
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
                        width: (MediaQuery.of(context).size.width / 7) * 5,
                        height: 5,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Text(
                    "What are you hoping to find?",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Honestly help you and everyone o Pluto find what you’re looking for.",
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Column(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      title: Text(
                        "A relationship",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 14),
                      ),
                      trailing: Radio<InterestType>(
                        activeColor: const Color(0xFF047E78),
                        value: InterestType.relationship,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                            hope = hopeOptions[0];
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      title: Text(
                        "Something Casual",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 14),
                      ),
                      trailing: Radio<InterestType>(
                        activeColor: const Color(0xFF047E78),
                        value: InterestType.casual,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                            hope = hopeOptions[2];
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      title: Text(
                        "Marriage",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 14),
                      ),
                      trailing: Radio<InterestType>(
                        activeColor: const Color(0xFF047E78),
                        value: InterestType.notSure,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                            hope = hopeOptions[1];
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      title: Text(
                        "I'm not sure yet",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 14),
                      ),
                      trailing: Radio<InterestType>(
                        activeColor: const Color(0xFF047E78),
                        value: InterestType.notSay,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                            hope = hopeOptions[3];
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                    child: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  Container(
                    width: 244,
                    margin: const EdgeInsets.only(bottom: 33),
                    child: Text(
                      "This will show on your profile unless you’re sure",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ProfileCreationModel updatedProfile = widget.profileObject;
          updatedProfile.lookingFor = hope;

          log(jsonEncode(updatedProfile.toJson()).toString());
          final profileResponce = await ProfileApi().fetchProfile();
          log("profile responce error -> ${profileResponce.error}");
          if (profileResponce.error == true) {
            ProfileApi().createProfile();
          }

          ProfileApi().updateProfileFirstTime(updatedProfile);

          // ignore: use_build_context_synchronously
          nextScreen(context, const Interest());
        },
        backgroundColor: Colors.white.withOpacity(0.5),
        child: const Icon(Icons.arrow_forward_ios_sharp),
      ),
    );
  }
}
