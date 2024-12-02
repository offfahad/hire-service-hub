import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/screens/cart/cart_screen.dart';
import 'package:e_commerce/screens/service/service_screen.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/screens/profile/profile_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    const CartScreen(),
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
    return Consumer<AuthenticationProvider>(
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
              BottomNavigationBarItem(
                // icon: SvgPicture.asset(
                //   'assets/icons/favorite.svg',
                //   color: (currentPageIndex == 1)
                //       ? AppTheme.fMainColor
                //       : Colors.grey,
                //   height: MediaQuery.of(context).size.height * 0.035,
                //   width: MediaQuery.of(context).size.height * 0.035,
                // ),
                icon: const Icon(IconlyLight.category),
                label: authProvider.user!.role!.title == "service_provider"
                    ? "My Service"
                    : "Service",
              ),
              const BottomNavigationBarItem(
                // icon: SvgPicture.asset(
                //   'assets/icons/cart.svg',
                //   color: (currentPageIndex == 2)
                //       ? AppTheme.fMainColor
                //       : Colors.grey,
                //   height: MediaQuery.of(context).size.height * 0.035,
                //   width: MediaQuery.of(context).size.height * 0.035,
                // ),
                icon: Icon(IconlyLight.bag),
                label: 'Orders',
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
    );
  }
}
