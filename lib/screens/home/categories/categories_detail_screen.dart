import 'package:carded/carded.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/providers/category/category_provider.dart';
import 'package:e_commerce/screens/home/categories/category_widget.dart';
import 'package:e_commerce/screens/service/service_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesDetailScreen extends StatefulWidget {
  const CategoriesDetailScreen({super.key});

  @override
  State<CategoriesDetailScreen> createState() => _CategoriesDetailScreenState();
}

class _CategoriesDetailScreenState extends State<CategoriesDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).resetCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View All Categories",
          style: TextStyle(fontSize: 18),
        ),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    if (categoryProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (categoryProvider.errorMessage != null) {
                      return Center(
                        child: Text(categoryProvider.errorMessage!),
                      );
                    }
                    if (categoryProvider.filteredCategories.isEmpty) {
                      return const SizedBox(
                        height: 120,
                        child: Center(
                          child: Text("No categories available"),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children:
                            categoryProvider.filteredCategories.map((category) {
                          return Column(
                            children: [
                              GestureDetector(
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
                                  padding: const EdgeInsets.all(16),
                                  color: isDarkMode
                                      ? AppTheme.fdarkBlue
                                      : Colors.white,
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  shadowColor: isDarkMode
                                      ? AppTheme.fdarkBlue
                                      : Colors.grey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        category.description ??
                                            "No Description",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: 10), // Adds space between items
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
