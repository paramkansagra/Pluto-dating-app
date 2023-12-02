import 'package:flutter/material.dart';

import '../../models/profile_model.dart';

class ChecklistBottomSheet extends StatefulWidget {
  final ProfileModel profileModel;
  const ChecklistBottomSheet({Key? key, required this.profileModel})
      : super(key: key);

  @override
  ChecklistBottomSheetState createState() => ChecklistBottomSheetState();
}

class ChecklistBottomSheetState extends State<ChecklistBottomSheet> {
  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);
  String? answer;
  late Map<String, dynamic> profileModelResponse =
      Map.from(widget.profileModel.toJson());
  List<String> gender = ['Male', 'Female', 'Binary'];
  late int selectedOption =
      gender.indexOf(capitalize(profileModelResponse["gender"]));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(
                  width: 40,
                ),
                Text(
                  "Update your gender",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 18),
            child: Text(
              "Pick which best describes you",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          for (int i = 0; i < gender.length; i++) customTileBox(gender[i], i),
          const SizedBox(
            height: 24,
          ),
          Text(
            "My pronouns",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: ListTile(
              title: Text(
                "Add your pronouns",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                if (answer != null && answer!.isNotEmpty) {
                  profileModelResponse['gender'] = answer!.toLowerCase();

                  Navigator.of(context).pop(profileModelResponse);
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Save",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container customTileBox(String text, int optionIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: RadioListTile(
        activeColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        value: optionIndex,
        groupValue: selectedOption,
        onChanged: (int? value) {
          setState(() {
            selectedOption = value!;
            answer = text;
          });
        },
      ),
    );
  }
}
