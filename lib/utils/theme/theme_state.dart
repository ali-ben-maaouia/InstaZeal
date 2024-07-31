import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  String currentPage = 'Home'; // Page actuellement affichée
  bool _isDark = false;
  bool isHomeSelected = true;
  bool isSearchSelected = false;
  bool isReelsSelected = false;
  bool isProfileSelected = false;

  bool isAddPostSelected = false;
  swap() {
    if (_isDark) {
      _isDark = false;
    } else {
      _isDark = true;
    }
    notifyListeners();
  }

  bool get themeMode => _isDark;

  void updateNavigation(String pageName) {
    currentPage = pageName;
    isHomeSelected = pageName == 'Home';
    isSearchSelected = pageName == 'Search';
    isReelsSelected = pageName == 'Reels';
    isProfileSelected = pageName == 'Profile';
    isAddPostSelected = pageName == 'post';
    notifyListeners();
  }
}
