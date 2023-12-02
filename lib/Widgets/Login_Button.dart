import 'package:dating_app/Config/config.dart';
import "package:flutter/material.dart";
import '../screen/screen.dart';

class LoginButton extends StatelessWidget {
  // ? providerLogo = null;
  // Color? button_color;
  const LoginButton({
    required this.bgColor,
    required this.textColor,
    required this.title,
    required this.providerLogo,
    super.key,
  });

  final String title;
  final IconData providerLogo;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 11),
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90), color: bgColor),
        child: Center(
          child: Wrap(
            children: [
              Icon(
                providerLogo,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: textColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        nextScreen(context, const MobileNumber());
      },
    );
  }
}
