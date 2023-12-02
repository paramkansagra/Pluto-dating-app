import 'check_up.dart';
import 'package:flutter/material.dart';

class MobileNumber extends StatefulWidget {
  final String name;
  final String emailId;
  final String password;
  const MobileNumber(
      {required this.password,
      required this.name,
      required this.emailId,
      super.key});

  @override
  State<MobileNumber> createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumber> {
  TextEditingController mobnoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Enter Name"),
            TextField(
              controller: mobnoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Mobile Number"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Submit(
                      name: widget.name,
                      password: widget.password,
                      emailId: widget.emailId,
                      mobileNo: mobnoController.text.toString(),
                    ),
                  ),
                );
              },
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: const Icon(Icons.arrow_circle_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
