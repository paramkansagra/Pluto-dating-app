import 'package:dating_app/Config/config.dart';
import 'package:dating_app/models/profile_creation_model.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class Like extends StatefulWidget {
  final ProfileCreationModel profileObject;
  const Like({super.key, required this.profileObject});

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> {
  // final Color _FloatingButton = Colors.white;
  Color iconColor = Colors.white;
  // final GenderType _genderType = GenderType.male;
  List<bool> checkButtonValues = [false, false, false];
  bool _status = false;
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
                        width: (MediaQuery.of(context).size.width / 7) * 4,
                        height: 5,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Text(
                    "Who would you like to date?",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "You can choose more than one answer and change any time.",
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      FlutterSwitch(
                        inactiveColor: const Color(0xFF034B48).withOpacity(0.2),
                        activeColor: const Color(0xFF034B48),
                        value: _status,
                        onToggle: (val) {
                          setState(
                            () {
                              _status = !_status;
                              if (_status) {
                                checkButtonValues = [true, true, true];
                              } else {
                                checkButtonValues = [false, false, false];
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Text(
                        "I’m open to dating everyone",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CheckboxListTile(
                    tileColor: Colors.white,
                    activeColor: const Color(0xFF047E78),
                    checkColor: Colors.transparent,
                    checkboxShape: const CircleBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Text(
                      'Male',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    value: checkButtonValues[0],
                    onChanged: (value) {
                      setState(() {
                        checkButtonValues[0] = value!;
                        if (checkButtonValues[0] == true &&
                            checkButtonValues[1] == true &&
                            checkButtonValues[2] == true) {
                          _status = !_status;
                        } else {
                          _status = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    tileColor: Colors.white,
                    activeColor: const Color(0xFF047E78),
                    checkColor: Colors.transparent,
                    checkboxShape: const CircleBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Text(
                      'Female',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    value: checkButtonValues[1],
                    onChanged: (value) {
                      setState(() {
                        checkButtonValues[1] = value!;
                        if (checkButtonValues[0] == true &&
                            checkButtonValues[1] == true &&
                            checkButtonValues[2] == true) {
                          _status = !_status;
                        } else {
                          _status = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    tileColor: Colors.white,
                    activeColor: const Color(0xFF047E78),
                    checkColor: Colors.transparent,
                    checkboxShape: const CircleBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Text(
                      'Non Binary',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    value: checkButtonValues[2],
                    onChanged: (value) {
                      setState(() {
                        checkButtonValues[2] = value!;
                        if (checkButtonValues[0] == true &&
                            checkButtonValues[1] == true &&
                            checkButtonValues[2] == true) {
                          _status = !_status;
                        } else {
                          _status = false;
                        }
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
                      "You’ll only be shown to people looking to date your gender.",
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
          nextScreen(context, Hope(profileObject: widget.profileObject));
        },
        backgroundColor: Colors.white.withOpacity(0.5),
        child: Icon(
          Icons.arrow_forward_ios_sharp,
          color: iconColor,
        ),
      ),
    );
  }
}
