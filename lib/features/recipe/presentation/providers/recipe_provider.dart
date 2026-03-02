import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/usecases/generate_recipe_usecase.dart';

sealed class RecipeState { const RecipeState(); }
class RecipeInitial  extends RecipeState { const RecipeInitial(); }
class RecipeLoading  extends RecipeState { const RecipeLoading(); }
class RecipeSuccess  extends RecipeState {
  final RecipeEntity recipe;
  const RecipeSuccess(this.recipe);
}
class RecipeError extends RecipeState {
  final String message;        // Siempre amigable
  const RecipeError(this.message);
}

class RecipeNotifier extends StateNotifier<RecipeState> {
  final GenerateRecipeUsecase _usecase;
  RecipeNotifier(this._usecase) : super(const RecipeInitial());

  Future<void> generateFromIngredients(List<String> ingredients) async {
    state = const RecipeLoading();
    try {
      final recipe = await _usecase.fromIngredients(ingredients);
      state = RecipeSuccess(recipe);
    } on AppFailure catch (f) {
      state = RecipeError(f.message);       // ← mensaje ya humanizado
    } catch (e) {
      state = const RecipeError('Algo salió mal en la cocina 😅\nIntenta de nuevo.');
    }
  }

  Future<void> generateFromImage(File image) async {
    state = const RecipeLoading();
    try {
      final recipe = await _usecase.fromImage(image);
      state = RecipeSuccess(recipe);
    } on AppFailure catch (f) {
      state = RecipeError(f.message);
    } catch (e) {
      state = const RecipeError('Algo salió mal en la cocina 😅\nIntenta de nuevo.');
    }
  }

  void reset() => state = const RecipeInitial();
}

final recipeProvider =
    StateNotifierProvider<RecipeNotifier, RecipeState>((ref) {
  return RecipeNotifier(ref.read(generateRecipeUsecaseProvider));
});