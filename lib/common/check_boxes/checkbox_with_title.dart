// Helper method to build the feature checkbox
import 'package:flutter/material.dart';

Widget buildFeatureCheckbox(
    String title, bool value, Function(bool?) onChanged) {
  return Row(
    children: [
      SizedBox(
        width: 24,
        height: 24,
        child: Checkbox(
          //side: const BorderSide(width: 0.5),
          value: value,
          onChanged: onChanged,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
    ],
  );
}


