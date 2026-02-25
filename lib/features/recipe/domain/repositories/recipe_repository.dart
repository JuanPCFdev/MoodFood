import 'dart:io';
import '../entities/recipe_entity.dart';

// Contrato abstracto — la UI nunca conoce la implementación
abstract class RecipeRepository {
  Future<RecipeEntity> generateRecipeFromIngredients(List<String> ingredients);
  Future<RecipeEntity> generateRecipeFromImage(File image);
}