// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecipeEntity {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get ingredients => throw _privateConstructorUsedError;
  List<RecipeStep> get steps => throw _privateConstructorUsedError;
  String get estimatedTime => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  String get imagePrompt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecipeEntityCopyWith<RecipeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeEntityCopyWith<$Res> {
  factory $RecipeEntityCopyWith(
          RecipeEntity value, $Res Function(RecipeEntity) then) =
      _$RecipeEntityCopyWithImpl<$Res, RecipeEntity>;
  @useResult
  $Res call(
      {String name,
      String description,
      List<String> ingredients,
      List<RecipeStep> steps,
      String estimatedTime,
      String difficulty,
      String imagePrompt});
}

/// @nodoc
class _$RecipeEntityCopyWithImpl<$Res, $Val extends RecipeEntity>
    implements $RecipeEntityCopyWith<$Res> {
  _$RecipeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? ingredients = null,
    Object? steps = null,
    Object? estimatedTime = null,
    Object? difficulty = null,
    Object? imagePrompt = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RecipeStep>,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      imagePrompt: null == imagePrompt
          ? _value.imagePrompt
          : imagePrompt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeEntityImplCopyWith<$Res>
    implements $RecipeEntityCopyWith<$Res> {
  factory _$$RecipeEntityImplCopyWith(
          _$RecipeEntityImpl value, $Res Function(_$RecipeEntityImpl) then) =
      __$$RecipeEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      List<String> ingredients,
      List<RecipeStep> steps,
      String estimatedTime,
      String difficulty,
      String imagePrompt});
}

/// @nodoc
class __$$RecipeEntityImplCopyWithImpl<$Res>
    extends _$RecipeEntityCopyWithImpl<$Res, _$RecipeEntityImpl>
    implements _$$RecipeEntityImplCopyWith<$Res> {
  __$$RecipeEntityImplCopyWithImpl(
      _$RecipeEntityImpl _value, $Res Function(_$RecipeEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? ingredients = null,
    Object? steps = null,
    Object? estimatedTime = null,
    Object? difficulty = null,
    Object? imagePrompt = null,
  }) {
    return _then(_$RecipeEntityImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RecipeStep>,
      estimatedTime: null == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      imagePrompt: null == imagePrompt
          ? _value.imagePrompt
          : imagePrompt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RecipeEntityImpl implements _RecipeEntity {
  const _$RecipeEntityImpl(
      {required this.name,
      required this.description,
      required final List<String> ingredients,
      required final List<RecipeStep> steps,
      required this.estimatedTime,
      required this.difficulty,
      required this.imagePrompt})
      : _ingredients = ingredients,
        _steps = steps;

  @override
  final String name;
  @override
  final String description;
  final List<String> _ingredients;
  @override
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<RecipeStep> _steps;
  @override
  List<RecipeStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final String estimatedTime;
  @override
  final String difficulty;
  @override
  final String imagePrompt;

  @override
  String toString() {
    return 'RecipeEntity(name: $name, description: $description, ingredients: $ingredients, steps: $steps, estimatedTime: $estimatedTime, difficulty: $difficulty, imagePrompt: $imagePrompt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeEntityImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.imagePrompt, imagePrompt) ||
                other.imagePrompt == imagePrompt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_steps),
      estimatedTime,
      difficulty,
      imagePrompt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeEntityImplCopyWith<_$RecipeEntityImpl> get copyWith =>
      __$$RecipeEntityImplCopyWithImpl<_$RecipeEntityImpl>(this, _$identity);
}

abstract class _RecipeEntity implements RecipeEntity {
  const factory _RecipeEntity(
      {required final String name,
      required final String description,
      required final List<String> ingredients,
      required final List<RecipeStep> steps,
      required final String estimatedTime,
      required final String difficulty,
      required final String imagePrompt}) = _$RecipeEntityImpl;

  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get ingredients;
  @override
  List<RecipeStep> get steps;
  @override
  String get estimatedTime;
  @override
  String get difficulty;
  @override
  String get imagePrompt;
  @override
  @JsonKey(ignore: true)
  _$$RecipeEntityImplCopyWith<_$RecipeEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecipeStep {
  int get stepNumber => throw _privateConstructorUsedError;
  String get instruction => throw _privateConstructorUsedError;
  String? get tip => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecipeStepCopyWith<RecipeStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeStepCopyWith<$Res> {
  factory $RecipeStepCopyWith(
          RecipeStep value, $Res Function(RecipeStep) then) =
      _$RecipeStepCopyWithImpl<$Res, RecipeStep>;
  @useResult
  $Res call({int stepNumber, String instruction, String? tip});
}

/// @nodoc
class _$RecipeStepCopyWithImpl<$Res, $Val extends RecipeStep>
    implements $RecipeStepCopyWith<$Res> {
  _$RecipeStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stepNumber = null,
    Object? instruction = null,
    Object? tip = freezed,
  }) {
    return _then(_value.copyWith(
      stepNumber: null == stepNumber
          ? _value.stepNumber
          : stepNumber // ignore: cast_nullable_to_non_nullable
              as int,
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      tip: freezed == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeStepImplCopyWith<$Res>
    implements $RecipeStepCopyWith<$Res> {
  factory _$$RecipeStepImplCopyWith(
          _$RecipeStepImpl value, $Res Function(_$RecipeStepImpl) then) =
      __$$RecipeStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int stepNumber, String instruction, String? tip});
}

/// @nodoc
class __$$RecipeStepImplCopyWithImpl<$Res>
    extends _$RecipeStepCopyWithImpl<$Res, _$RecipeStepImpl>
    implements _$$RecipeStepImplCopyWith<$Res> {
  __$$RecipeStepImplCopyWithImpl(
      _$RecipeStepImpl _value, $Res Function(_$RecipeStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stepNumber = null,
    Object? instruction = null,
    Object? tip = freezed,
  }) {
    return _then(_$RecipeStepImpl(
      stepNumber: null == stepNumber
          ? _value.stepNumber
          : stepNumber // ignore: cast_nullable_to_non_nullable
              as int,
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      tip: freezed == tip
          ? _value.tip
          : tip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RecipeStepImpl implements _RecipeStep {
  const _$RecipeStepImpl(
      {required this.stepNumber, required this.instruction, this.tip});

  @override
  final int stepNumber;
  @override
  final String instruction;
  @override
  final String? tip;

  @override
  String toString() {
    return 'RecipeStep(stepNumber: $stepNumber, instruction: $instruction, tip: $tip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeStepImpl &&
            (identical(other.stepNumber, stepNumber) ||
                other.stepNumber == stepNumber) &&
            (identical(other.instruction, instruction) ||
                other.instruction == instruction) &&
            (identical(other.tip, tip) || other.tip == tip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, stepNumber, instruction, tip);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeStepImplCopyWith<_$RecipeStepImpl> get copyWith =>
      __$$RecipeStepImplCopyWithImpl<_$RecipeStepImpl>(this, _$identity);
}

abstract class _RecipeStep implements RecipeStep {
  const factory _RecipeStep(
      {required final int stepNumber,
      required final String instruction,
      final String? tip}) = _$RecipeStepImpl;

  @override
  int get stepNumber;
  @override
  String get instruction;
  @override
  String? get tip;
  @override
  @JsonKey(ignore: true)
  _$$RecipeStepImplCopyWith<_$RecipeStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
