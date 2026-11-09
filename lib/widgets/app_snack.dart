import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

void showAppSnack(
  BuildContext context,
  String message, {
  bool error = false,
  SnackBarAction? action,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      action: action,
      content: Row(
        children: [
          Icon(
            error ? Icons.error_outline : Icons.check_circle,
            color: error ? AppColors.error : AppColors.success,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}
