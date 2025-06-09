import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/meal_list_controller.dart';
import '../helpers/firestore_service.dart';
import '../models/meals_models.dart';
import 'add_edit_meal_page.dart';

// This page displays a list of meals for the authenticated user,
// allowing filtering, searching, sharing, and navigation to reports.
class MealListPage extends StatefulWidget {
  const MealListPage({Key? key}) : super(key: key);

  @override
  State<MealListPage> createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  final _controller = MealListController(FirestoreService());
  final _searchCtrl = TextEditingController();
  String? _filterType; // 'Breakfast', 'Lunch', or 'Dinner'

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Filter meals based on selected type and search input
  bool _matchesFilter(Meal meal) {
    final matchesType = _filterType == null || meal.type == _filterType;
    final query = _searchCtrl.text.trim().toLowerCase();
    final matchesSearch =
        query.isEmpty || meal.title.toLowerCase().contains(query);
    return matchesType && matchesSearch;
  }

  /// Confirm sign-out from user and perform sign-out if accepted
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

  /// Safely share a meal using the latest SharePlus API with error handling
  Future<void> _handleShare(Meal meal) async {
    try {
      // Build the text to share
      final text = _controller.buildShareText(meal);
      final subject = 'My meal: ${meal.title}';

      // Try to get the render box for share origin positioning (can be null)
      final box = context.findRenderObject() as RenderBox?;

      // Use SharePlus instance API with new ShareParams
      final result = await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
          sharePositionOrigin:
              box != null ? box.localToGlobal(Offset.zero) & box.size : null,
        ),
      );

      // Optional: handle result
      switch (result.status) {
        case ShareResultStatus.success:
          debugPrint('✅ Share completed successfully');
          break;
        case ShareResultStatus.dismissed:
          debugPrint('ℹ️ Share dismissed by user');
          break;
        case ShareResultStatus.unavailable:
          _showError('Sharing is not available on this device.');
          break;
      }
    } on PlatformException catch (e) {
      // Catch platform-specific exceptions (e.g. share service crash)
      _showError('Platform error: ${e.message}');
    } catch (e) {
      // Catch any other unexpected errors
      _showError('An unexpected error occurred: $e');
    }
  }

  /// Display error to user based on platform style
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

    // Fallback if no user is signed in
    if (user == null) return _unauthenticatedView();

    final isIOS =
        Theme.of(context).platform == TargetPlatform.iOS || Platform.isIOS;

    return isIOS ? _buildCupertino(user.uid) : _buildMaterial(user.uid);
  }

  /// UI if user is not authenticated
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

  /// Cupertino layout with an Add-Meal button added
  Widget _buildCupertino(String uid) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Your Meals'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add Meal
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add),
              onPressed: _goToAddMeal,
            ),
            // Reports
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.chart_bar),
              onPressed: () => Navigator.pushNamed(context, '/reports'),
            ),
            // Sign Out
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.square_arrow_right),
              onPressed: _confirmSignOut,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: _buildBody(uid),
        ),
      ),
    );
  }

  /// Material layout
  Widget _buildMaterial(String uid) {
    return Scaffold(
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
      body: _buildBody(uid),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddMeal,
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
    );
  }

  /// Main content layout, scrollable and responsive
  Widget _buildBody(String uid) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.05;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight * 0.8),
        child: Column(
          children: [
            _buildFilterRow(),
            const SizedBox(height: 12),
            SizedBox(
              height: screenHeight * 0.7,
              child: _buildMealList(uid),
            ),
          ],
        ),
      ),
    );
  }

  /// Dropdown + search row that adapts to screen size
  Widget _buildFilterRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return Row(
          children: [
            // Dropdown filter
            Flexible(
              flex: isWide ? 1 : 2,
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            // Search input
            Flexible(
              flex: isWide ? 2 : 3,
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
        );
      },
    );
  }

  /// Builds and filters the meal list with scrollable layout
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
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final meal = filtered[index];
            final time = meal.timestamp;
            final timeStr =
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                leading: meal.photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          meal.photoUrl!,
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.fastfood,
                        size: MediaQuery.of(context).size.width * 0.10,
                        color: Colors.grey),
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

  /// Navigate to add new meal
  void _goToAddMeal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditMealPage()),
    );
  }

  /// Navigate to edit existing meal
  void _goToEditMeal(Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditMealPage(existingMeal: meal),
      ),
    );
  }
}
