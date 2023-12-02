import 'package:dating_app/Config/config.dart';
import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/models/update_search_model.dart';
import 'package:dating_app/screen/advance_filter.dart';
import 'package:dating_app/screen/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => FilterState();
}

class FilterState extends State<Filter> {
  Data filterData = Data();

  List<bool> checkButtonValues = [false, false, false];
  bool _status = false;
  bool _status1 = false;
  bool _status2 = false;
  RangeValues _currentRangeValues = const RangeValues(18, 80);
  var distanceValue = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFE7E7E7),
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: const Color(0XFFE7E7E7),
        elevation: 0,
        title: Text(
          "Data Filters",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.black,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            ProfileApi().updateSearch(UpdateSearchModel(data: filterData));
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 18, bottom: 12),
                child: const Text(
                  "Who you want to date",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "I’m open to dating everyone",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 14),
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
                                  if (_status) {
                                    checkButtonValues = [true, true, true];
                                  } else {
                                    checkButtonValues = [false, false, false];
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const CustomDivider(),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      tileColor: Colors.white,
                      activeColor: const Color(0xFF047E78),
                      checkColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      title: Text(
                        'Men',
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

                          if (checkButtonValues[0] == true) {
                            if (filterData.gender == null) {
                              filterData.gender = ["male"];
                            } else if (filterData.gender != null) {
                              filterData.gender?.add("male");
                            }
                          } else {
                            if (filterData.gender != null) {
                              filterData.gender!.remove("male");
                            }
                          }
                        });
                      },
                    ),
                    const CustomDivider(),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      tileColor: Colors.white,
                      activeColor: const Color(0xFF047E78),
                      checkColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      title: Text(
                        'Women',
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

                        if (checkButtonValues[0] == true) {
                          if (filterData.gender == null) {
                            filterData.gender = ["female"];
                          } else if (filterData.gender != null) {
                            filterData.gender?.add("female");
                          }
                        } else {
                          if (filterData.gender != null) {
                            filterData.gender!.remove("female");
                          }
                        }
                      },
                    ),
                    const CustomDivider(),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      tileColor: Colors.white,
                      activeColor: const Color(0xFF047E78),
                      checkColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      title: Text(
                        'Nonbinary People',
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

                          if (checkButtonValues[2] == true) {
                            if (filterData.gender == null) {
                              filterData.gender = ["binary"];
                            } else if (filterData.gender != null) {
                              filterData.gender?.add("binary");
                            }
                          } else {
                            if (filterData.gender != null) {
                              filterData.gender!.remove("binary");
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24, left: 18, bottom: 12),
                child: const Text(
                  "Age",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentRangeValues.end.round() == 80
                          ? "\nBetween ${_currentRangeValues.start.round()} and ${_currentRangeValues.end.round()} +"
                          : "\nBetween ${_currentRangeValues.start.round()} and ${_currentRangeValues.end.round()}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
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
                      min: 18,
                      max: 80,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                          filterData.minAge = _currentRangeValues.start.round();
                          filterData.maxAge = _currentRangeValues.end.round();
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "See people 2 years either side if I run out",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 14),
                          ),
                        ),
                        FlutterSwitch(
                          height: 27,
                          width: 57,
                          inactiveColor:
                              const Color(0xFF034B48).withOpacity(0.2),
                          activeColor: const Color(0xFF034B48),
                          value: _status1,
                          onToggle: (val) {
                            setState(
                              () {
                                _status1 = !_status1;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24, left: 18, bottom: 12),
                child: const Text(
                  "Distance",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      distanceValue.round() == 160
                          ? "\nWhole country"
                          : "\nUpto to ${distanceValue.round()} kilometers away",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Slider(
                      activeColor: Theme.of(context).scaffoldBackgroundColor,
                      inactiveColor: const Color(0XFFE7E7E7),
                      value: distanceValue,
                      min: 2.0,
                      max: 160.0,
                      onChanged: (value) {
                        setState(() {
                          distanceValue = value;
                          filterData.distance = distanceValue.round();
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "See people slightly further away if I run out",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: FlutterSwitch(
                            height: 27,
                            width: 57,
                            inactiveColor:
                                const Color(0xFF034B48).withOpacity(0.2),
                            activeColor: const Color(0xFF034B48),
                            value: _status2,
                            onToggle: (val) {
                              setState(
                                () {
                                  _status2 = !_status2;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24, left: 18, bottom: 12),
                child: const Text(
                  "Languages they know",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                tileColor: Colors.white,
                title: Text(
                  "Select Languages",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 14),
                ),
                trailing: const Icon(
                  color: Colors.black,
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Languages(
                              filterModel: filterData,
                            )),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        filterData = value;
                      });
                    }
                  });
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 24, left: 18, bottom: 12),
                child: const Text(
                  "Filter",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                tileColor: Colors.white,
                title: Text(
                  "Set advanced filters",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 14),
                ),
                trailing: const Icon(
                  color: Colors.black,
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                onTap: () {
                  nextScreen(context, const AdvanceFilter());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 0.5,
      color: Color(0XFF222222),
    );
  }
}
