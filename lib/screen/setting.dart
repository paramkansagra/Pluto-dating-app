import 'package:dating_app/Config/config.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<bool> _status = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFE7E7E7),
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: const Color(0XFFE7E7E7),
        elevation: 0,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        leadingWidth: 90,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0XFFE7E7E7),
            ),
            child: Text(
              "Cancel",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0XFFE7E7E7),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: const EdgeInsets.fromLTRB(18, 18, 0, 18),
                child: Text("Done",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              
              ListTile(
                onTap: () {
                  nextScreen(context, const EmailVerify());
                },
                contentPadding: const EdgeInsets.all(12),
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Colors.white,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verify your email",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Check your inbox for your verification email",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Choose mode",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Color(0XFFD0CFCF),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Data mode",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    FlutterSwitch(
                      height: 27,
                      width: 57,
                      inactiveColor: const Color(0xFF034B48).withOpacity(0.2),
                      activeColor: const Color(0xFF034B48),
                      value: _status[2],
                      onToggle: (val) {
                        setState(
                          () {
                            _status[2] = !_status[2];
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Snooze",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, bottom: 12, top: 12),
                child: const Text(
                  "Temporarily hide your profile",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hide my name",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    FlutterSwitch(
                      height: 27,
                      width: 57,
                      inactiveColor: const Color(0xFF034B48).withOpacity(0.2),
                      activeColor: const Color(0xFF034B48),
                      value: _status[0],
                      onToggle: (val) {
                        setState(
                          () {
                            _status[0] = !_status[0];
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, bottom: 12, top: 12),
                child: const Text(
                  "Enabling this will show only your first initial to other Pluto users.",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Incognito mode",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    FlutterSwitch(
                      height: 27,
                      width: 57,
                      inactiveColor: const Color(0xFF034B48).withOpacity(0.2),
                      activeColor: const Color(0xFF034B48),
                      value: _status[1],
                      onToggle: (val) {
                        setState(
                          () {
                            _status[1] = !_status[1];
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, bottom: 12, top: 12),
                child: const Text(
                  "Enable Incognito mode so no one sees you unless you want tp . Only people you swipe roght on will be able to view you.",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, bottom: 12, top: 12),
                child: const Text(
                  "Location",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Current location",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    const Text(
                      'Bengaluru Urban, IN',
                      style: TextStyle(color: Color(0XFF525252)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const Icon(
                  Icons.map_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  "Travel",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 18, bottom: 12, top: 12),
                child: const Text(
                  "Change your location to connect with people in other locations.",
                  style: TextStyle(color: Color(0XFF525252)),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Move Making Impact Settings",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Color(0XFFD0CFCF),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Video autoplay settings",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Color(0XFFD0CFCF),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Notification settings",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Color(0XFFD0CFCF),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Security & Privacy",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Color(0XFFD0CFCF),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Contact & FAQ",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Color(0XFFD0CFCF),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Restore purchases",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Log out",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  "Delete account",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
