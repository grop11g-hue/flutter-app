import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/tab_provider.dart';
import '../../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<FavoritesProvider>().products;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                const Text('Favorites',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('${items.length} items',
                    style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite_border,
                              size: 64, color: AppColors.textSecondary),
                          const SizedBox(height: 12),
                          const Text('No favorites yet',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          const Text(
                            'Tap the heart on any product to save it here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.read<TabProvider>().setIndex(1),
                              child: const Text('Browse products'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (_, i) =>
                        ProductCard(product: items[i], heroPrefix: 'fav'),
                  ),
          ),
        ],
      ),
    );
  }
}
