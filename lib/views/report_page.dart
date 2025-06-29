// Flutter and platform packages
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_tracker_2/models/metric_models.dart';

// App-specific imports
import '../controllers/report_controller.dart';
import '../helpers/firestore_service.dart';
import '../models/report_data_models.dart';

/// Displays a summary report of meals logged by the user
class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the currently signed-in user
    final user = FirebaseAuth.instance.currentUser;

    // If not signed in, show fallback screen
    if (user == null) {
      return _buildUnauthenticated(context);
    }

    // Create controller for fetching report data
    final controller = ReportController(FirestoreService());

    // Platform check: Render either Material or Cupertino layout
    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;

    return isIOS
        ? _buildCupertino(context, controller, user.uid)
        : _buildMaterial(context, controller, user.uid);
  }

  /// UI shown when user is not authenticated
  Widget _buildUnauthenticated(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Not signed in',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  /// Material layout for Android and web
  Widget _buildMaterial(
      BuildContext context, ReportController controller, String uid) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Meal Reports')),
      body: _body(context, controller, uid),
    );
  }

  /// Cupertino layout for iOS
  Widget _buildCupertino(
      BuildContext context, ReportController controller, String uid) {
    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Your Meal Reports')),
      child: SafeArea(child: _body(context, controller, uid)),
    );
  }

  /// Main body that fetches and displays report data
  Widget _body(BuildContext context, ReportController controller, String uid) {
    return FutureBuilder<ReportData>(
      future: controller.fetchReport(uid), // Fetch data from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Show error message if fetch failed
          return _buildError(context, snapshot.error!);
        }

        // Render report list if data is available
        final data = snapshot.data!;
        return _buildReportList(context, data);
      },
    );
  }

  /// Widget to display error messages
  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error loading reports:\n${error.toString()}',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Converts [ReportData] into a list of [Metric] objects and renders cards
  Widget _buildReportList(BuildContext context, ReportData data) {
    final metrics = <Metric>[
      Metric('Total meals logged', data.totalMeals.toString()),
      Metric('Breakfasts', data.mealsByType['Breakfast']?.toString() ?? '0'),
      Metric('Lunches', data.mealsByType['Lunch']?.toString() ?? '0'),
      Metric('Dinners', data.mealsByType['Dinner']?.toString() ?? '0'),
      Metric('Avg. calories', data.averageCalories.toString()),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: metrics.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final m = metrics[i];
        return _ReportCard(title: m.title, value: m.value);
      },
    );
  }
}

/// UI widget for rendering a single metric row as a card
class _ReportCard extends StatelessWidget {
  final String title;
  final String value;

  const _ReportCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        trailing: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
