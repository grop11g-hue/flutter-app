import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProductsProvider>();
    final results = p.results;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'All Products',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  '${results.length} items',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SportixSearchBar(
              value: p.query,
              onChanged: p.setQuery,
            ),
          ),
          // ---- categories
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: AppConstants.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final c = AppConstants.categories[i];
                final selected = c == p.category;
                return GestureDetector(
                  onTap: () => p.setCategory(c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.orange : AppColors.card,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        color: selected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ---- filter / sort
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.tune_rounded,
                    label: 'Filter',
                    active: p.hasActiveFilters,
                    onTap: () => _openFilter(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.swap_vert_rounded,
                    label: p.sort == SortOption.featured ? 'Sort' : p.sort.label,
                    active: p.sort != SortOption.featured,
                    onTap: () => _openSort(context),
                  ),
                ),
              ],
            ),
          ),
          // ---- grid
          Expanded(
            child: results.isEmpty
                ? _EmptyState(onReset: p.resetAll)
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    itemCount: results.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (_, i) =>
                        ProductCard(product: results[i], heroPrefix: 'grid'),
                  ),
          ),
        ],
      ),
    );
  }

  void _openSort(BuildContext context) {
    final provider = context.read<ProductsProvider>();
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Sort by',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            for (final option in SortOption.values)
              ListTile(
                title: Text(option.label),
                trailing: provider.sort == option
                    ? const Icon(Icons.check_circle, color: AppColors.orange)
                    : null,
                onTap: () {
                  provider.setSort(option);
                  Navigator.pop(sheetContext);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openFilter(BuildContext context) {
    final provider = context.read<ProductsProvider>();
    double maxPrice = provider.maxPrice;
    double minRating = provider.minRating;
    bool onlySale = provider.onlySale;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (_, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            0,
            24,
            24 + MediaQuery.of(sheetContext).viewPadding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Max price'),
                  Text(
                    '\$${maxPrice.round()}',
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Slider(
                value: maxPrice,
                min: 5,
                max: ProductsProvider.priceCeiling,
                divisions: 11,
                activeColor: AppColors.orange,
                label: '\$${maxPrice.round()}',
                onChanged: (v) => setSheet(() => maxPrice = v),
              ),
              const SizedBox(height: 8),
              const Text('Minimum rating'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  for (final r in const [0.0, 4.0, 4.5, 4.7])
                    ChoiceChip(
                      label: Text(r == 0 ? 'Any' : '$r+'),
                      selected: minRating == r,
                      selectedColor: AppColors.orange,
                      backgroundColor: AppColors.cardLight,
                      labelStyle: TextStyle(
                        color: minRating == r ? Colors.white : AppColors.textSecondary,
                      ),
                      showCheckmark: false,
                      onSelected: (_) => setSheet(() => minRating = r),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Only items on sale'),
                value: onlySale,
                activeColor: AppColors.orange,
                onChanged: (v) => setSheet(() => onlySale = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        provider.resetFilters();
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        provider.applyFilters(
                          maxPrice: maxPrice,
                          minRating: minRating,
                          onlySale: onlySale,
                        );
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? AppColors.orange : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: active ? AppColors.orange : Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: active ? AppColors.orange : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            const Text('No products found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text(
              'Try a different search or clear your filters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: onReset,
                child: const Text('Reset all'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
