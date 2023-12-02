import 'dart:developer';

import 'package:dating_app/Config/current_location.dart';
import 'package:dating_app/api/event_api.dart';
import 'package:dating_app/models/view_event_model.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:location/location.dart';

import '../../Config/config.dart';
import '../../models/event_model.dart';
import '../seearch_location.dart';

class AddEvent extends StatefulWidget {
  final Data? updateModel;
  const AddEvent(this.updateModel, {super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  EventModel eventModel = EventModel();
  String? selectedEventType;
  String? eventAttendes;
  String? deadline;
  final eventType = [
    "Cafe outing",
    "Adventure",
    "Fitness",
    "Clubbing",
    "Drinks",
    "Shopping",
    "Some other"
  ];
  final attendes = ['Just You', "Friends", "Colleagues"];

  final responseDeadline = ["After 12 hours", "After 24 hours", "After 2 days"];

  List<String> whoAttending = ["Just you", "Friends", "Colleagues"];
  TimeOfDay? pickedTime;
  TextEditingController datevalue = TextEditingController();
  TextEditingController timevalue = TextEditingController();
  TextEditingController eventLocation = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  // ignore: unused_field
  late LocationData _currentPosition;
  final _formKey = GlobalKey<FormState>();

  gettingLocation() async {
    _currentPosition = await FetchLocation().fetchLocation();
  }

  @override
  void initState() {
    super.initState();

    gettingLocation();
    if (widget.updateModel != null) {
      log(widget.updateModel!.toJson().toString());
      datevalue.text = widget.updateModel!.dateTime!.substring(0, 10);
      timevalue.text = widget.updateModel!.dateTime!.substring(11, 16);
      selectedEventType = widget.updateModel!.type;
      eventDescription.text = widget.updateModel!.description!;
      eventAttendes = widget.updateModel!.attendees!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    datevalue.dispose();
    timevalue.dispose();
    eventLocation.dispose();
    eventDescription.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Add an event",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.black,
                wordSpacing: 1.2,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 53, bottom: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter event date";
                          } else {
                            return null;
                          }
                        },
                        controller: datevalue,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "YYYY/MM/DD",
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 1));

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy/MM/dd').format(pickedDate);

