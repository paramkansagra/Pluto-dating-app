import 'package:flutter/material.dart';

Container customChoiceButton(String data, Color bgColor, TextStyle style,
    {String emoji = ""}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Wrap(
      children: [
        // there are many places where we dont need emoji but we are reusing the widget
        // so we just added a condition that if the length of the emoji is not 0 then we would have the emoji
        // else we would not be using the emoji or the sized box for good spacing
        if (emoji.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Text(emoji),
          ),
        Text(data, textAlign: TextAlign.center, style: style),
      ],
    ),
  );
}
