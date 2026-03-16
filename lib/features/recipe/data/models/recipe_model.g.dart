// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) => RecipeModel(
      id: json['id'] as String?,
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

Map<String, dynamic> _$RecipeModelToJson(RecipeModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['description'] = instance.description;
  val['ingredients'] = instance.ingredients;
  val['steps'] = instance.steps.map((e) => e.toJson()).toList();
  val['estimatedTime'] = instance.estimatedTime;
  val['difficulty'] = instance.difficulty;
  val['imagePrompt'] = instance.imagePrompt;
  return val;
}

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
