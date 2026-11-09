import 'product.dart';

class CartItem {
  final Product product;
  final String color;
  final String size;
  int quantity;

  CartItem({
    required this.product,
    required this.color,
    required this.size,
    required this.quantity,
  });

  String get key => '${product.id}|$color|$size';

  double get lineTotal => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': product.id,
        'color': color,
        'size': size,
        'quantity': quantity,
      };
}
