import '../repositories/saved_recipes_repository.dart';

class DeleteRecipeUsecase {
  final SavedRecipesRepository _repository;

  DeleteRecipeUsecase(this._repository);

  Future<void> execute(String recipeId) =>
      _repository.deleteRecipe(recipeId);
}
