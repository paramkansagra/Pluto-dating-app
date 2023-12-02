import 'package:dating_app/Config/config.dart';
import 'package:dating_app/chat/inbox.dart';
import 'package:dating_app/screen/matched.dart';
import 'package:dating_app/screen/profile.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  final List<BottomNavigationBarItem> bottomNavigationItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/images/icons/profile.svg",
        ),
        label: "Profile"),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/images/icons/home.svg",
        ),
        label: "Home"),
    BottomNavigationBarItem(
        icon: SvgPicture.asset("assets/images/icons/Location.svg"),
        label: "Map"),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/images/icons/heart.svg",
        ),
        label: "Like"),
    BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/images/icons/message.svg",
        ),
        label: "Chat"),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      unselectedIconTheme: const IconThemeData(color: Colors.white),
      selectedIconTheme: const IconThemeData(color: Colors.black),
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: bottomNavigationItems,
      onTap: (index) {
        if (index != currentIndex) {
          if (index == 0) nextScreen(context, const Profile());
          if (index == 1) nextScreen(context, const FirstScreen());
          if (index == 2) nextScreen(context, const map());
          if (index == 3) nextScreen(context, const Matched());
          if (index == 4) nextScreen(context, const ChatScreen());
        }
      },
    );
  }
}
