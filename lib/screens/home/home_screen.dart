import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/tab_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_image.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/section_header.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _search = '';

  static const _tiles = <_CategoryTile>[
    _CategoryTile('Football Boots', 'Shoes', 'assets/images/products/p1_a.png'),
    _CategoryTile('Jerseys', 'Jerseys', 'assets/images/products/p9_a.png'),
    _CategoryTile('Footballs', 'Footballs', 'assets/images/products/p3_a.png'),
    _CategoryTile('Accessories', 'Accessories', 'assets/images/products/p7_a.png'),
    _CategoryTile('Training Equipment', 'Accessories', 'assets/images/products/p8_a.png'),
  ];

  void _goToProducts({String? category, String? query}) {
    final products = context.read<ProductsProvider>();
    products.resetFilters();
    products.setCategory(category ?? 'All');
    products.setQuery(query ?? '');
    context.read<TabProvider>().setIndex(1);
  }

  void _showNotifications() {
    final enabled = context.read<SettingsProvider>().notificationsEnabled;
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            if (!enabled)
              const Text(
                'Notifications are turned off. You can enable them from Profile > Settings.',
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              ...const [
                _NotificationRow(Icons.local_shipping_outlined,
                    'Free shipping on orders over \$50'),
                _NotificationRow(Icons.new_releases_outlined,
                    'New arrivals just landed - check them out'),
                _NotificationRow(Icons.local_offer_outlined,
                    'Boots & jerseys are on sale this week'),
              ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = context.select<AuthProvider, String>(
      (a) => a.currentUser.name.split(' ').first,
    );
    final cartCount = context.select<CartProvider, int>((c) => c.count);
    final products = context.read<ProductsProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ---- header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Image.asset(AppConstants.logo, height: 26),
                const Spacer(),
                _IconBadge(
                  icon: Icons.notifications_none_rounded,
                  onTap: _showNotifications,
                  showDot: context.select<SettingsProvider, bool>(
                    (s) => s.notificationsEnabled,
                  ),
                ),
                const SizedBox(width: 10),
                _IconBadge(
                  icon: Icons.shopping_bag_outlined,
                  count: cartCount,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u0645\u0631\u062d\u0628\u0627\u064b\u060c $name',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Ready to gear up today?',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // ---- search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SportixSearchBar(
              value: _search,
              onChanged: (v) => setState(() => _search = v),
              onSubmitted: (v) {
                if (v.trim().isEmpty) return;
                _goToProducts(query: v.trim());
                setState(() => _search = '');
              },
            ),
          ),
          const SizedBox(height: 20),
          // ---- banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 190,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(AppConstants.homeBanner, fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xCC101318), Color(0x00101318)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 170,
                            child: Text(
                              'READY FOR THE NEXT MATCH?',
                              style: TextStyle(
                                fontSize: 20,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: () => _goToProducts(),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(130, 42),
                            ),
                            child: const Text('SHOP NOW'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // ---- categories
          const SectionHeader(title: 'Categories'),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _tiles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final t = _tiles[i];
                return GestureDetector(
                  onTap: () => _goToProducts(category: t.category),
                  child: SizedBox(
                    width: 78,
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(19),
                            child: ProductImage(t.image),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // ---- best sellers
          SectionHeader(title: 'Best Sellers', onSeeAll: () => _goToProducts()),
          _ProductRow(products: products.bestSellers, heroPrefix: 'best'),
          const SizedBox(height: 24),
          // ---- new arrivals
          SectionHeader(title: 'New Arrivals', onSeeAll: () => _goToProducts()),
          _ProductRow(products: products.newArrivals, heroPrefix: 'new'),
        ],
      ),
    );
  }
}

class _CategoryTile {
  const _CategoryTile(this.label, this.category, this.image);
  final String label;
  final String category;
  final String image;
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.products, required this.heroPrefix});

  final List<Product> products;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 258,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => SizedBox(
          width: 168,
          child: ProductCard(product: products[i], heroPrefix: heroPrefix),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.onTap,
    this.count = 0,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final int count;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else if (showDot)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.orangeSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
