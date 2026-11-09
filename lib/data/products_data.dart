import '../models/product.dart';

/// Local demo catalogue (no backend needed).
class ProductsData {
  ProductsData._();

  static const List<String> _boots = ['40', '41', '42', '43', '44'];
  static const List<String> _clothes = ['S', 'M', 'L', 'XL'];

  static const List<Product> all = [
    Product(
      id: 'p1',
      name: 'Adidas X Speedportal Boots',
      brand: 'Adidas',
      category: 'Shoes',
      description:
          'Ultra-light speed boots with a metallic finish and a responsive '
          'traction plate. Built for explosive acceleration and sharp cuts '
          'on firm-ground pitches.',
      images: ['assets/images/products/p1_a.png', 'assets/images/products/p1_b.png'],
      price: 45,
      oldPrice: 60,
      rating: 4.8,
      reviews: 124,
      colors: ['Yellow', 'White'],
      sizes: _boots,
      sold: 320,
    ),
    Product(
      id: 'p2',
      name: 'Adidas Predator Football Boots',
      brand: 'Adidas',
      category: 'Shoes',
      description:
          'Precision-control boots with a textured strike zone for accurate '
          'passing and shooting. Sock-like fit and durable outsole for '
          'training and match day.',
      images: ['assets/images/products/p2_a.png', 'assets/images/products/p2_b.png'],
      price: 52,
      rating: 4.7,
      reviews: 98,
      colors: ['Black', 'Red'],
      sizes: _boots,
      isNew: true,
      sold: 210,
    ),
    Product(
      id: 'p3',
      name: 'Adidas Official Match Ball',
      brand: 'Adidas',
      category: 'Footballs',
      description:
          'Match-quality football with a seamless textured surface for true '
          'flight and excellent touch. Designed for professional play.',
      images: ['assets/images/products/p3_a.png', 'assets/images/products/p3_b.png'],
      price: 25,
      oldPrice: 32,
      rating: 4.6,
      reviews: 210,
      colors: ['White', 'Red'],
      sizes: ['Size 5'],
      sold: 450,
    ),
    Product(
      id: 'p4',
      name: 'Nike Sports T-Shirt',
      brand: 'Nike',
      category: 'Jerseys',
      description:
          'Breathable moisture-wicking tee with an athletic fit. Soft '
          'lightweight fabric keeps you cool during intense training.',
      images: ['assets/images/products/p4_a.png', 'assets/images/products/p4_b.png'],
      price: 30,
      rating: 4.5,
      reviews: 85,
      colors: ['Red', 'Black'],
      sizes: _clothes,
      isNew: true,
      sold: 180,
    ),
    Product(
      id: 'p5',
      name: 'Goalkeeper Gloves',
      brand: 'SPORTIX',
      category: 'Gloves',
      description:
          'Pro-grip latex palm with finger protection and an adjustable wrist '
          'strap for a secure fit. Confidence for every save.',
      images: ['assets/images/products/p5_a.png', 'assets/images/products/p5_b.png'],
      price: 22,
      rating: 4.4,
      reviews: 67,
      colors: ['Black', 'Red'],
      sizes: ['7', '8', '9', '10'],
      sold: 140,
    ),
    Product(
      id: 'p6',
      name: 'Sports Drawstring Bag',
      brand: 'SPORTIX',
      category: 'Accessories',
      description:
          'Lightweight water-resistant drawstring bag for boots, kit and '
          'gear. Easy to carry to every session.',
      images: ['assets/images/products/p6_a.png', 'assets/images/products/p6_b.png'],
      price: 15,
      oldPrice: 20,
      rating: 4.6,
      reviews: 73,
      colors: ['Black', 'Purple'],
      sizes: ['One Size'],
      sold: 95,
    ),
    Product(
      id: 'p7',
      name: 'Grip Football Socks',
      brand: 'SPORTIX',
      category: 'Accessories',
      description:
          'Crew socks with anti-slip grip pads for better stability inside '
          'your boots. Cushioned sole and breathable fabric.',
      images: ['assets/images/products/p7_a.png', 'assets/images/products/p7_b.png'],
      price: 8,
      rating: 4.3,
      reviews: 54,
      colors: ['Yellow', 'Black', 'Blue', 'Red', 'White'],
      sizes: ['M', 'L'],
      isNew: true,
      sold: 260,
    ),
    Product(
      id: 'p8',
      name: 'Agility Training Set',
      brand: 'SPORTIX',
      category: 'Accessories',
      description:
          'Complete training kit with agility ladder, cones, hurdles and a '
          'carry bag. Perfect for speed, footwork and coordination drills.',
      images: ['assets/images/products/p8_a.png', 'assets/images/products/p8_b.png'],
      price: 29,
      rating: 4.2,
      reviews: 41,
      colors: ['Orange', 'Yellow'],
      sizes: ['One Size'],
      sold: 120,
    ),
    Product(
      id: 'p9',
      name: 'Pro Match Kit',
      brand: 'SPORTIX',
      category: 'Jerseys',
      description:
          'Premium match kit with a bold modern print and ultra-light fabric. '
          'Excellent stretch and airflow for 90 minutes of play.',
      images: ['assets/images/products/p9_a.png', 'assets/images/products/p9_b.png'],
      price: 34,
      oldPrice: 40,
      rating: 4.7,
      reviews: 112,
      colors: ['Yellow', 'Black'],
      sizes: _clothes,
      sold: 205,
    ),
    Product(
      id: 'p10',
      name: 'Champions League Ball',
      brand: 'Adidas',
      category: 'Footballs',
      description:
          'Premium match ball with a star-panel design and a durable cover. '
          'Consistent bounce and responsive touch in any light.',
      images: ['assets/images/products/p10_a.png', 'assets/images/products/p10_b.png'],
      price: 30,
      rating: 4.3,
      reviews: 77,
      colors: ['White', 'Black'],
      sizes: ['Size 4', 'Size 5'],
      isNew: true,
      sold: 150,
    ),
  ];

  static Product? byId(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }
}
