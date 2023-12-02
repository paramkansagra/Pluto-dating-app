import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Submit extends StatefulWidget {
  final String name, mobileNo, emailId, password;
  const Submit(
      {required this.name,
      required this.mobileNo,
      required this.emailId,
      required this.password,
      super.key});

  @override
  State<Submit> createState() => SubmitState();
}

class SubmitState extends State<Submit> {
  void signUp(String firstName, String lastName, String age) async {
    try {
      Response response = await post(
          Uri.parse("https://dummyjson.com/users/add"),
          body: {"firstName": firstName, "lastName": lastName, "age": age});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        log(data["id"].toString());
        log("Successfully signup");
      } else {
        log("There is some error with signup");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.name),
          Text(widget.mobileNo),
          Text(widget.emailId),
          Text(widget.password),
          ElevatedButton(
            child: const Text('Sign Up'),
            onPressed: () {
              signUp(widget.name, widget.emailId, widget.mobileNo);
            },
          ),
        ],
      ),
    );
  }
}
