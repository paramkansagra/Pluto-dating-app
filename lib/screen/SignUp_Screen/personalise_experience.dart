import "package:dating_app/Config/config.dart";
import "package:dating_app/screen/SignUp_Screen/name.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class PersonaliseExperience extends StatelessWidget {
  const PersonaliseExperience({super.key});

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
                  "Personalise your experience",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  "We use tracking to improve our marketing and your experience, like letting you connect to Facebook.",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            Column(
              children: [
                Center(
                  child: SvgPicture.asset("assets/images/personalise.svg"),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    nextScreen(context, const Name());
                  },
                  child: InkWell(
                    onTap: () {
                      nextScreen(context, const Name());
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
                        "Continue",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Center(
                  child: InkWell(
                    child: Text(
                      "Make changes in device setting at any tim.Read our privacy policy.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
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
