// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/reviews/reviews_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ReviewDetailsScreen extends StatelessWidget {
  final Review review;

  const ReviewDetailsScreen({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    bool isMyReview = authProvider.user?.id == review.reviewerId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Details'),
        actions: [
          if (isMyReview)
            Consumer<ReviewsProvider>(builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(IconlyBold.delete),
                onPressed: () {
                  // Show confirmation dialog before deleting
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Review'),
                      content: const Text(
                          'Are you sure you want to delete this review?'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context), // Close the dialog
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final response =
                                await provider.deleteReview(review.id);
                            final responseData = jsonDecode(response.body);
                            if (response.statusCode == 200) {
                              showCustomSnackBar(context,
                                  responseData["message"], Colors.green);
                              Navigator.pop(context); // Close the dialog
                              await serviceProvider
                                  .fetchSingleServiceDetail(review.serviceId);
                              Navigator.pop(
                                  context); // Close the screen after deletion
                            } else {
                              showCustomSnackBar(
                                  context, responseData["message"], Colors.red);
                              Navigator.pop(
                                  context); // Close the screen after deletion
                            }
                          },
                          child: provider.isLoading
                              ? const CircularProgressIndicator.adaptive()
                              : const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(review.reviewer.profilePicture),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${review.reviewer.firstName} ${review.reviewer.lastName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      formatDateAndTime(review.addedAt),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < int.parse(review.rating.toString())
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 24,
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              review.reviewMessage,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
