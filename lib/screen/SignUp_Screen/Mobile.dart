import 'package:dating_app/api/profile_api.dart';
import 'package:flutter_svg/svg.dart';
import "package:flutter/material.dart";
import '../../Widgets/widget.dart';
import "../screen.dart";
import '../../Config/config.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class MobileNumber extends StatefulWidget {
  const MobileNumber({super.key});

  @override
  State<MobileNumber> createState() => MobileNumberState();
}

class MobileNumberState extends State<MobileNumber> {
  TextEditingController mobnoController = TextEditingController();
  late PhoneNumber mobValue;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          // backgroundColor: Color(0xFF047E78),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {},
            ),
          ),
          body: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 151,
                      height: 64,
                      child: Text(
                        "What's your number?",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      "We protect our community by making sure everyone on Pluto is real.",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    const Row(
                      children: [
                        Text("Country"),
                        SizedBox(
                          width: 50,
                        ),
                        Text("Phone Number"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x0ffeeeee),
                                blurRadius: 10,
                                offset: Offset(0, 4))
                          ]),
                      child: InternationalPhoneNumberInput(
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        initialValue: PhoneNumber(isoCode: 'IN'),
                        spaceBetweenSelectorAndTextField: 4,
                        selectorConfig: const SelectorConfig(
                            leadingPadding: 5.0,
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            // showFlags: false,
                            useEmoji: false),
                        inputBorder: InputBorder.none,
                        cursorColor: Colors.black,
                        onInputChanged: (value) {
                          mobValue = value;
                        },
                        onSubmit: () => {
                          if (mobValue.phoneNumber!.length == 13)
                            {
                              ProfileApi()
                                  .otpSend(mobValue.phoneNumber!.substring(3)),
                              nextScreen(
                                  context,
                                  OptScreen(
                                      mobileNumber: mobValue.phoneNumber!))
                            }
                          else
                            {
                              FocusScope.of(context).unfocus(),
                              customSnackBar(
                                  text: "Enter valid mobile number",
                                  context: context)
                            }
                        },
                        autoFocus: true,
                        inputDecoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(bottom: 15, left: 0),
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                      child: SvgPicture.asset(
                        "assets/images/Lock.svg",
                        height: 14,
                        width: 14,
                      ),
                    ),
                    Container(
                      width: 244,
                      margin: const EdgeInsets.only(bottom: 33),
                      child: Text(
                        "We never share this with anyone and it won’t be on your profile",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFFF2F2F2).withOpacity(0.5),
              onPressed: () {
                if (mobValue.phoneNumber!.length == 13) {
                  // ProfileApi().otpSend(mobValue.phoneNumber!.substring(3));
                  nextScreen(
                      context, OptScreen(mobileNumber: mobValue.phoneNumber!));
                } else {
                  customSnackBar(
                      text: "Enter valid mobile number", context: context);
                }
              },
              child: const Icon(
                size: 24.0,
                Icons.arrow_forward_ios,
              ))),
    );
  }
}
