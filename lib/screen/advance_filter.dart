import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AdvanceFilter extends StatefulWidget {
  const AdvanceFilter({super.key});

  @override
  State<AdvanceFilter> createState() => _AdvanceFilterState();
}

class _AdvanceFilterState extends State<AdvanceFilter> {
  List<List<dynamic>> heading = [
    [const Icon(Icons.height), "What's their height", "height"],
    [
      const Icon(
        Icons.sports_gymnastics_outlined,
      ),
      "Do they work out?",
      "exercise"
    ],
    [
      const Icon(
        Icons.school_outlined,
      ),
      "What's they education?",
      "education_level"
    ],
    [
      const Icon(
        Icons.wine_bar_outlined,
      ),
      "Do they drink?",
      "drink"
    ],
    [
      const Icon(
        Icons.smoking_rooms_outlined,
      ),
      "Do they smoke?",
      "smoke"
    ],
    [
      const Icon(
        Icons.search,
      ),
      "What do you want from your pluto dates?",
      "looking_for"
    ],
    [
      const Icon(
        Icons.man_2_outlined,
      ),
      "What their ideal plan for children?",
      "child"
    ],
    [
      const Icon(
        Icons.sign_language,
      ),
      "What's their zodiac sign?",
      "zodiac_sign"
    ],
    [
      const Icon(
        Icons.policy_outlined,
      ),
      "What are their political learning?",
      "politics"
    ],
    [
      const Icon(
        Icons.handshake,
      ),
      "What's their religion?",
      "religious"
    ]
  ];

  List<String> titles = [
    "Add this filter",
    "Add this filter",
    "Add this filter",
    "Add this filter",
    "Add this filter",
    "Add this filter",
    "Add this filter",
    "Add this filter",
    "Add this filter",
    "Add this filter",
  ];

  bool _status = false;
  bool status1 = false;
  List<bool> activityStatus = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFE7E7E7),
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: const Color(0XFFE7E7E7),
        elevation: 0,
        title: Text(
          "Advanced Filters",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 18,
              ),
        ),
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
      ),
      body: Container(
        margin: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 11,
                itemBuilder: ((context, index) => index == 0
                    ? Column(children: [
                        Container(
                          margin: const EdgeInsets.only(left: 18, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Have they verified themselves? ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "What's that?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(color: Colors.black),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(6, 15, 6, 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Verified profile only",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Colors.black, fontSize: 14),
                              ),
                              FlutterSwitch(
                                height: 27,
                                width: 57,
                                inactiveColor:
                                    const Color(0xFF034B48).withOpacity(0.2),
                                activeColor: const Color(0xFF034B48),
                                value: _status,
                                onToggle: (val) {
                                  setState(
                                    () {
                                      _status = !_status;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 18, bottom: 8),
                            child: Text(
                              heading[index - 1][1],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          ListTile(
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(6, 0, 6, 0),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                titles[index - 1],
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                        color: Colors.black, fontSize: 14),
                              ),
                            ),
                            trailing: const Icon(Icons.add),
                            leading: heading[index - 1][0],
                            minLeadingWidth: 0,
                            onTap: () {
                              showModalBottomSheet(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.5),
                                  backgroundColor: Colors.white,
                                  isScrollControlled: true,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  context: context,
                                  builder: (context) {
                                    return FiltersPopups(
                                      index: index - 1,
                                    );
                                  });
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      )),
              ),
            ),
            Container(
              color: const Color(0XFFE7E7E7),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Text(
                    "Apply",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class FiltersPopups extends StatefulWidget {
  final int index;
  const FiltersPopups({super.key, required this.index});

  @override
  State<FiltersPopups> createState() => FiltersPopupsState();
}

class FiltersPopupsState extends State<FiltersPopups> {
  RangeValues _currentRangeValues = const RangeValues(90, 220);

  List<List<dynamic>> heading = [
    [const Icon(Icons.height), "What's their height", "height"],
    [
      const Icon(
        Icons.sports_gymnastics_outlined,
        size: 40,
      ),
      "Do they work out?",
      "exercise"
    ],
    [
      const Icon(
        Icons.school_outlined,
        size: 40,
      ),
      "What's they education?",
      "education_level"
    ],
    [
      const Icon(
        Icons.wine_bar_outlined,
        size: 40,
      ),
      "Do they drink?",
      "drink"
    ],
    [
      const Icon(
        Icons.smoking_rooms_outlined,
        size: 40,
      ),
      "Do they smoke?",
      "smoke"
    ],
    [
      const Icon(
        Icons.search,
        size: 40,
      ),
      "What do you want from dates?",
      "looking_for"
    ],
    [
      const Icon(
        Icons.man_2_outlined,
        size: 40,
      ),
      "What their ideal plan for children?",
      "child"
    ],
    [
      const Icon(
        Icons.sign_language,
        size: 40,
      ),
      "What's their zodiac sign?",
      "zodiac_sign"
    ],
    [
      const Icon(
        Icons.policy_outlined,
        size: 40,
      ),
      "What are their political learning?",
      "politics"
    ],
    [
      const Icon(
        Icons.handshake,
        size: 40,
      ),
      "What's their religion?",
      "religious"
    ]
  ];

  List<List<String>> options = [
    ["everyday", "sometimes", "never"],
    ["highschool", "college", "graduate", "postgraduate"],
    ["everyday", "sometimes", "never"],
    ["socially", "never", "regular"],
    ["relationship", "marriage", "casual", "NotKnownYet"],
    ["skip"],
    ["skip"],
    ["skip"],
    ["skip"],
  ];

  @override
  Widget build(BuildContext context) {
    return widget.index != 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  Text(
                    heading[widget.index][1],
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.black, wordSpacing: 1.25),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: options[widget.index - 1].length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      value: false,
                      onChanged: (value) {},
                      title: Wrap(children: [
                        Text(
                          options[widget.index - 1][index],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ]),
                      activeColor: Theme.of(context).scaffoldBackgroundColor,
                    );
                  },
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  Text(
                    heading[0][1],
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.black, wordSpacing: 1.25),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  (_currentRangeValues.end.round() == 220 &&
                          _currentRangeValues.start.round() == 90)
                      ? "Any height is just fine"
                      : _currentRangeValues.end.round() == 220 &&
                              _currentRangeValues.start.round() > 90
                          ? "Taller than ${_currentRangeValues.start.round()} cm"
                          : (_currentRangeValues.end.round() < 220 &&
                                  _currentRangeValues.start.round() == 90)
                              ? "Shorter than ${_currentRangeValues.end.round()} cm"
                              : "Between ${_currentRangeValues.start.round()} cm and ${_currentRangeValues.end.round()} cm",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                        wordSpacing: 1.25,
                      ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RangeSlider(
                activeColor: Theme.of(context).scaffoldBackgroundColor,
                inactiveColor: const Color(0XFFE7E7E7),
                labels: RangeLabels('${_currentRangeValues.start}',
                    '${_currentRangeValues.end}'),
                values: _currentRangeValues,
                min: 90,
                max: 220,
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
            ],
          );
  }
}
