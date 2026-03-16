import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../recipe/domain/entities/recipe_entity.dart';
import '../../domain/repositories/saved_recipes_repository.dart';
import '../datasources/recipe_firestore_datasource.dart';

// ─── DI providers ─────────────────────────────────────────────────────────────

final recipeFirestoreDatasourceProvider =
    Provider<RecipeFirestoreDatasource>((ref) {
  return FirebaseFirestoreRecipeDatasourceImpl();
});

final savedRecipesRepositoryProvider =
    Provider<SavedRecipesRepository>((ref) {
  return SavedRecipesRepositoryImpl(
    ref.watch(recipeFirestoreDatasourceProvider),
  );
});

// ─── Implementation ───────────────────────────────────────────────────────────

class SavedRecipesRepositoryImpl implements SavedRecipesRepository {
  final RecipeFirestoreDatasource _datasource;

  SavedRecipesRepositoryImpl(this._datasource);

  @override
  Future<void> saveRecipe(RecipeEntity recipe) =>
      _datasource.saveRecipe(recipe);

  @override
  Future<List<RecipeEntity>> getSavedRecipes() =>
      _datasource.getSavedRecipes();

  @override
  Future<void> deleteRecipe(String recipeId) =>
      _datasource.deleteRecipe(recipeId);
}
