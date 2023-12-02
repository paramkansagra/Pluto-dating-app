import 'package:dating_app/Widgets/buttom_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Matched extends StatefulWidget {
  const Matched({super.key});

  @override
  State<Matched> createState() => MatchedState();
}

class MatchedState extends State<Matched> {
  Future<void> getApplicationTokenId() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) {
      setState(() {
        textEditingController.text = token!;
      });
    });
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getApplicationTokenId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Token id"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "The device token id is : ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: null,
                readOnly: true,
                controller: textEditingController,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.5, 50),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor),
                  onPressed: () {
                    Clipboard.setData(
                            ClipboardData(text: textEditingController.text))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Copied to your clipboard !')));
                    });
                  },
                  child: const Text('Copy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
