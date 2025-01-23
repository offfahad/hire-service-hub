import 'package:cached_network_image/cached_network_image.dart';
import 'package:carded/carded.dart';
import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ReviewWidget extends StatelessWidget {
  final Review review;

  const ReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return CardyContainer(
      borderRadius: BorderRadius.circular(10),
      spreadRadius: 0,
      blurRadius: 1,
      shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
      margin: const EdgeInsets.only(right: 8.0, top: 1, bottom: 1, left: 1),
      color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: 250, // Adjust the width to fit your design
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture and name with date
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode
                          ? AppTheme.fMainColor
                          : Colors.grey.shade300,
                    ),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          review.reviewer.profilePicture),
                      radius: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reviewer Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < int.parse(review.rating.toString())
                                ? IconlyBold.star
                                : IconlyLight.star,
                            color:
                                Colors.amber, // Use purple color for the stars
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 2,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            review.reviewer.firstName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            formatDate(review.addedAt.toString()),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                      // Review Date
                    ],
                  ),
                ],
              ),
              // Rating Stars
              const SizedBox(height: 10),
              // Review Text
              Text(
                review.reviewMessage,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
