import 'package:dating_app/Config/config.dart';
import 'package:dating_app/Widgets/widget.dart';
import 'package:dating_app/models/profile_creation_model.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/material.dart';

class Gender extends StatefulWidget {
  final ProfileCreationModel profileObject;
  const Gender({super.key, required this.profileObject});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String gender = "male";
  late GenderType _genderType = GenderType.male;
  Color _floatingButton = Colors.white.withOpacity(0.5);
  Color iconColor = const Color(0xFFFFFFFF);
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
                        width: MediaQuery.of(context).size.width / 7 * 3,
                        height: 5,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Text(
                    "What’s your gender?",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Pick which best describes you. Then add more about your gender if you’d like. Learn what this means",
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Column(
                children: [
                  CustomRadioButton(
                    title: "Male",
                    groupValue: _genderType,
                    value: GenderType.male,
                    onChanged: (value) {
                      setState(() {
                        _floatingButton = Colors.white;
                        iconColor = Colors.black;
                        _genderType = value!;
                        gender = "male";
                      });
                    },
                  ),
                  CustomRadioButton(
                    title: "Female",
                    groupValue: _genderType,
                    value: GenderType.female,
                    onChanged: (value) {
                      setState(() {
                        iconColor = Colors.black;
                        _floatingButton = Colors.white;
                        _genderType = value!;
                        gender = "female";
                      });
                    },
                  ),
                  CustomRadioButton(
                    title: "Binary",
                    groupValue: _genderType,
                    value: GenderType.nonBinary,
                    onChanged: (value) {
                      setState(() {
                        iconColor = Colors.black;
                        _floatingButton = Colors.white;
                        _genderType = value!;
                        gender = "binary";
                      });
                    },
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
                      "You can always update this later. We got you.",
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
        onPressed: () {
          ProfileCreationModel updatedProfile = widget.profileObject;
          updatedProfile.gender = gender;

          nextScreen(context, Like(profileObject: updatedProfile));
        },
        backgroundColor: _floatingButton,
        child: Icon(
          Icons.arrow_forward_ios_sharp,
          color: iconColor,
        ),
      ),
    );
  }
}
