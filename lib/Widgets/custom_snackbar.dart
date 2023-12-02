import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar(
    {required String text, required context}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.red,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      content: Text(
        text,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    ),
  );
}
