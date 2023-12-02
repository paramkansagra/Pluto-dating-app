import 'package:flutter/material.dart';
import 'dart:developer';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    log('The Route is : ${settings.name}');

    log(settings.toString());

    switch (settings.name) {
      case '/':
      // return LoginScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: const Text('error'))),
      settings: const RouteSettings(name: '/error'),
    );
  }
}
