import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../recipe/domain/entities/recipe_entity.dart';
import '../../data/repositories/saved_recipes_repository_impl.dart';
import '../../domain/usecases/save_recipe_usecase.dart';
import '../../domain/usecases/get_saved_recipes_usecase.dart';
import '../../domain/usecases/delete_recipe_usecase.dart';

// ─── State (sealed) ───────────────────────────────────────────────────────────

sealed class SavedRecipesState {
  const SavedRecipesState();
}

class SavedRecipesInitial extends SavedRecipesState {
  const SavedRecipesInitial();
}

class SavedRecipesLoading extends SavedRecipesState {
  const SavedRecipesLoading();
}

class SavedRecipesLoaded extends SavedRecipesState {
  final List<RecipeEntity> recipes;
  const SavedRecipesLoaded(this.recipes);
}

/// Transient state emitted while a single save operation is in progress.
/// Used by RecipeScreen to show a loading indicator on the save button.
class SavedRecipesSaving extends SavedRecipesState {
  const SavedRecipesSaving();
}

/// Transient terminal state emitted after a successful save.
/// UI should react (e.g. show "Guardado ✓") then reset state.
class SavedRecipesSaved extends SavedRecipesState {
  const SavedRecipesSaved();
}

class SavedRecipesError extends SavedRecipesState {
  final String message;
  const SavedRecipesError(this.message);
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class SavedRecipesNotifier extends StateNotifier<SavedRecipesState> {
  final SaveRecipeUsecase _saveRecipe;
  final GetSavedRecipesUsecase _getSavedRecipes;
  final DeleteRecipeUsecase _deleteRecipe;

  SavedRecipesNotifier({
    required SaveRecipeUsecase saveRecipe,
    required GetSavedRecipesUsecase getSavedRecipes,
    required DeleteRecipeUsecase deleteRecipe,
  })  : _saveRecipe = saveRecipe,
        _getSavedRecipes = getSavedRecipes,
        _deleteRecipe = deleteRecipe,
        super(const SavedRecipesInitial());

  /// Fetches all saved recipes from Firestore and updates state.
  Future<void> loadRecipes() async {
    state = const SavedRecipesLoading();
    try {
      final recipes = await _getSavedRecipes.execute();
      state = SavedRecipesLoaded(recipes);
    } catch (e) {
      state = const SavedRecipesError(
        'No pudimos cargar tus recetas. Tirá para actualizar',
      );
    }
  }

  /// Saves a recipe to Firestore.
  /// Emits [SavedRecipesSaving] → [SavedRecipesSaved] on success.
  /// After 2 seconds, resets to re-fetched [SavedRecipesLoaded] state.
  Future<void> saveRecipe(RecipeEntity recipe) async {
    state = const SavedRecipesSaving();
    try {
      await _saveRecipe.execute(recipe);
      state = const SavedRecipesSaved();
      // Transient success — reload the list after 2 seconds.
      await Future.delayed(const Duration(seconds: 2));
      if (state is SavedRecipesSaved) {
        await loadRecipes();
      }
    } catch (e) {
      state = const SavedRecipesError(
        'No se pudo guardar la receta. Intentá de nuevo',
      );
    }
  }

  /// Optimistically removes the recipe from the loaded list, then deletes
  /// from Firestore. On error, rolls back and shows an error state.
  Future<void> deleteRecipe(String recipeId) async {
    final currentState = state;
    // Optimistic update — remove from list immediately for instant UI response.
    if (currentState is SavedRecipesLoaded) {
      final updatedList = currentState.recipes
          .where((r) => r.id != recipeId)
          .toList();
      state = SavedRecipesLoaded(updatedList);
    }

    try {
      await _deleteRecipe.execute(recipeId);
    } catch (e) {
      // Rollback — reload from Firestore to restore the real state.
      await loadRecipes();
      state = const SavedRecipesError(
        'No se pudo eliminar la receta. Intentá de nuevo',
      );
    }
  }

  /// Resets to initial state. Called on logout to clear stale data.
  void reset() => state = const SavedRecipesInitial();
}

// ─── Providers ────────────────────────────────────────────────────────────────

final _saveRecipeUsecaseProvider = Provider<SaveRecipeUsecase>((ref) {
  return SaveRecipeUsecase(ref.watch(savedRecipesRepositoryProvider));
});

final _getSavedRecipesUsecaseProvider = Provider<GetSavedRecipesUsecase>((ref) {
  return GetSavedRecipesUsecase(ref.watch(savedRecipesRepositoryProvider));
});

final _deleteRecipeUsecaseProvider = Provider<DeleteRecipeUsecase>((ref) {
  return DeleteRecipeUsecase(ref.watch(savedRecipesRepositoryProvider));
});

final savedRecipesProvider =
    StateNotifierProvider<SavedRecipesNotifier, SavedRecipesState>((ref) {
  return SavedRecipesNotifier(
    saveRecipe: ref.read(_saveRecipeUsecaseProvider),
    getSavedRecipes: ref.read(_getSavedRecipesUsecaseProvider),
    deleteRecipe: ref.read(_deleteRecipeUsecaseProvider),
  );
});
