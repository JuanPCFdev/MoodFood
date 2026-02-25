import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../recipe/presentation/providers/recipe_provider.dart';
import '../widgets/ingredient_input_card.dart';

// Provider local para la lista de ingredientes
final ingredientsListProvider = StateProvider<List<String>>((ref) => []);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(ingredientsListProvider);
    final recipeState = ref.watch(recipeProvider);

    // Navegar automáticamente cuando la receta esté lista
    ref.listen(recipeProvider, (prev, next) {
      if (next is RecipeSuccess) {
        context.go('/recipe', extra: next.recipe);
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
              // Header
              const SizedBox(height: 20),
              Text(
                '🍽️ MoodFood',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),

              Text(
                '¿Qué hay en tu nevera?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 32),

              // Input de ingredientes
              IngredientInputCard(
                ingredients: ingredients,
                onAdd: (ingredient) {
                  ref.read(ingredientsListProvider.notifier).update(
                        (list) => [...list, ingredient],
                      );
                },
                onRemove: (index) {
                  ref.read(ingredientsListProvider.notifier).update(
                        (list) => [...list]..removeAt(index),
                      );
                },
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

              const SizedBox(height: 24),

              // Botón de cámara
              _CameraButton(
                onImageSelected: (file) {
                  ref.read(recipeProvider.notifier).generateFromImage(file);
                },
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 24),

              // Botón principal
              SizedBox(
                width: double.infinity,
                height: 56,
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
              ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),

              // Error state
              if (recipeState is RecipeError)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    '❌ ${recipeState.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  final Function(File) onImageSelected;
  const _CameraButton({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
        if (pickedFile != null) {
          onImageSelected(File(pickedFile.path));
        }
      },
      icon: const Icon(Icons.camera_alt),
      label: const Text('Fotografiar mi nevera'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}