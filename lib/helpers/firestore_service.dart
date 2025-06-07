// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_tracker_flutter/models/meals_models.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _mealsRef =>
      _firestore.collection('meals');

  Future<void> addMeal(Meal meal) async {
    await _mealsRef.add(meal.toFirestore());
  }

  Stream<List<Meal>> streamMealsForUser(String userId) {
    return _mealsRef
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Meal.fromFirestore(
                  doc.data(),
                  doc.id,
                ))
            .toList());
  }

  Future<void> updateMeal(Meal meal) async {
    if (meal.id.isEmpty) throw ArgumentError('Meal id is required');
    await _mealsRef.doc(meal.id).update(meal.toFirestore());
  }

  Future<void> deleteMeal(String mealId) async {
    await _mealsRef.doc(mealId).delete();
  }
}
