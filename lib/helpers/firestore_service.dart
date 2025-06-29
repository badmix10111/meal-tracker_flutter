import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_tracker_2/models/meals_models.dart';

/// A service class that handles all interactions with the Firestore database

class FirestoreService {
  final FirebaseFirestore _firestore;

  /// Constructor allows optional injection of a custom FirebaseFirestore instance (for testing)
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to the 'meals' collection in Firestore
  CollectionReference<Map<String, dynamic>> get _mealsRef =>
      _firestore.collection('meals');

  /// Adds a new meal document to the 'meals' collection
  // Future<void> addMeal(Meal meal) async {
  //   await _mealsRef.add(meal.toFirestore());
  // }
  Future<void> addMeal(String userId, Meal meal) async {
    await _mealsRef.add({
      ...meal.toFirestore(), // all your existing fields
      'userId': userId, // ← stamp with the current user
    });
  }

  /// Streams a real-time list of meals for the given user, sorted by timestamp (latest first)
  Stream<List<Meal>> streamMealsForUser(String userId) {
    return _mealsRef
        .where('userId', isEqualTo: userId) // Filter meals by user
        .orderBy('timestamp', descending: true) // Sort by newest first
        .snapshots() // Get live updates from Firestore
        .map((snapshot) => snapshot.docs
            .map((doc) => Meal.fromFirestore(
                  doc.data(), // Convert Firestore data into Meal model
                  doc.id, // Include document ID as part of the Meal
                ))
            .toList());
  }

  /// Updates an existing meal document by ID with new data
  Future<void> updateMeal(Meal meal) async {
    if (meal.id.isEmpty) throw ArgumentError('Meal id is required');
    await _mealsRef.doc(meal.id).update(meal.toFirestore());
  }

  /// Deletes a meal document from Firestore by its ID
  Future<void> deleteMeal(String mealId) async {
    await _mealsRef.doc(mealId).delete();
  }
}
