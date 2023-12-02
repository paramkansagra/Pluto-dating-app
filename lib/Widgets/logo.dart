import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/images/Logo.svg"),
        const SizedBox(
          height: 20.0,
        ),
        const Text(
          "Find your cosmic match.",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }
}