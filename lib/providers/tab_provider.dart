import 'package:flutter/foundation.dart';

/// Index of the active bottom-navigation tab:
/// 0 Home, 1 Products, 2 Favorites, 3 Profile.
class TabProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int value) {
    if (value == _index) return;
    _index = value;
    notifyListeners();
  }
}
