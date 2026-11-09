import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tab_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'favorites/favorites_screen.dart';
import 'home/home_screen.dart';
import 'products/products_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = context.watch<TabProvider>();
    return Scaffold(
      body: IndexedStack(
        index: tab.index,
        children: const [
          HomeScreen(),
          ProductsScreen(),
          FavoritesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: SportixBottomNav(
        currentIndex: tab.index,
        onTap: tab.setIndex,
      ),
    );
  }
}
