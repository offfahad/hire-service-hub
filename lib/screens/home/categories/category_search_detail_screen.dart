import 'package:carded/carded.dart';
import 'package:e_commerce/screens/home/categories/category_list_widget.dart';
import 'package:e_commerce/screens/home/categories/category_widget.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../providers/category/category_provider.dart';

class CategorySearchDetailScreen extends StatefulWidget {
  const CategorySearchDetailScreen({super.key});

  @override
  State<CategorySearchDetailScreen> createState() =>
      _CategorySearchDetailScreenState();
}

class _CategorySearchDetailScreenState
    extends State<CategorySearchDetailScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).resetCategories();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CardyContainer(
                      borderRadius: BorderRadius.circular(15),
                      color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
                      spreadRadius: 0,
                      blurRadius: 1,
                      height: 45,
                      shadowColor:
                          isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(IconlyLight.arrow_left_2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 12,
                    child: CardyContainer(
                      borderRadius: BorderRadius.circular(15),
                      color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
                      spreadRadius: 0,
                      blurRadius: 1,
                      shadowColor:
                          isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
                      height: 45,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(IconlyLight.search, color: Colors.grey),
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                Provider.of<CategoryProvider>(context,
                                        listen: false)
                                    .searchCategories(value);
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Consumer<CategoryProvider>(
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryProvider.filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category =
                          categoryProvider.filteredCategories[index];
                      return CategoryListItem(category: category);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
