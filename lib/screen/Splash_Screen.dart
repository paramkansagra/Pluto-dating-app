import 'dart:async';
import 'package:dating_app/screen/screen.dart';

import '../Widgets/widget.dart';
import 'package:dating_app/provider/sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Config/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //init state
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();
    Timer(const Duration(seconds: 2), () {
      (sp.isSignedin == false)
          ? nextScreenReplace(context, const LoginScreen())
          : nextScreenReplace(context, const FirstScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.height,
        child: const Center(
          child: Logo(),
        ),
      ),
    );
  }
}
