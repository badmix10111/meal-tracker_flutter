// lib/views/meal_list_page.dart

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/meal_list_controller.dart';
import '../helpers/firestore_service.dart';
import '../models/meals_models.dart';
import 'add_edit_meal_page.dart';

class MealListPage extends StatefulWidget {
  const MealListPage({Key? key}) : super(key: key);

  @override
  State<MealListPage> createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  final _controller = MealListController(FirestoreService());
  final _searchCtrl = TextEditingController();
  String? _filterType;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matchesFilter(Meal meal) {
    final matchesType = _filterType == null || meal.type == _filterType;
    final query = _searchCtrl.text.trim().toLowerCase();
    final matchesSearch =
        query.isEmpty || meal.title.toLowerCase().contains(query);
    return matchesType && matchesSearch;
  }

  Future<void> _confirmSignOut() async {
    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;

    final shouldSignOut = await (isIOS
            ? showCupertinoDialog<bool>(
                context: context,
                builder: (_) => CupertinoAlertDialog(
                  title: const Text('Confirm Sign Out'),
                  content: const Text('Are you sure you wish to sign out?'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text('Sign Out'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              )
            : showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Confirm Sign Out'),
                  content: const Text('Are you sure you wish to sign out?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: const Text('Sign Out'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              )) ??
        false;

    if (shouldSignOut) {
      try {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/sign-in');
      } catch (e) {
        _showError('Sign-out failed: $e');
      }
    }
  }

  Future<void> _handleShare(Meal meal) async {
    try {
      final text = _controller.buildShareText(meal);
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        text,
        subject: 'My meal: ${meal.title}',
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );
    } catch (e) {
      _showError('Could not share meal: $e');
    }
  }

  void _showError(String message) {
    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _unauthenticatedView();
    }

    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;

    return isIOS ? _buildCupertino(user.uid) : _buildMaterial(user.uid);
  }

  Widget _unauthenticatedView() {
    return Scaffold(
      body: Center(
        child: Text(
          'You must be signed in to see your meals.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildCupertino(String uid) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Your Meals'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.chart_bar),
              onPressed: () => Navigator.pushNamed(context, '/reports'),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.square_arrow_right),
              onPressed: _confirmSignOut,
            ),
          ],
        ),
      ),
      child: SafeArea(child: _buildBody(uid, isIOS: true)),
    );
  }

  Widget _buildMaterial(String uid) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Your Meals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Reports',
            onPressed: () => Navigator.pushNamed(context, '/reports'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: _buildBody(uid, isIOS: false),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddMeal,
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
    );
  }

  Widget _buildBody(String uid, {required bool isIOS}) {
    return Column(
      children: [
        const SizedBox(height: 12),
        _buildFilterRow(),
        const SizedBox(height: 8),
        Expanded(child: _buildMealList(uid)),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _filterType,
                  hint: const Text('All Types'),
                  isExpanded: true,
                  items: [null, 'Breakfast', 'Lunch', 'Dinner']
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t ?? 'All'),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _filterType = val),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Search by title…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealList(String uid) {
    return StreamBuilder<List<Meal>>(
      stream: _controller.mealsStream(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error loading meals:\n${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final filtered = (snapshot.data ?? []).where(_matchesFilter).toList();
        if (filtered.isEmpty) {
          return Center(
            child: Text(
              'No meals match your filters.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final meal = filtered[index];
            final time = meal.timestamp;
            final timeStr =
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                leading: meal.photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          meal.photoUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                title: Text(meal.title),
                subtitle: Text('${meal.type} • $timeStr'),
                trailing: IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () => _handleShare(meal),
                ),
                onTap: () => _goToEditMeal(meal),
              ),
            );
          },
        );
      },
    );
  }

  void _goToAddMeal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditMealPage()),
    );
  }

  void _goToEditMeal(Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditMealPage(existingMeal: meal),
      ),
    );
  }
}
