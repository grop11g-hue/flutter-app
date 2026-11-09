import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  static const _key = 'orders';
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      _orders.addAll(
        list.map((e) => Order.fromJson(e as Map<String, dynamic>)),
      );
    } catch (_) {
      _orders.clear();
    }
  }

  Order place(List<CartItem> items, double total) {
    final now = DateTime.now();
    final order = Order(
      id: 'SPX-${(now.millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
      date: now,
      total: total,
      itemCount: items.fold(0, (s, i) => s + i.quantity),
      lines: items
          .map((i) => '${i.quantity}x ${i.product.name} (${i.color}, ${i.size})')
          .toList(),
    );
    _orders.insert(0, order);
    _save();
    notifyListeners();
    return order;
  }

  void clear() {
    _orders.clear();
    _save();
    notifyListeners();
  }

  void _save() {
    _prefs.setString(_key, jsonEncode(_orders.map((o) => o.toJson()).toList()));
  }
}
