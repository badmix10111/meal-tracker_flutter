// lib/controllers/meal_list_controller.dart

import 'package:meal_tracker_2/helpers/firestore_service.dart';
import 'package:meal_tracker_2/models/meals_models.dart';

/// Encapsulates fetching and formatting logic for the meal list.
class MealListController {
  final FirestoreService _firestoreService;

  MealListController(this._firestoreService);

  /// Streams the list of meals for [userId].
  Stream<List<Meal>> mealsStream(String userId) {
    return _firestoreService.streamMealsForUser(userId);
  }

  /// Builds a shareable text for a given [meal].
  String buildShareText(Meal meal) {
    final time = meal.timestamp;
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    final buffer = StringBuffer()
      ..write('I just had "${meal.title}" (${meal.type}) at $hh:$mm');
    if (meal.calories != null) {
      buffer.write(' with ${meal.calories} calories.');
    } else {
      buffer.write('.');
    }
    return buffer.toString();
  }
}
