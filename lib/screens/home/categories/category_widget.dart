import 'package:carded/carded.dart';
import 'package:e_commerce/models/category/category.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return CardyContainer(
      width: 200,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 1, bottom: 1, right: 10, left: 1),
      color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
      spreadRadius: 0,
      blurRadius: 1,
      shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.title ?? "No Title",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            category.description ?? "No Description",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
