import 'package:carded/carded.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/providers/category/category_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/home/categories/categories_detail_screen.dart';
import 'package:e_commerce/screens/home/categories/category_widget.dart';
import 'package:e_commerce/screens/home/services/small_service_card_widget.dart';
import 'package:e_commerce/screens/service/service_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconly/iconly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> images = [
    'assets/bg/bg-hero1.webp',
    'assets/bg/bg-hero2.webp',
    'assets/bg/bg-hero3.webp',
    'assets/bg/bg-hero4.webp',
    'assets/bg/bg-hero5.webp',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).clearServicesList();
      Provider.of<CategoryProvider>(context, listen: false).resetCategories();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<ServiceProvider>(context, listen: false).fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final screenHeight = MediaQuery.of(context).size.height;
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        forceMaterialTransparency: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Badge(
                    smallSize: 8,
                    child: Icon(IconlyLight.message),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {},
                  child: const Badge(
                    smallSize: 8,
                    child: Icon(IconlyLight.notification),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel Section
              SizedBox(
                height: screenHeight * 0.25,
                child: Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: screenHeight * 0.25,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        enlargeCenterPage: false,
                      ),
                      items: images.map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 120,
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Find the perfect ",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: "freelancers",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: "\nservices for your business",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Search Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CardyContainer(
                  color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
                  spreadRadius: 0,
                  blurRadius: 1,
                  shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
                  height: 50,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.search, color: Colors.grey),
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
                            hintText: 'Search by passing Category title',
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final query = searchController.text.trim();
                          Provider.of<CategoryProvider>(context, listen: false)
                              .searchCategories(query);
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 28, 110, 30),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Popular Categories",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlidePageRoute(
                            page: const CategoriesDetailScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "View All",
                        style:
                            TextStyle(fontSize: 16, color: AppTheme.fMainColor),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            categoryProvider.filteredCategories.map((category) {
                          return CategoryItem(category: category);
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),

              // Services Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Popular Services",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlidePageRoute(
                            page: const ServiceScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "View All",
                        style:
                            TextStyle(fontSize: 16, color: AppTheme.fMainColor),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Consumer<ServiceProvider>(
                  builder: (context, serviceProvider, child) {
                    if (serviceProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (serviceProvider.errorMessage != null &&
                        serviceProvider.services.isEmpty) {
                      return Center(
                        child: Text(serviceProvider.errorMessage!),
                      );
                    }

                    if (serviceProvider.services.isEmpty) {
                      return const SizedBox(
                        height: 120,
                        child: Center(
                          child: Text("No services available"),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio: 3.2 / 4,
                      ),
                      itemCount: serviceProvider.services.length > 4
                          ? 4
                          : serviceProvider.services.length,
                      itemBuilder: (context, index) {
                        return SmallServiceCard(
                          service: serviceProvider.services[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
