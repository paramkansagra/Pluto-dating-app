import 'package:dating_app/api/profile_api.dart';
import 'package:dating_app/provider/internet_provider.dart';
import 'package:dating_app/provider/sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'provider/upload_image_provider.dart';
import 'screen/screen.dart';
import 'Config/config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // if we have data present in the backend i.e. on the device we would use that to login
  bool isDataPresent = await ApiData().isDataPresent();
  final profileResponce = await ProfileApi().fetchProfile();
  final mediaResponce = await ProfileApi().fetchMedia();

  // for testing audio recording

  // runApp(
  //   const MyApp(
  //     screen: AudioRecord(),
  //   ),
  // );

  // so if the data is present we would present it with the first screen
  if (isDataPresent &&
      profileResponce.error! == false &&
      mediaResponce.error == false) {
    runApp(
      const MyApp(
        screen: FirstScreen(),
      ),
    );
  } else {
    // else we would go to the login screen and use it
    ApiData()
        .deleteData(); // if we have some error in the profiles that we have with us or media issues we will clear the pref memory
    runApp(
      const MyApp(
        screen: LoginScreen(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.screen});
  // we are taking which screen to present
  // either the home screen or the login screen
  final Widget screen;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => SignInProvider())),
        ChangeNotifierProvider(create: ((context) => InternetProvider())),
        ChangeNotifierProvider(create: ((context) => ImageUploadProvider())),
      ],
      child: MaterialApp(
        theme: theme(), debugShowCheckedModeBanner: false,
        home:
            widget.screen, // jo screen input me aa rahi hai usko present kar do
        // const chatting(
        //   appId: "753BD86C-204A-4C0B-80F5-1BF74A274A6F",
        //   userId: "aditya",
        //   otherUserId: ["pawan"],
        // ),

        // initialRoute: "secondPage",
        // routes: {"secondPage": (context) => const SplashScreen()},
      ),
    );
  }
}
