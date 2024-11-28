import 'package:e_commerce/common/buttons/custom_elevated_button.dart';
import 'package:e_commerce/screens/profile/more_screens/account_screens/close_account_screens/close_account_reason_screen.dart';
import 'package:e_commerce/widgets/bullet_text.dart';
import 'package:flutter/material.dart';

class CloseAccountExplanationScreen extends StatelessWidget {
  const CloseAccountExplanationScreen({super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What does closing your account mean?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We hate to see you go. Are you sure you want to close your Ajar account? Please be advised if you choose to proceed, your account closure will be irreversible. You will no longer be able to book trips or list your car on Ajar.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BulletText(text: 'Your vehicle listing(s) will be deleted.'),
                BulletText(
                    text:
                        'Any information associated with your account will not be publicly viewable.'),
                BulletText(
                    text:
                        'Any booked or pending trips will be canceled immediately.'),
                BulletText(
                    text: 'Currently, you have 0 booked and/or pending trips.'),
                BulletText(
                    text:
                        'You will no longer be able to log in to your account.'),
                BulletText(
                    text:
                        'You are still financially responsible for any fees, claims, or reimbursements related to your past or pending trips.'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Do you want to continue?"),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
                borderRadius: 8,
                text: "Continue",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CloseAccountReasonScreen(),
                    ),
                  );
                  
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white)
          ],
        ),
      ),
    );
  }
}
