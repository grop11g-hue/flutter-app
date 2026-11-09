import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Loads a bundled asset image with a safe fallback.
class ProductImage extends StatelessWidget {
  const ProductImage(this.path, {super.key, this.fit = BoxFit.cover});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.cardLight,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppColors.textSecondary, size: 36),
      ),
    );
  }
}
