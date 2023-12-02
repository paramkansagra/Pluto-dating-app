import 'dart:developer';

import 'package:dating_app/Config/config.dart';
import 'package:dating_app/screen/screen.dart';
import 'package:flutter/material.dart';

class EmailId extends StatefulWidget {
  final Map<String, dynamic> profileObject;

  const EmailId({super.key, required this.profileObject});

  @override
  State<EmailId> createState() => EmailIdState();
}

class EmailIdState extends State<EmailId> {
  @override
  void initState() {
    super.initState();
    log(widget.profileObject.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF034B48),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: (MediaQuery.of(context).size.width / 7) * 7,
                        height: 5,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 19,
                      ),
                      Text(
                        "What's your email address?",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        "We use this to recover your account if you can’t log in.",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(hintText: "Add recovery email"),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: InkWell(
                  onTap: () {
                    nextScreen(context, const ImageUploading());
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white.withOpacity(0.5),
          onPressed: () {
            nextScreen(context, const ImageUploading());
          },
          child: const Icon(Icons.arrow_forward_ios_outlined)),
    );
  }
}
