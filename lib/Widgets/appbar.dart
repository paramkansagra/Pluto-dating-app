import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Config/config.dart';
import '../provider/sign_in_provider.dart';
import '../screen/screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.sp,
  });
  @override
  Size get preferredSize => const Size.fromHeight(56.0);
  final SignInProvider sp;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      iconTheme: const IconThemeData(color: Colors.black, size: 28),
      actions: [
        IconButton(
          icon: Image.asset(
            "assets/images/icons/filter2.png",
          ),
          color: Colors.black,
          onPressed: () {
            nextScreen(context, const Filter());
          },
        ),
      ],
      title: Text(
        "Pluto",
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: const Color(0XFFF1F1F1),
      elevation: 0,
    );
  }
}
