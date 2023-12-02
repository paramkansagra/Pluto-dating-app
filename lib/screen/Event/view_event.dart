import 'package:dating_app/Widgets/event_card.dart';
import 'package:dating_app/api/event_api.dart';
import 'package:dating_app/models/view_event_model.dart';
import 'package:flutter/material.dart';

class ViewEvent extends StatefulWidget {
  const ViewEvent({super.key});

  @override
  ViewEventState createState() => ViewEventState();
}

class ViewEventState extends State<ViewEvent> {
  ViewEventModel viewEventModel = ViewEventModel();

  loadEvent() async {
    viewEventModel = await EventApi().getEvent();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 18.0,
              direction: Axis.horizontal,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "My Events",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 16, color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    "Interested Events",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
            FutureBuilder(
                future: loadEvent(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height - 80,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                            "OOP's some error occurred. Please try again"));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: viewEventModel.data!
                            .length, // Replace 6 with the actual number of events
                        itemBuilder: (context, index) {
                          return EventCard(
                              eventId: index,
                              eventModel: viewEventModel.data![index]);
                        },
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
