import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/recipe_entity.dart';

part 'recipe_model.g.dart';

@JsonSerializable()
class RecipeModel {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<RecipeStepModel> steps;
  final String estimatedTime;
  final String difficulty;
  final String imagePrompt;

  const RecipeModel({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.estimatedTime,
    required this.difficulty,
    required this.imagePrompt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  // Convertir Model → Entity (cruzar de data a domain)
  RecipeEntity toEntity() => RecipeEntity(
        name: name,
        description: description,
        ingredients: ingredients,
        steps: steps.map((s) => s.toEntity()).toList(),
        estimatedTime: estimatedTime,
        difficulty: difficulty,
        imagePrompt: imagePrompt,
      );
}

@JsonSerializable()
class RecipeStepModel {
  final int stepNumber;
  final String instruction;
  final String? tip;

  const RecipeStepModel({
    required this.stepNumber,
    required this.instruction,
    this.tip,
  });

  factory RecipeStepModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepModelFromJson(json);

  RecipeStep toEntity() => RecipeStep(
        stepNumber: stepNumber,
        instruction: instruction,
        tip: tip,
      );
}