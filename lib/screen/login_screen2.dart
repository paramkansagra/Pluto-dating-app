import 'dart:developer';

import 'package:dating_app/api/profile_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import '../Config/config.dart';
import '../Widgets/widget.dart';
import 'screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final profileApi = ProfileApi();

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  // late final WebViewController controller;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
      serverClientId:
          "784400354005-huo3upumit9p3dafv8cdljbr71k9tgji.apps.googleusercontent.com");

  GoogleSignInAccount? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _handleSignIn() async {
    try {
      final googleSignIn = await _googleSignIn.signIn();

      if (googleSignIn != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignIn.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        // ignore: unused_local_variable
        final User user = authResult.user!;

        _currentUser = googleSignIn;
        log(_currentUser.toString());
        log("id token -> ${googleAuth.idToken}");

        log("------ FETCH USER ID ------");
        final userIdResponce =
            await profileApi.fetchUserId(idToken: googleAuth.idToken);

        log("user id login screen-> ${userIdResponce["user_id"]}");

        await profileApi.apiData.saveData(
            userIdResponce["user_id"]!.toString(), userIdResponce["token"]!);

        await profileApi.apiData.getData();

        final profileResponce = await profileApi.fetchProfile();
        log("profile responce error -> ${profileResponce.error}");

        final mediaResponce = await profileApi.fetchMedia();
        log("media responce error -> ${mediaResponce.error}");

        setState(
          () {
            if (profileResponce.error == true) {
              nextScreen(context, const MobileNumber());
            } else if (mediaResponce.error == true &&
                profileResponce.error == false) {
              nextScreen(context, const ImageUploading());
            } else {
              nextScreen(context, const FirstScreen());
            }

            // nextScreen(
            //     context,
            //     ShowInfo(
            //         authToken: googleAuth.accessToken ?? "",
            //         userId: googleAuth.idToken ?? ""));
          },
        );

        // const apiUrl = 'https://firstpluto.com/user/googleLogin';
        // final response = await http.get(Uri.parse(apiUrl));
        // if (response.statusCode == 200) {
        //   final callbackUrl = response.body;
        //   log(response.body);

        //   // Launch the callback URL in a browser
        //   if (await canLaunch(callbackUrl)) {
        //     await launch(callbackUrl, forceSafariVC: true, forceWebView: true);
        //     // log()
        //   } else {
        //     throw 'Could not launch the callback URL.';
        //   }
        // } else {
        //   throw 'Failed to retrieve the callback URL from the API.';
        // }
      }
    } catch (error) {
      log('Sign-In error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Logo(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const LoginButton(
                    title: "Use mobile number",
                    textColor: Colors.black,
                    bgColor: Colors.white,
                    providerLogo: Icons.mobile_friendly,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 11),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: _handleSignIn,
                      child: const Wrap(
                        children: [
                          Icon(
                            FontAwesomeIcons.google,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Sign in with Google",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    width: 270,
                    child: Text(
                      "By signing up, you agree to our Terms. See how we use your data in our Privacy Policy. We never post to Facebook.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1.25,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
