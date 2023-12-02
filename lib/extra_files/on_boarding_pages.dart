// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import '../screen/Home_Screen.dart';
// import '../screen/Splash_Screen.dart';


// List<PageViewModel> now() {
//   return [
//     PageViewModel(
//       title: "Pluto App",
//       bodyWidget: Row(
//         mainAxisAlignment:   MainAxisAlignment.center,
//         children: const [Text("Welcome to the dating application")],
//       ),
//       image: const Center(child: Icon(Icons.android)),
//     ),
//     PageViewModel(
//       title: "Pluto App",
//       bodyWidget: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [Text("Welcome to the dating application")],
//       ),
//       image: const Center(child: Icon(Icons.android)),
//     ),
//     PageViewModel(
//       title: "Pluto App",
//       bodyWidget: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [Text("Welcome to the dating application")],
//       ),
//       image: const Center(child: Icon(Icons.android)),
//     )
//   ];
// }

// class OnBoardingPages extends StatefulWidget {
//   const OnBoardingPages({super.key});

//   @override
//   State<OnBoardingPages> createState() => _OnBoardingPagesState();
// }

// class _OnBoardingPagesState extends State<OnBoardingPages> {
//   bool isDone = false;

//   @override
//   Widget build(BuildContext context) {
//     return isDone == false
//         ? IntroductionScreen(
//             pages: now(),
//             showSkipButton: false,
//             showNextButton: false,
//             showBackButton: true,
//             back: const Icon(Icons.arrow_back),
//             done: const Icon(Icons.arrow_forward),
//             onDone: () => {
//               isDone = true,
//               Navigator.push(
//                 context,
//                 MaterialPageRoute<void>(
//                   builder: (BuildContext context) => const Home(),
//                 ),
//               )
//             },
//           )
//         : const SplashScreen();
//   }
// }
