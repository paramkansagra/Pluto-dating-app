import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

//pushReplacement
class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  CustomPageRoute({
    required this.child,
  }) : super(pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
}
