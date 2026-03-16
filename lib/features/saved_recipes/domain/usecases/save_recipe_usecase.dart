import '../../../recipe/domain/entities/recipe_entity.dart';
import '../repositories/saved_recipes_repository.dart';

class SaveRecipeUsecase {
  final SavedRecipesRepository _repository;

  SaveRecipeUsecase(this._repository);

  Future<void> execute(RecipeEntity recipe) =>
      _repository.saveRecipe(recipe);
}
