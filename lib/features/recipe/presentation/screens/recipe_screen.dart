import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/section_title.dart';
import '../../domain/entities/recipe_entity.dart';
import '../providers/recipe_provider.dart';
import '../widgets/generated_dish_image.dart';

class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recipeProvider);

    if (state is! RecipeSuccess) return const SizedBox.shrink();

    final recipe = state.recipe;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen del plato
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go('/'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black87)],
                ),
              ),
              background: GeneratedDishImage(imagePrompt: recipe.imagePrompt),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Info chips
                Row(
                  children: [
                    AppChip(label: recipe.estimatedTime, leadingIcon: '⏱️'),
                    const SizedBox(width: 8),
                    AppChip(label: recipe.difficulty, leadingIcon: '📊'),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 16),

                // Descripción
                Text(
                  recipe.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 24),

                // Ingredientes
                const SectionTitle('🥬 Ingredientes'),
                const SizedBox(height: 12),
                ...recipe.ingredients.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.value)),
                          ],
                        ),
                      ).animate().fadeIn(delay: Duration(milliseconds: 100 * e.key)),
                    ),

                const SizedBox(height: 24),

                // Pasos
                const SectionTitle('👨‍🍳 Preparación'),
                const SizedBox(height: 12),
                ...recipe.steps.map(
                  (step) => _StepCard(step: step)
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 150 * step.stepNumber),
                      )
                      .slideX(begin: 0.1),
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final RecipeStep step;
  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
              color: Color(0xFFFF6B35),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${step.stepNumber}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.instruction, style: const TextStyle(height: 1.4)),
                if (step.tip != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '💡 ${step.tip}',
                    style: TextStyle(
                        color: Colors.amber[700],
                        fontSize: 13,
                        fontStyle: FontStyle.italic),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
