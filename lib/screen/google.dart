import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign-In',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign-In'),
        ),
        body: const Center(
          child: SignInButton(),
        ),
      ),
    );
  }
}

class SignInButton extends StatefulWidget {
  const SignInButton({super.key});

  @override
  SignInButtonState createState() => SignInButtonState();
}

class SignInButtonState extends State<SignInButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;

  Future<void> _handleSignIn() async {
    try {
      final googleSignIn = await _googleSignIn.signIn();
      if (googleSignIn != null) {
        setState(() {
          _currentUser = googleSignIn;
        });

        // Call your API to retrieve the callback URL
        const apiUrl = 'https://firstpluto.com/user/googleLogin';
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          final callbackUrl = response.body;

          // Launch the callback URL in a browser
          if (await canLaunchUrl(Uri.parse(callbackUrl))) {
            await launchUrl(Uri.parse(callbackUrl));
          } else {
            throw 'Could not launch the callback URL.';
          }
        } else {
          throw 'Failed to retrieve the callback URL from the API.';
        }
      }
    } catch (error) {
      log('Sign-In error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleSignIn,
      child: _currentUser == null
          ? const Text('Sign In with Google')
          : Text(_currentUser!.id.toString()),
    );
  }
}
