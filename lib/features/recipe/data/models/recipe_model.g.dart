// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) => RecipeModel(
      name: json['name'] as String,
      description: json['description'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RecipeStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      estimatedTime: json['estimatedTime'] as String,
      difficulty: json['difficulty'] as String,
      imagePrompt: json['imagePrompt'] as String,
    );

Map<String, dynamic> _$RecipeModelToJson(RecipeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'estimatedTime': instance.estimatedTime,
      'difficulty': instance.difficulty,
      'imagePrompt': instance.imagePrompt,
    };

RecipeStepModel _$RecipeStepModelFromJson(Map<String, dynamic> json) =>
    RecipeStepModel(
      stepNumber: (json['stepNumber'] as num).toInt(),
      instruction: json['instruction'] as String,
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$RecipeStepModelToJson(RecipeStepModel instance) =>
    <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'instruction': instance.instruction,
      'tip': instance.tip,
    };
