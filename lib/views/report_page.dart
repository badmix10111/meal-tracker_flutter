// lib/views/report_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
import 'package:meal_tracker_flutter/models/meals_models.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Meal Reports')),
      body: FutureBuilder<List<Meal>>(
        // Grab the first snapshot of your meals stream
        future: FirestoreService().streamMealsForUser(uid).first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading reports: ${snapshot.error}'));
          }
          final meals = snapshot.data ?? [];

          // Compute total meals
          final total = meals.length;

          // Compute counts by type
          final byType = <String, int>{};
          for (var m in meals) {
            byType[m.type] = (byType[m.type] ?? 0) + 1;
          }

          // Compute average calories (only entries with calories set)
          final mealsWithCalories =
              meals.where((m) => m.calories != null).toList();
          final avgCalories = mealsWithCalories.isNotEmpty
              ? mealsWithCalories
                      .map((m) => m.calories!)
                      .reduce((a, b) => a + b) ~/
                  mealsWithCalories.length
              : 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard('Total meals logged', '$total'),
                const SizedBox(height: 12),
                _buildCard('Breakfasts', '${byType['Breakfast'] ?? 0}'),
                const SizedBox(height: 12),
                _buildCard('Lunches', '${byType['Lunch'] ?? 0}'),
                const SizedBox(height: 12),
                _buildCard('Dinners', '${byType['Dinner'] ?? 0}'),
                const SizedBox(height: 12),
                _buildCard('Avg. calories', '$avgCalories'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
