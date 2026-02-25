import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository.dart';
import '../../data/repositories/recipe_repository_impl.dart';

final generateRecipeUsecaseProvider = Provider<GenerateRecipeUsecase>((ref) {
  return GenerateRecipeUsecase(ref.read(recipeRepositoryProvider));
});

class GenerateRecipeUsecase {
  final RecipeRepository _repository;

  GenerateRecipeUsecase(this._repository);

  Future<RecipeEntity> fromIngredients(List<String> ingredients) {
    if (ingredients.isEmpty) {
      throw ArgumentError('Debes agregar al menos un ingrediente');
    }
    return _repository.generateRecipeFromIngredients(ingredients);
  }

  Future<RecipeEntity> fromImage(File image) {
    return _repository.generateRecipeFromImage(image);
  }
}