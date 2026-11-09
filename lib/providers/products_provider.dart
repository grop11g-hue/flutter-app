import 'package:flutter/foundation.dart';

import '../data/products_data.dart';
import '../models/product.dart';

enum SortOption { featured, priceLow, priceHigh, rating, newest }

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.featured:
        return 'Featured';
      case SortOption.priceLow:
        return 'Price: Low to High';
      case SortOption.priceHigh:
        return 'Price: High to Low';
      case SortOption.rating:
        return 'Top Rated';
      case SortOption.newest:
        return 'Newest';
    }
  }
}

/// Holds the search / category / filter / sort state of the Products screen.
class ProductsProvider extends ChangeNotifier {
  static const double priceCeiling = 60;

  String _query = '';
  String _category = 'All';
  SortOption _sort = SortOption.featured;
  double _maxPrice = priceCeiling;
  double _minRating = 0;
  bool _onlySale = false;

  String get query => _query;
  String get category => _category;
  SortOption get sort => _sort;
  double get maxPrice => _maxPrice;
  double get minRating => _minRating;
  bool get onlySale => _onlySale;

  bool get hasActiveFilters =>
      _maxPrice < priceCeiling || _minRating > 0 || _onlySale;

  bool get hasAnyCriteria =>
      hasActiveFilters || _query.isNotEmpty || _category != 'All';

  List<Product> get results {
    final q = _query.trim().toLowerCase();
    final list = ProductsData.all.where((p) {
      if (_category != 'All' && p.category != _category) return false;
      if (q.isNotEmpty) {
        final haystack = '${p.name} ${p.brand} ${p.category}'.toLowerCase();
        if (!haystack.contains(q)) return false;
      }
      if (p.price > _maxPrice) return false;
      if (p.rating < _minRating) return false;
      if (_onlySale && !p.isSale) return false;
      return true;
    }).toList();

    switch (_sort) {
      case SortOption.featured:
        break;
      case SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.newest:
        list.sort((a, b) {
          if (a.isNew == b.isNew) return 0;
          return a.isNew ? -1 : 1;
        });
        break;
    }
    return list;
  }

  List<Product> get bestSellers {
    final list = List<Product>.from(ProductsData.all)
      ..sort((a, b) => b.sold.compareTo(a.sold));
    return list.take(6).toList();
  }

  List<Product> get newArrivals =>
      ProductsData.all.where((p) => p.isNew).toList();

  void setQuery(String value) {
    if (value == _query) return;
    _query = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void setSort(SortOption value) {
    _sort = value;
    notifyListeners();
  }

  void applyFilters({
    required double maxPrice,
    required double minRating,
    required bool onlySale,
  }) {
    _maxPrice = maxPrice;
    _minRating = minRating;
    _onlySale = onlySale;
    notifyListeners();
  }

  void resetFilters() {
    _maxPrice = priceCeiling;
    _minRating = 0;
    _onlySale = false;
    notifyListeners();
  }

  void resetAll() {
    _query = '';
    _category = 'All';
    _sort = SortOption.featured;
    resetFilters();
  }
}
