import 'package:e_commerce/providers/service/service_filter_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void openFilterBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  required Function(String?) onSelect,
  required VoidCallback onReset,
}) {
  Brightness brightness = Theme.of(context).brightness;
  bool isDarkMode = brightness == Brightness.dark;

  showModalBottomSheet(
    backgroundColor: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: onReset,
                      child: const Text(
                        "Reset",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(options[index]),
                        leading: Radio<String>(
                          value: options[index],
                          groupValue: Provider.of<FilterProvider>(context)
                              .selectedFilters[title],
                          onChanged: onSelect,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
