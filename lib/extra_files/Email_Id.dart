import "package:flutter/material.dart";

import "Mobile_Number.dart";

class EmailId extends StatefulWidget {
  final String name;
  const EmailId({required this.name, super.key});

  @override
  State<EmailId> createState() => _EmailIdState();
}

class _EmailIdState extends State<EmailId> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Enter email-id"),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Enter Password"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MobileNumber(
                              name: widget.name,
                              emailId: emailController.text.toString(),
                              password: passwordController.text.toString(),
                            )));
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
