import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/gemini_datasource.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepositoryImpl(ref.read(geminiDatasourceProvider));
});

class RecipeRepositoryImpl implements RecipeRepository {
  final GeminiDatasource _datasource;

  RecipeRepositoryImpl(this._datasource);

  @override
  Future<RecipeEntity> generateRecipeFromIngredients(
      List<String> ingredients) async {
    final model = await _datasource.generateFromIngredients(ingredients);
    return model.toEntity();
  }

  @override
  Future<RecipeEntity> generateRecipeFromImage(File image) async {
    final model = await _datasource.generateFromImage(image);
    return model.toEntity();
  }
}