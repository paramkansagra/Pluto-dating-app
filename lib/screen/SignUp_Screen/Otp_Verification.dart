import 'package:dating_app/Config/config.dart';
import 'package:dating_app/screen/SignUp_Screen/name.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class OptScreen extends StatefulWidget {
  final String mobileNumber;
  const OptScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  State<OptScreen> createState() => OptScreenState();
}

class OptScreenState extends State<OptScreen> {
  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(6, (index) => TextEditingController());
    otpFocusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final focusNode in otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            margin:
                const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verify your number",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: [
                          Text(
                            "Enter the number we've sent by text to ${widget.mobileNumber}.",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 112,
                    ),
                    Text(
                      "Enter Code",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Form(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => Expanded(
                            child: OtpButton(
                              controller: otpControllers[index],
                              focusNode: otpFocusNodes[index],
                              nextFocusNode:
                                  index == 5 ? null : otpFocusNodes[index + 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Resend",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white.withOpacity(0.5),
          child: const Icon(Icons.arrow_forward_ios_sharp),
          onPressed: () {
            final otpValues =
                otpControllers.map((controller) => controller.text).toList();
            // final otpString = otpValues.join('');// Print the list of OTP values
            if (otpValues.length == 6) {
              // ProfileApi().otpVerify(
              //   widget.mobileNumber.substring(3), otpString
              // );
              nextScreen(context, const Name());
            }
          },
        ),
      ),
    );
  }
}

class OtpButton extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const OtpButton({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 48,
      width: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: Colors.black,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.headlineMedium,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}
