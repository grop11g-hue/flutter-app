import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/app_snack.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<bool> _confirm(BuildContext context, String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: AppColors.orange,
                  secondary: const Icon(Icons.notifications_none_rounded),
                  title: const Text('Push notifications'),
                  subtitle: const Text('Offers, new arrivals and order updates'),
                  value: settings.notificationsEnabled,
                  onChanged: (v) {
                    settings.setNotifications(v);
                    showAppSnack(
                      context,
                      v ? 'Notifications enabled' : 'Notifications disabled',
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text('Clear favorites'),
                  onTap: () async {
                    final ok = await _confirm(context, 'Clear favorites',
                        'Remove all products from your favorites?');
                    if (ok && context.mounted) {
                      context.read<FavoritesProvider>().clear();
                      showAppSnack(context, 'Favorites cleared');
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: const Text('Clear order history'),
                  onTap: () async {
                    final ok = await _confirm(context, 'Clear order history',
                        'Delete all your past orders?');
                    if (ok && context.mounted) {
                      context.read<OrdersProvider>().clear();
                      showAppSnack(context, 'Order history cleared');
                    }
                  },
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('App version'),
                  trailing: Text(AppConstants.version,
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
