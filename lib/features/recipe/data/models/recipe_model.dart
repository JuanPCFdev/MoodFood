import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/recipe_entity.dart';

part 'recipe_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RecipeModel {
  @JsonKey(includeIfNull: false)
  final String? id;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<RecipeStepModel> steps;
  final String estimatedTime;
  final String difficulty;
  final String imagePrompt;

  const RecipeModel({
    this.id,
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

  // Expone la función generada para serializar a JSON (para escrituras en Firestore)
  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);

  // Convertir Entity → Model (para escrituras en Firestore)
  factory RecipeModel.fromEntity(RecipeEntity entity) => RecipeModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        ingredients: entity.ingredients,
        steps: entity.steps.map(RecipeStepModel.fromEntity).toList(),
        estimatedTime: entity.estimatedTime,
        difficulty: entity.difficulty,
        imagePrompt: entity.imagePrompt,
      );

  // Convertir Model → Entity (cruzar de data a domain)
  RecipeEntity toEntity() => RecipeEntity(
        id: id,
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

  Map<String, dynamic> toJson() => _$RecipeStepModelToJson(this);

  // Convertir RecipeStep Entity → Model (para escrituras en Firestore)
  factory RecipeStepModel.fromEntity(RecipeStep step) => RecipeStepModel(
        stepNumber: step.stepNumber,
        instruction: step.instruction,
        tip: step.tip,
      );

  RecipeStep toEntity() => RecipeStep(
        stepNumber: stepNumber,
        instruction: instruction,
        tip: tip,
      );
}
