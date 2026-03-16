import '../../../recipe/domain/entities/recipe_entity.dart';
import '../repositories/saved_recipes_repository.dart';

class GetSavedRecipesUsecase {
  final SavedRecipesRepository _repository;

  GetSavedRecipesUsecase(this._repository);

  Future<List<RecipeEntity>> execute() => _repository.getSavedRecipes();
}
