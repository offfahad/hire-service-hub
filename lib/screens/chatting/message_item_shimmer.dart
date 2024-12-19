import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MessageItemShimmer extends StatelessWidget {
  const MessageItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define shimmer colors for dark mode
    final darkBaseColor = AppTheme.fdarkBlue.withOpacity(0.7);
    final darkHighlightColor = AppTheme.fMainColor.withOpacity(0.5);
    final darkBackgroundColor = AppTheme.fdarkBlue.withOpacity(0.9);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: isDarkMode ? darkBackgroundColor : Theme.of(context).cardColor,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Shimmer effect for the avatar
              Shimmer.fromColors(
                baseColor: isDarkMode ? darkBaseColor : Colors.grey[300]!,
                highlightColor:
                    isDarkMode ? darkHighlightColor : Colors.grey[100]!,
                child: CircleAvatar(
                  backgroundColor:
                      isDarkMode ? darkBaseColor : Colors.grey[300]!,
                  radius: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Message content shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: isDarkMode ? darkBaseColor : Colors.grey[300]!,
                      highlightColor:
                          isDarkMode ? darkHighlightColor : Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        color: isDarkMode ? darkBaseColor : Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Shimmer.fromColors(
                      baseColor: isDarkMode ? darkBaseColor : Colors.grey[300]!,
                      highlightColor:
                          isDarkMode ? darkHighlightColor : Colors.grey[100]!,
                      child: Container(
                        height: 14,
                        color: isDarkMode ? darkBaseColor : Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
              // Time shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: isDarkMode ? darkBaseColor : Colors.grey[300]!,
                      highlightColor:
                          isDarkMode ? darkHighlightColor : Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        width: 40,
                        color: isDarkMode ? darkBaseColor : Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Shimmer.fromColors(
                      baseColor: isDarkMode ? darkBaseColor : Colors.grey[300]!,
                      highlightColor:
                          isDarkMode ? darkHighlightColor : Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        width: 30,
                        color: isDarkMode ? darkBaseColor : Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
