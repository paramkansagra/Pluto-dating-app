import 'package:flutter/material.dart';

enum GenderType { male, female, nonBinary }

class CustomRadioButton extends StatelessWidget {
  final String title;
  final GenderType groupValue;
  final GenderType value;
  final Function(GenderType?)? onChanged;
  const CustomRadioButton(
      {required this.title,
      required this.groupValue,
      required this.value,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 14),
        ),
        trailing: Radio<GenderType>(
          activeColor: const Color(0xFF047E78),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
