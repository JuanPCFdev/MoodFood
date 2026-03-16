import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moodfood_ai/core/constants/app_colors.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../recipe/domain/entities/recipe_entity.dart';
import '../../../recipe/presentation/widgets/generated_dish_image.dart';

class SavedRecipeDetailScreen extends ConsumerWidget {
  final RecipeEntity recipe;

  const SavedRecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black87)],
                ),
              ),
              background: GeneratedDishImage(imagePrompt: recipe.imagePrompt),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    AppChip(label: recipe.estimatedTime),
                    const SizedBox(width: 8),
                    AppChip(label: recipe.difficulty),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 16),

                Text(
                  recipe.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1,
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 16),

                const SectionTitle('Ingredientes'),

                const SizedBox(height: 16),

                ...recipe.ingredients.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.circle,
                                color: Colors.black, size: 10),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.value)),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 200 * e.key)),
                    ),

                const SizedBox(height: 16),

                const SectionTitle('Preparación'),

                const SizedBox(height: 16),

                ...recipe.steps.map(
                  (step) => _StepCard(step: step)
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 200 * step.stepNumber),
                      )
                      .slideX(begin: 0.1),
                ),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step card widget ───────────────────────────────────────────────────────────

class _StepCard extends StatelessWidget {
  final RecipeStep step;

  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${step.stepNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.instruction,
                  style: const TextStyle(
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (step.tip != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${step.tip}',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
