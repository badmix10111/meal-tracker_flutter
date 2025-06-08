// lib/views/report_page.dart

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_tracker_flutter/models/metric_models.dart';

import '../controllers/report_controller.dart';
import '../helpers/firestore_service.dart';
import '../models/report_data_models.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildUnauthenticated(context);
    }

    final controller = ReportController(FirestoreService());

    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;
    return isIOS
        ? _buildCupertino(context, controller, user.uid)
        : _buildMaterial(context, controller, user.uid);
  }

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

  // Material layout
  Widget _buildMaterial(
      BuildContext context, ReportController controller, String uid) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Meal Reports')),
      body: _body(context, controller, uid),
    );
  }

  // Cupertino layout
  Widget _buildCupertino(
      BuildContext context, ReportController controller, String uid) {
    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Your Meal Reports')),
      child: SafeArea(child: _body(context, controller, uid)),
    );
  }

  Widget _body(BuildContext context, ReportController controller, String uid) {
    return FutureBuilder<ReportData>(
      future: controller.fetchReport(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildError(context, snapshot.error!);
        }
        final data = snapshot.data!;
        return _buildReportList(context, data);
      },
    );
  }

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

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;

  const _ReportCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

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
