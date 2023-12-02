import 'package:flutter/material.dart';

class InterestButton extends StatelessWidget {
  final String title;
  final IconData iconData;

  const InterestButton({
    required this.title,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.95),
        color: const Color(0XFF047E78).withOpacity(0.44),
      ),
      child: Wrap(
        spacing: 5,
        children: [
          Icon(
          iconData,
            color: Colors.white,
            size: 16,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
