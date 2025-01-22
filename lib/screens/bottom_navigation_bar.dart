import 'package:e_commerce/providers/bottom_navigation/navigation_provider.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/screens/orders/orders_screen.dart';
import 'package:e_commerce/screens/profile/profile_screen.dart';
import 'package:e_commerce/screens/service/service_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarScreen extends StatelessWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          navigationProvider.updateIndex(index); // Update index and animate
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.category),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            label: 'Profile',
          ),
        ],
      ),
      body: PageView(
        controller: navigationProvider.pageController,
        onPageChanged: (index) {
          navigationProvider.updateIndex(index); // Sync index with PageView
        },
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe if needed
        children: const [
          HomeScreen(),
          ServiceScreen(),
          OrdersScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
