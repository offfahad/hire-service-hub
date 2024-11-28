import 'package:e_commerce/common/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class CloseAccountFeedbackScreen extends StatelessWidget {
  const CloseAccountFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Close Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why are you closing your account?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Care to tell us more?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
                borderRadius: 8,
                text: "Close my account",
                onPressed: () {},
                backgroundColor: Colors.red,
                foregroundColor: Colors.white)
          ],
        ),
      ),
    );
  }
}
