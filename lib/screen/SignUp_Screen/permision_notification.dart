import 'package:dating_app/Config/config.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPermission extends StatelessWidget {
  const NotificationPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.only(top: 36, left: 35, right: 35, bottom: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Allow notifications",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  "We’ll let you know when you get new matches and messages.",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            Column(
              children: [
                Center(child: SvgPicture.asset("assets/images/notiicon.svg")),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    nextScreen(context, const PersonaliseExperience());
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0XFFF2F2F2),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      "Allow notifications",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Center(
                  
                  child: InkWell(
                    onTap: () {
                      nextScreen(context, const PersonaliseExperience());
                    },
                    child: Text(
                      "Not now",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
