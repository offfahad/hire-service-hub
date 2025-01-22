import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  late PageController _pageController;

  NavigationProvider() {
    _pageController = PageController(initialPage: _currentIndex);
  }

  int get currentIndex => _currentIndex;

  PageController get pageController => _pageController;

  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
    if ((_pageController.page ?? 0).toInt() == newIndex) {
      return; // If already on the desired page, do nothing
    }

    // If the distance between the current and new index is greater than 1, jump directly
    if ((newIndex - _pageController.page!).abs() > 1) {
      _pageController.jumpToPage(newIndex);
    } else {
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
