import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/screens/orders/orders_screen.dart';
import 'package:e_commerce/screens/service/service_screen.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/screens/profile/profile_screen.dart';
import 'package:e_commerce/utils/network_observer_provider.dart.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({
    super.key,
  });

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // List of screens for the bottom navigation bar
  final List<Widget> pages = [
    const HomeScreen(),
    const ServiceScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  void onPageChanged(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  void onBottomNavTapped(int index) {
    setState(() {
      currentPageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300), // Set animation duration
        curve: Curves.easeInOut, // Set animation curve
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderNetworkObserver(
      child: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentPageIndex,
              type: BottomNavigationBarType.fixed, // Prevents icon shifting
              selectedLabelStyle: const TextStyle(
                fontSize: 12, // Set the font size for the selected label
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 10, // Set the font size for the unselected label
              ),
              onTap: onBottomNavTapped,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  // icon: SvgPicture.asset(
                  //   'assets/icons/house.svg',
                  //   color: (currentPageIndex == 0)
                  //       ? AppTheme.fMainColor
                  //       : Colors.grey,
                  //   height: MediaQuery.of(context).size.height * 0.035,
                  //   width: MediaQuery.of(context).size.height * 0.035,
                  // ),
                  icon: Icon(IconlyLight.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  // icon: SvgPicture.asset(
                  //   'assets/icons/favorite.svg',
                  //   color: (currentPageIndex == 1)
                  //       ? AppTheme.fMainColor
                  //       : Colors.grey,
                  //   height: MediaQuery.of(context).size.height * 0.035,
                  //   width: MediaQuery.of(context).size.height * 0.035,
                  // ),
                  icon: Icon(IconlyLight.category),
                  label: "Services",
                  //label: "Services"
                ),
                BottomNavigationBarItem(
                  // icon: SvgPicture.asset(
                  //   'assets/icons/cart.svg',
                  //   color: (currentPageIndex == 2)
                  //       ? AppTheme.fMainColor
                  //       : Colors.grey,
                  //   height: MediaQuery.of(context).size.height * 0.035,
                  //   width: MediaQuery.of(context).size.height * 0.035,
                  // ),
                  icon: const Icon(IconlyLight.bag),
                  label: authProvider.user!.role!.title == "service_provider"
                      ? "My Orders"
                      : "Placed Orders",
                ),
                const BottomNavigationBarItem(
                  // icon: SvgPicture.asset(
                  //   'assets/icons/profile.svg',
                  //   color: (currentPageIndex == 3)
                  //       ? AppTheme.fMainColor
                  //       : Colors.grey,
                  //   height: MediaQuery.of(context).size.height * 0.035,
                  //   width: MediaQuery.of(context).size.height * 0.035,
                  // ),
                  icon: Icon(IconlyLight.profile),
                  label: 'Profile',
                ),
              ],
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: pages, // Disable swipe if needed
            ),
          );
        },
      ),
    );
  }
}
