import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/app_snack.dart';
import '../../widgets/product_image.dart';
import '../../widgets/rating_stars.dart';
import '../cart/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.heroTag,
  });

  final Product product;
  final String heroTag;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _page = 0;
  late String _color;
  String? _size;
  int _quantity = 1;

  Product get p => widget.product;

  @override
  void initState() {
    super.initState();
    _color = p.colors.first;
    if (p.sizes.length == 1) _size = p.sizes.first;
  }

  void _addToCart() {
    if (_size == null) {
      showAppSnack(context, 'Please select a size first', error: true);
      return;
    }
    context.read<CartProvider>().add(p, _color, _size!, _quantity);
    showAppSnack(
      context,
      'Added to cart successfully',
      action: SnackBarAction(
        label: 'VIEW CART',
        textColor: AppColors.orange,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CartScreen()),
        ),
      ),
    );
  }

  void _changeQuantity(int delta) {
    final next = _quantity + delta;
    if (next < 1) return;
    if (next > AppConstants.maxQuantity) {
      showAppSnack(
        context,
        'Maximum quantity is ${AppConstants.maxQuantity}',
        error: true,
      );
      return;
    }
    setState(() => _quantity = next);
  }

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritesProvider, bool>(
      (f) => f.isFavorite(p.id),
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- gallery
                  SizedBox(
                    height: 360,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          PageView.builder(
                            itemCount: p.images.length,
                            onPageChanged: (i) => setState(() => _page = i),
                            itemBuilder: (_, i) {
                              final img = ProductImage(p.images[i]);
                              return i == 0
                                  ? Hero(tag: widget.heroTag, child: img)
                                  : img;
                            },
                          ),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _CircleButton(
                                    icon: Icons.arrow_back_ios_new_rounded,
                                    onTap: () => Navigator.of(context).pop(),
                                  ),
                                  _CircleButton(
                                    icon: isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? AppColors.orange : Colors.white,
                                    onTap: () {
                                      final added = context
                                          .read<FavoritesProvider>()
                                          .toggle(p.id);
                                      showAppSnack(
                                        context,
                                        added
                                            ? 'Added to favorites'
                                            : 'Removed from favorites',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (p.images.length > 1)
                            Positioned(
                              bottom: 14,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(p.images.length, (i) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    width: _page == i ? 22 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _page == i
                                          ? AppColors.orange
                                          : AppColors.textSecondary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                }),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.brand.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            RatingStars(rating: p.rating),
                            const SizedBox(width: 8),
                            Text(
                              '${p.rating} / 5',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${p.reviews} reviews)',
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${p.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.orange,
                              ),
                            ),
                            if (p.isSale) ...[
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '\$${p.oldPrice!.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.orangeSoft,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '-${p.discountPercent}%',
                                  style: const TextStyle(
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 22),
                        const _Label('Description'),
                        const SizedBox(height: 8),
                        Text(
                          p.description,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _Label('Color: $_color'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            for (final c in p.colors)
                              GestureDetector(
                                onTap: () => setState(() => _color = c),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _color == c
                                          ? AppColors.orange
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: AppColors.fromName(c),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.border),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _Label('Size${_size == null ? '' : ': $_size'}'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final s in p.sizes)
                              GestureDetector(
                                onTap: () => setState(() => _size = s),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  constraints: const BoxConstraints(minWidth: 52),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _size == s
                                        ? AppColors.orange
                                        : AppColors.card,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _size == s
                                          ? AppColors.orange
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Text(
                                    s,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: _size == s
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const _Label('Quantity'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove,
                              onTap: () => _changeQuantity(-1),
                            ),
                            SizedBox(
                              width: 56,
                              child: Text(
                                '$_quantity',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add,
                              onTap: () => _changeQuantity(1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          14 + MediaQuery.of(context).viewPadding.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                Text(
                  '\$${(p.price * _quantity).toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      );
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: AppColors.scrim,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
