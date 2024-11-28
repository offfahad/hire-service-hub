import 'package:flutter/material.dart';

void customDialogBox(
  BuildContext context, {
  required String title,
  required String description,
  required List<Widget> actions, // You can pass buttons or other actions
  Widget? content, // Optional content to be passed
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Rounded edges
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                      width: 48), // To keep alignment (for back icon)
                ],
              ),

              const SizedBox(height: 5),

              // Description section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  description,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),

              const SizedBox(height: 8),

              // Optional content like radio buttons or other widgets
              if (content != null) content,

              const SizedBox(height: 8),

              // Actions like "Cancel" and "OK" buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ],
          ),
        ),
      );
    },
  );
}
