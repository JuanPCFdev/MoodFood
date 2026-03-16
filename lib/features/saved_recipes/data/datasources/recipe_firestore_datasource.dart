import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../recipe/data/models/recipe_model.dart';
import '../../../recipe/domain/entities/recipe_entity.dart';

// ─── Abstract interface ────────────────────────────────────────────────────────

abstract class RecipeFirestoreDatasource {
  Future<void> saveRecipe(RecipeEntity recipe);
  Future<List<RecipeEntity>> getSavedRecipes();
  Future<void> deleteRecipe(String recipeId);
}

// ─── Implementation ───────────────────────────────────────────────────────────

class FirebaseFirestoreRecipeDatasourceImpl
    implements RecipeFirestoreDatasource {
  FirebaseFirestoreRecipeDatasourceImpl();

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError(
        'RecipeFirestoreDatasource called while unauthenticated. '
        'This is a programmer error — auth guard should have blocked this path.',
      );
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> _recipesCollection(String uid) =>
      FirebaseFirestore.instance.collection('users/$uid/recipes');

  @override
  Future<void> saveRecipe(RecipeEntity recipe) async {
    final uid = _uid;
    final map = RecipeModel.fromEntity(recipe).toJson();
    // savedAt and userId are added here — NOT in the model — to avoid
    // polluting the model layer with Firestore-specific types.
    map['savedAt'] = FieldValue.serverTimestamp();
    map['userId'] = uid;

    final docRef = await _recipesCollection(uid).add(map);
    // Write back the auto-generated docId as the `id` field so reads
    // don't need to extract the docId from QueryDocumentSnapshot.id separately.
    await docRef.update({'id': docRef.id});
  }

  @override
  Future<List<RecipeEntity>> getSavedRecipes() async {
    final uid = _uid;
    final snapshot = await _recipesCollection(uid)
        .orderBy('savedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      // Ensure id is always present, even if the write-back update hasn't
      // landed yet (race condition guard).
      data['id'] ??= doc.id;
      return RecipeModel.fromJson(data).toEntity();
    }).toList();
  }

  @override
  Future<void> deleteRecipe(String recipeId) async {
    final uid = _uid;
    await _recipesCollection(uid).doc(recipeId).delete();
  }
}
