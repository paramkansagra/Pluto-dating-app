import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowInfo extends StatefulWidget {
  final String authToken, userId;

  const ShowInfo({super.key, required this.authToken, required this.userId});

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  TextEditingController authController = TextEditingController();
  TextEditingController userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authController.text = widget.authToken;
    userIdController.text = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "The auth token is : ",
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
                controller: authController,
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
                    Clipboard.setData(ClipboardData(text: authController.text))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Copied to your clipboard !')));
                    });
                  },
                  child: const Text('Copy'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "The userId token is : ",
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
                controller: userIdController,
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
                            ClipboardData(text: userIdController.text))
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
    ));
  }
}
