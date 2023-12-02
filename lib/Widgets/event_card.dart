import 'package:dating_app/Config/config.dart';
import 'package:dating_app/models/view_event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screen/Event/add_event.dart';

class EventCard extends StatelessWidget {
  final Data eventModel;
  final int eventId;

  const EventCard({
    super.key,
    required this.eventId,
    required this.eventModel,
  });

  convertToDate(String value) {
    DateTime dateTime = DateTime.parse(value);
    String formattedDate = DateFormat.yMMMMd().format(dateTime);
    return formattedDate;
  }

  convertToTime(String value) {
    DateTime dateTime = DateTime.parse(value);
    String formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rhea's Event",
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Material(
              child: IconButton(
                onPressed: () {
                  nextScreen(context, AddEvent(eventModel));
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1.25),
          ),
          child: Wrap(
            runSpacing: 8.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Location:",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    "Zed Cafe",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date:",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    convertToDate(eventModel.dateTime!),
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Time:",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    convertToTime(eventModel.dateTime!),
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Response received:",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    "2",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 18,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
            height: 16), // Adjust the spacing between events as needed
      ],
    );
  }
}
