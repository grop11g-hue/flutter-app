class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final List<String> images;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviews;
  final List<String> colors;
  final List<String> sizes;
  final bool isNew;
  final int sold;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.images,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.colors,
    required this.sizes,
    this.isNew = false,
    this.sold = 0,
  });

  bool get isSale => oldPrice != null && oldPrice! > price;

  String get image => images.first;

  int get discountPercent =>
      isSale ? (((oldPrice! - price) / oldPrice!) * 100).round() : 0;
}
