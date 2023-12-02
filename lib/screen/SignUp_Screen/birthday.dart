import 'package:dating_app/Config/config.dart';
import 'package:dating_app/models/profile_creation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:dating_app/screen/screen.dart";
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Birthday extends StatefulWidget {
  final ProfileCreationModel profileObject;
  const Birthday({super.key, required this.profileObject});

  @override
  State<Birthday> createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  DateTime time = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
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
                        width: (MediaQuery.of(context).size.width / 7) * 2,
                        height: 5,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Text(
                    "When's your birthday?",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              CupertinoButton(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              "Day",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              "Month",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Text(
                            "Year",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 9.0, horizontal: 12.0),
                              margin: const EdgeInsets.only(right: 9.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              // width: 45.0,
                              height: 40.0,
                              child: Text(
                                time.day.toString().padLeft(2, '0'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 9.0, horizontal: 12.0),
                              margin: const EdgeInsets.only(right: 9.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              // width: 45.0,
                              height: 40.0,
                              child: Text(
                                time.month.toString().padLeft(2, '0'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 9.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              // width: 59.0,
                              height: 40.0,
                              child: Text(
                                time.year.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: ((BuildContext context) => SizedBox(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              backgroundColor: Colors.white,
                              initialDateTime: time,
                              dateOrder: DatePickerDateOrder.dmy,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  time = newTime;
                                });
                              },
                            ),
                          )),
                    );
                  }),
              Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                    child: SvgPicture.asset(
                      "assets/images/Lock.svg",
                      height: 14,
                      width: 14,
                    ),
                  ),
                  Container(
                    width: 250,
                    margin: const EdgeInsets.only(bottom: 33),
                    child: Text(
                      "We only show your age to potential matches, not your birthday.",
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
          ProfileCreationModel updatedProfileObject = widget.profileObject;
          updatedProfileObject.dateOfBirth =
              DateFormat('yyyy-MM-dd').format(time);

          nextScreen(context, Gender(profileObject: updatedProfileObject));
        },
        backgroundColor: Colors.white.withOpacity(0.5),
        child: const Icon(Icons.arrow_forward_ios_sharp),
      ),
    );
  }
}
