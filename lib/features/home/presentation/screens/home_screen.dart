import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../recipe/presentation/providers/recipe_provider.dart';
import '../../providers/ingredient_provider.dart';
import '../widgets/ingredient_input_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(ingredientProvider);
    final recipeState = ref.watch(recipeProvider);

    // Navegar automáticamente cuando la receta esté lista
    ref.listen(recipeProvider, (prev, next) {
      if (next is RecipeSuccess) {
        context.go('/recipe');
      }
      if (next is RecipeError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Text('😅', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    next.message,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2D3436),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Reintentar',
              textColor: AppColors.primary,
              onPressed: () => ref.read(recipeProvider.notifier).reset(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MoodFood',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 36
                ),
              ).animate().fadeIn(duration: 200.ms).slideX(begin: -0.3),

              Text(
                '¿Qué hay en tu nevera?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 16),

              // Input de ingredientes
              IngredientInputCard(
                ingredients: ingredients,
                onAdd: (ingredient) {
                  ref.read(ingredientProvider.notifier).add(ingredient);
                },
                onRemove: (index) {
                  ref.read(ingredientProvider.notifier).remove(index);
                },
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

              const SizedBox(height: 16),

              // Botón de cámara
              _CameraButton(
                isLoading: recipeState is RecipeLoading,
                onImageSelected: (file) {
                  ref.read(recipeProvider.notifier).generateFromImage(file);
                },
              ).animate().fadeIn(delay: 200.ms).slideX(begin:0.3),

              const SizedBox(height: 16),

              // Botón principal
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: recipeState is RecipeLoading || ingredients.isEmpty
                      ? null
                      : () => ref
                          .read(recipeProvider.notifier)
                          .generateFromIngredients(ingredients),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: recipeState is RecipeLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          '✨ Generar Receta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  final Function(File) onImageSelected;
  final bool isLoading;

  const _CameraButton({required this.onImageSelected, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading
          ? null
          : () async {
              // Navega a la cámara in-app — sin cambio de actividad Android,
              // sin riesgo de FlutterSurfaceView destruida al regresar.
              final file = await context.push<File?>('/camera');
              if (file != null) onImageSelected(file);
            },
      icon: const Icon(Icons.camera_alt),
      label: const Text('Generar con Imagen'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
