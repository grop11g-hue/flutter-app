import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/products_data.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  static const _key = 'cart_items';
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get count => _items.fold(0, (sum, i) => sum + i.quantity);
  double get total => _items.fold(0.0, (sum, i) => sum + i.lineTotal);

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      for (final entry in list) {
        final map = entry as Map<String, dynamic>;
        final product = ProductsData.byId(map['productId'] as String);
        if (product == null) continue;
        _items.add(CartItem(
          product: product,
          color: map['color'] as String,
          size: map['size'] as String,
          quantity: map['quantity'] as int,
        ));
      }
    } catch (_) {
      _items.clear();
    }
  }

  void add(Product product, String color, String size, int quantity) {
    final key = '${product.id}|$color|$size';
    final index = _items.indexWhere((i) => i.key == key);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        color: color,
        size: size,
        quantity: quantity,
      ));
    }
    _save();
    notifyListeners();
  }

  void changeQuantity(CartItem item, int delta) {
    item.quantity += delta;
    if (item.quantity <= 0) {
      _items.remove(item);
    }
    _save();
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    _save();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _save();
    notifyListeners();
  }

  void _save() {
    _prefs.setString(_key, jsonEncode(_items.map((i) => i.toJson()).toList()));
  }
}
