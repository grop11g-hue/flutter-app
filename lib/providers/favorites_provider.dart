import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/products_data.dart';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._prefs) {
    _ids.addAll(_prefs.getStringList(_key) ?? const <String>[]);
  }

  final SharedPreferences _prefs;
  static const _key = 'favorites';
  final Set<String> _ids = <String>{};

  int get count => _ids.length;

  bool isFavorite(String id) => _ids.contains(id);

  List<Product> get products =>
      ProductsData.all.where((p) => _ids.contains(p.id)).toList();

  /// Returns true when the product was added, false when it was removed.
  bool toggle(String id) {
    final added = _ids.add(id);
    if (!added) _ids.remove(id);
    _save();
    notifyListeners();
    return added;
  }

  void clear() {
    _ids.clear();
    _save();
    notifyListeners();
  }

  void _save() => _prefs.setStringList(_key, _ids.toList());
}
