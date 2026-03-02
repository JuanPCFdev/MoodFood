import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientNotifier extends StateNotifier<List<String>> {
  IngredientNotifier() : super([]);

  void add(String ingredient) => state = [...state, ingredient];
  void remove(int index) => state = [...state]..removeAt(index);
  void clear() => state = [];
}

final ingredientProvider =
    StateNotifierProvider<IngredientNotifier, List<String>>(
  (ref) => IngredientNotifier(),
);
