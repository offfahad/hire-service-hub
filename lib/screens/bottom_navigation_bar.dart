import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/bottom_navigation/navigation_provider.dart';
import 'package:e_commerce/providers/notifications_count/notification_badge_provider.dart';
import 'package:e_commerce/screens/home/home_screen.dart';
import 'package:e_commerce/screens/orders/orders_screen.dart';
import 'package:e_commerce/screens/profile/profile_screen.dart';
import 'package:e_commerce/screens/service/service_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class BottomNavigationBarScreen extends StatelessWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final orderBadgeCount = context
        .watch<NotificationBadgeProvider>()
        .getNotificationCount('order');

    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationProvider.currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) async {
            if (index == 2) {
              await context
                  .read<NotificationBadgeProvider>()
                  .resetCount('order');
            }
            navigationProvider.updateIndex(index); // Update index and animate
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(IconlyLight.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(IconlyLight.category),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: orderBadgeCount > 0
                  ? badges.Badge(
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: AppTheme.fMainColor,
                      ),
                      badgeContent: Text(
                        orderBadgeCount.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      child: const Icon(IconlyLight.bag),
                    )
                  : const Icon(IconlyLight.bag),
              label: authProvider.user?.role?.title == "service_provider"
                  ? 'Orders'
                  : 'My Orders',
            ),
            const BottomNavigationBarItem(
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
    });
  }
}
