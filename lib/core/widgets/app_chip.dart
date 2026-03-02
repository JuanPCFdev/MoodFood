import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Chip reutilizable para tags de info y chips de ingredientes.
/// Muestra un botón de eliminar cuando [onRemove] no es null.
class AppChip extends StatelessWidget {
  final String label;
  final String? leadingIcon;
  final VoidCallback? onRemove;

  const AppChip({
    super.key,
    required this.label,
    this.leadingIcon,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(
                Icons.close,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
