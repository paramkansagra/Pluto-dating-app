import 'package:dating_app/models/update_search_model.dart';
import 'package:flutter/material.dart';

class Languages extends StatefulWidget {
  final Data filterModel;
  const Languages({super.key, required this.filterModel});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  List<String> language = [
    "English",
    "French",
    "Hindi",
    "Japanese",
    "Arabic",
    "Bengali",
    "Spanish",
    "German",
    "Italian",
    "Portuguese",
    "Russian",
    "Korean",
    "Indonesian",
    "Gujarati",
    "Dutch",
    "Urdu",
    "Danish",
    "Turkish",
    "Czech",
    "Finnish",
    "Marathi",
    "Greek",
    "Kannada",
    "Tamil"
  ];

  List<String> tempLanguage = [];
  List finalLanguage = [];
  List<String> selectedLanguages = [];

  @override
  void initState() {
    tempLanguage = language;
    super.initState();
  }

  void runFilter(String enteredKeyword) {
    List<String> results = [];
    if (enteredKeyword.isEmpty) {
      results = language;
    } else {
      results = language
          .where((x) => x.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      tempLanguage = results;
    });
  }

  void _toggleLanguageSelection(String language) {
    setState(() {
      if (selectedLanguages.contains(language)) {
        selectedLanguages.remove(language);
      } else {
        if (selectedLanguages.length < 5) {
          selectedLanguages.add(language);
        } else {
          // Display an error message or take appropriate action
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You can only select up to 5 Languages."),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Your language",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What language do you know ?",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "We’ll show these on your profile and use them to connect you with great matches who know your languages.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Select up to 5",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              onChanged: (value) => runFilter(value),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                hintText: "Search for a language",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: tempLanguage.length,
                  itemBuilder: (context, index) {
                    final language = tempLanguage[index];
                    final isSelected = selectedLanguages.contains(language);

                    return CheckboxListTile(
                      activeColor: Theme.of(context).scaffoldBackgroundColor,
                      checkColor: Colors.transparent,
                      checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      title: Text(
                        language,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.black),
                      ),
                      value: isSelected,
                      onChanged: (value) => _toggleLanguageSelection(language),
                    );
                  }),
            ),
            ListTile(
              onTap: () {
                widget.filterModel.language = selectedLanguages;
                Navigator.pop(context, widget.filterModel);
              },
              tileColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Apply",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
