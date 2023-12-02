import "package:dating_app/Config/config.dart";
import "package:dating_app/models/profile_creation_model.dart";
import "package:dating_app/screen/SignUp_Screen/birthday.dart";
import "package:flutter/material.dart";

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        width: MediaQuery.of(context).size.width / 7,
                        height: 5,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Text(
                    "What's your Name?",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              Column(
                children: [
                  customTextBox(context, "First Name", firstNameController),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextBox(context, "Last Name", lastNameController),
                ],
              ),
              Column(
                children: [
                  Wrap(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 250,
                        margin: const EdgeInsets.only(bottom: 33),
                        child: Text(
                          "We only show your first name",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (firstNameController.value.text.isNotEmpty &&
              lastNameController.value.text.isNotEmpty) {
            ProfileCreationModel profileModel = ProfileCreationModel();
            profileModel.firstName = firstNameController.value.text;
            profileModel.lastName = lastNameController.value.text;
            nextScreen(context, Birthday(profileObject: profileModel));
          }
        },
        backgroundColor: Colors.white.withOpacity(0.5),
        child: const Icon(Icons.arrow_forward_ios_sharp),
      ),
    );
  }

  Container customTextBox(
      BuildContext context, String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.white),
      child: TextField(
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(wordSpacing: 1.25, fontSize: 24, color: Colors.black),
        autofocus: true,
        cursorColor: Colors.black,
        controller: controller,
        decoration: InputDecoration(
            labelText: hint,
            border: InputBorder.none,
            labelStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  wordSpacing: 1.25,
                  fontSize: 20,
                ),
            contentPadding: const EdgeInsets.all(16)),
      ),
    );
  }
}
