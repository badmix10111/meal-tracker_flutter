// lib/controllers/report_controller.dart

import 'package:meal_tracker_2/helpers/firestore_service.dart';
import 'package:meal_tracker_2/models/report_data_models.dart';

/// Holds the computed metrics for a user’s meals.

/// Fetches meal data and computes reporting metrics.
class ReportController {
  final FirestoreService _firestoreService;

  ReportController(this._firestoreService);

  /// Retrieves all meals for [userId],:

  /// Throws on any Firestore error.
  Future<ReportData> fetchReport(String userId) async {
    try {
      // getSnapshot first value and convert to list
      final meals = await _firestoreService.streamMealsForUser(userId).first;

      final total = meals.length;

      // Count by type
      final byType = <String, int>{};
      for (final meal in meals) {
        byType[meal.type] = (byType[meal.type] ?? 0) + 1;
      }

      // Average calories
      final withCalories = meals.where((m) => m.calories != null).toList();
      final avgCalories = withCalories.isEmpty
          ? 0
          : (withCalories.map((m) => m.calories!).reduce((a, b) => a + b) ~/
              withCalories.length);

      return ReportData(
        totalMeals: total,
        mealsByType: byType,
        averageCalories: avgCalories,
      );
    } catch (e) {
      // Re-throw with clearer message
      throw Exception('Failed to load report data: $e');
    }
  }
}
