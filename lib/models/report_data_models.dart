class ReportData {
  final int totalMeals;
  final Map<String, int> mealsByType;
  final int averageCalories;

  ReportData({
    required this.totalMeals,
    required this.mealsByType,
    required this.averageCalories,
  });
}
