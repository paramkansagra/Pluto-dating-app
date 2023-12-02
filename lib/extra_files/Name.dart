import "package:flutter/material.dart";

import 'email_id.dart';

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    {
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
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailId(
                        name: nameController.text.toString(),
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
}
