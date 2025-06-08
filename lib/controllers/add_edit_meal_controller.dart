// lib/controllers/add_edit_meal_controller.dart

import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
import 'package:meal_tracker_flutter/models/meals_models.dart';

/// Thrown when saving a meal fails.
class MealSaveException implements Exception {
  final String message;
  MealSaveException(this.message);
}

/// Encapsulates add & update logic for meals.
class AddEditMealController {
  final FirestoreService _firestoreService;

  AddEditMealController(this._firestoreService);

  /// Saves [meal]. If its `id` is empty, adds new; otherwise updates existing.
  Future<void> saveMeal(Meal meal) async {
    try {
      if (meal.id.isEmpty) {
        await _firestoreService.addMeal(meal);
      } else {
        await _firestoreService.updateMeal(meal);
      }
    } catch (e) {
      throw MealSaveException('Failed to save meal: $e');
    }
  }
}
