import '../../../recipe/domain/entities/recipe_entity.dart';

abstract class SavedRecipesRepository {
  Future<void> saveRecipe(RecipeEntity recipe);
  Future<List<RecipeEntity>> getSavedRecipes();
  Future<void> deleteRecipe(String recipeId);
}