                            setState(() {
                              datevalue.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Text(
                      "Time",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter event time";
                          } else {
                            return null;
                          }
                        },
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                        controller: timevalue,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "HH:MM AM",
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                        ),
                        readOnly: true,
                        onTap: () async {
                          pickedTime = await showTimePicker(
                            context: context,
                            initialTime: pickedTime ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              timevalue.text =
                                  '${pickedTime!.hour.toString().padLeft(2, '0')}:${pickedTime!.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Text(
                      "Location",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TextFormField(
                        onTap: () {
                          nextScreen(context, const SearchLocationScreen());
                        },
                        readOnly: true,
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter event location";
                          } else {
                            return null;
                          }
                        },
                        controller: eventLocation,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "Event place",
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Text(
                      "Event Type",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    dropDownButton(
                      context: context,
                      dropDownList: eventType,
                      value: selectedEventType,
                      hintText: "Adventure, going out, shopping",
                      onChanged: (newValue) {
                        setState(() {
                          selectedEventType = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Text(
                      "Add event description",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TextFormField(
                        maxLines: null,
                        controller: eventDescription,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid date';
                          }
                          List<String> words = value.trim().split(' ');

                          if (words.length < 30) {
                            return 'Please enter at least 30 words';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Min. 30 words",
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Text(
                      "Who all will be attending",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    dropDownButton(
                      context: context,
                      dropDownList: attendes,
                      hintText: "Just you, friends, colleagues",
                      value: eventAttendes,
                      onChanged: (newValue) {
                        setState(() {
                          eventAttendes = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Text(
                      "Event response deadline",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
                    dropDownButton(
                      context: context,
                      dropDownList: responseDeadline,
                      value: deadline,
                      hintText: "After 12 hours, After 24 hours, After 2 day",
                      onChanged: (newValue) {
                        setState(() {
                          deadline = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String endResponse = "";
                        String originalDateTimeString =
                            "${datevalue.text} ${timevalue.text}";
                        DateTime originalDateTime =
                            DateFormat('yyyy/MM/dd HH:mm')
                                .parse(originalDateTimeString);
                        DateTime moonLanding = DateTime.utc(
                            originalDateTime.year,
                            originalDateTime.month,
                            originalDateTime.day,
                            originalDateTime.hour,
                            originalDateTime.minute,
                            originalDateTime.second);
                        String formatedDateTime = moonLanding.toIso8601String();

                        formatedDateTime =
                            "${formatedDateTime.substring(0, formatedDateTime.length - 5)}Z";

                        // eventModel.location.city = eventLocation.text;
                        endResponse = DateTime.now()
                            .add(Duration(
                                hours: int.parse(deadline!.substring(6, 8))))
                            .toIso8601String();

                        // if (deadline!.substring(6, 8) == "12") {
                        //   endResponse = DateTime.now()
                        //       .add(const Duration(hours: 12))
                        //       .toIso8601String();
                        // eventModel.expiresAt =
                        //     "${endResponse.substring(0, endResponse.length - 7)}Z";
                        // } else if (deadline!.substring(6, 8) == "24") {
                        //   endResponse = DateTime.now()
                        //       .add(const Duration(hours: 24))
                        //       .toIso8601String();
                        //   eventModel.expiresAt =
                        //       "${endResponse.substring(0, endResponse.length - 7)}Z";
                        // } else if (deadline!.substring(6, 8) == "2 ") {
                        //   endResponse = DateTime.now()
                        //       .add(const Duration(hours: 48))
                        //       .toIso8601String();
                        //   eventModel.expiresAt =
                        //       "${endResponse.substring(0, endResponse.length - 7)}Z";
                        // }

                        if (widget.updateModel == null) {
                          eventModel.dateTime = formatedDateTime;
                          eventModel.description = eventDescription.text;
                          eventModel.attendee = eventAttendes;
                          eventModel.type = selectedEventType;
                          eventModel.expiresAt =
                              "${endResponse.substring(0, endResponse.length - 7)}Z";
                        } else {
                          widget.updateModel!.dateTime = formatedDateTime;
                          widget.updateModel!.description =
                              eventDescription.text;
                          widget.updateModel!.attendees = eventAttendes;
                          widget.updateModel!.type = selectedEventType;
                          widget.updateModel!.expiresAt =
                              "${endResponse.substring(0, endResponse.length - 7)}Z";
                        }

                        widget.updateModel == null
                            ? EventApi().createEvent(eventModel)
                            : EventApi().updateEvent(widget.updateModel!);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          behavior: SnackBarBehavior.floating,
                          content: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Event Added",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              fontSize: 16,
                                              wordSpacing: 1.25,
                                            ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  "we will notify you when people show interest in your event.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          fontSize: 14, wordSpacing: 1.25),
                                ),
                              ],
                            ),
                          ),
                          margin: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ));
                        // Navigator.of(context).pop();
                        // _formKey.currentState.
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.all(12),
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white)),
                    child: const Text(
                      "Submit",
                      textAlign: TextAlign.center,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container dropDownButton({
    required BuildContext context,
    required List dropDownList,
    required String hintText,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        onTap: () {
          onChanged(value);
        },
        validator: (value) {
          if (value == null) {
            return "Please specify the details";
          }
          return null;
        },
        dropdownColor: Colors.white,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black),
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(8.0),
          border: InputBorder.none,
        ),
        hint: Text(hintText,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  overflow: TextOverflow.ellipsis,
                )),
        value: value,
        onChanged: onChanged,
        items: dropDownList.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
      ),
    );
  }
}
