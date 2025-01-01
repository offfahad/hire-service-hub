import 'package:carded/carded.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/models/category/category.dart';
import 'package:e_commerce/screens/service/service_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final double? width; // Optional parameter with default value of null
  final double? rightPadding;

  const CategoryItem({
    super.key,
    required this.category,
    this.width, // Accepts width as an optional parameter
    this.rightPadding,
  });

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    // Use the provided width, or default to 200 if none is passed
    double itemWidth = width ?? 200.0;
    double rightPaddingValue = rightPadding ?? 10;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SlidePageRoute(
            page: ServiceScreen(
              categoryModel: category,
            ),
          ),
        );
      },
      child: CardyContainer(
        width: itemWidth, // Set the width dynamically
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(
            top: 1, bottom: 1, right: rightPaddingValue, left: 1),
        color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
        spreadRadius: 0,
        blurRadius: 1,
        borderRadius: BorderRadius.circular(16),
        shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.title ?? "No Title",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              category.description ?? "No Description",
              style: const TextStyle(
                fontSize: 12,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
