import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../recipe/domain/entities/recipe_entity.dart';

class SavedRecipeCard extends StatelessWidget {
  final RecipeEntity recipe;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SavedRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Difficulty + estimated time
                  Row(
                    children: [
                      _Chip(
                        icon: Icons.bar_chart,
                        label: recipe.difficulty,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        icon: Icons.access_time,
                        label: recipe.estimatedTime,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Ingredients count
                  Text(
                    '${recipe.ingredients.length} ingrediente${recipe.ingredients.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // ── Delete button ──
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent,
              tooltip: 'Eliminar receta',
            ),
          ],
          ),
        ),
      ),
    );
  }
}

// ─── Private chip helper ───────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: color),
        ),
      ],
    );
  }
}
