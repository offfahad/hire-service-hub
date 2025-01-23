import 'dart:convert';

import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/reviews/reviews_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewDialog extends StatefulWidget {
  final String serviceId;
  final String orderId;

  const ReviewDialog(
      {required this.serviceId, super.key, required this.orderId});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final _reviewController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text('Give a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Rating Bar
          RatingBar.builder(
            initialRating: 0,
            minRating: 0.5, // Allow half-star ratings
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 16),
          // Review Text Field
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              hintText: 'Write your review here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        // Submit Button
        TextButton(
          onPressed: () async {
            final reviewMessage = _reviewController.text.trim();
            if (_rating == 0) {
              showCustomSnackBar(
                  context, "Please select the ratting!", Colors.red);
              return;
            }
            if (reviewMessage.isEmpty) {
              showCustomSnackBar(
                  context, "Review comment cannot be empty!", Colors.red);
              return;
            }

            final response =
                await Provider.of<ReviewsProvider>(context, listen: false)
                    .submitReview(
              orderId: widget.orderId,
              serviceId: widget.serviceId,
              reviewMessage: reviewMessage,
              rating: _rating,
            );

            if (response.statusCode == 200) {
              final responseData = jsonDecode(response.body);
              showCustomSnackBar(
                  context, responseData['message'], Colors.green);
              Navigator.pop(context);
            } else {
              final responseData = jsonDecode(response.body);
              showCustomSnackBar(context, responseData['message'], Colors.red);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
