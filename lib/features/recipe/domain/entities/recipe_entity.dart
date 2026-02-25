import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_entity.freezed.dart';

@freezed
class RecipeEntity with _$RecipeEntity {
  const factory RecipeEntity({
    required String name,
    required String description,
    required List<String> ingredients,
    required List<RecipeStep> steps,
    required String estimatedTime,
    required String difficulty,
    required String imagePrompt, // Para generar la imagen del plato
  }) = _RecipeEntity;
}

@freezed
class RecipeStep with _$RecipeStep {
  const factory RecipeStep({
    required int stepNumber,
    required String instruction,
    String? tip,
  }) = _RecipeStep;
}