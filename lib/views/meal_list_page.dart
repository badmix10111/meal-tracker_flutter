// // // import 'package:flutter/material.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
// // // import 'package:meal_tracker_flutter/models/meals_models.dart';
// // // import 'package:meal_tracker_flutter/views/add_edit_meal_page.dart';

// // // class MealListPage extends StatelessWidget {
// // //   const MealListPage({Key? key}) : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final user = FirebaseAuth.instance.currentUser;
// // //     if (user == null) {
// // //       return const Scaffold(
// // //         body: Center(child: Text('Not authenticated')),
// // //       );
// // //     }
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Your Meals'),
// // //       ),
// // //       body: StreamBuilder<List<Meal>>(
// // //         stream: FirestoreService().streamMealsForUser(user.uid),
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }
// // //           if (snapshot.hasError) {
// // //             return Center(child: Text('Error: \${snapshot.error}'));
// // //           }
// // //           final meals = snapshot.data;
// // //           if (meals == null || meals.isEmpty) {
// // //             return const Center(child: Text('No meals tracked yet.'));
// // //           }
// // //           return ListView.builder(
// // //             itemCount: meals.length,
// // //             itemBuilder: (context, index) {
// // //               final meal = meals[index];
// // //               return ListTile(
// // //                 leading: meal.photoUrl != null
// // //                     ? Image.network(meal.photoUrl!,
// // //                         width: 56, height: 56, fit: BoxFit.cover)
// // //                     : const Icon(Icons.fastfood),
// // //                 title: Text(meal.title),
// // //                 subtitle: Text(
// // //                   "${meal.type} • ${meal.timestamp.hour.toString().padLeft(2, '0')}:${meal.timestamp.minute.toString().padLeft(2, '0')}",
// // //                 ),
// // //                 onTap: () {
// // //                   Navigator.push(
// // //                     context,
// // //                     MaterialPageRoute(
// // //                       builder: (_) => AddEditMealPage(existingMeal: meal),
// // //                     ),
// // //                   );
// // //                 },
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         child: const Icon(Icons.add),
// // //         onPressed: () {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(builder: (_) => const AddEditMealPage()),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // // lib/screens/meal_list_page.dart
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
// // import 'package:meal_tracker_flutter/models/meals_models.dart';

// // import 'add_edit_meal_page.dart';

// // class MealListPage extends StatelessWidget {
// //   const MealListPage({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) {
// //       return const Scaffold(
// //         body: Center(child: Text('Not authenticated')),
// //       );
// //     }
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Your Meals'),
// //       ),
// //       body: StreamBuilder<List<Meal>>(
// //         stream: FirestoreService().streamMealsForUser(user.uid),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           if (snapshot.hasError) {
// //             var c = snapshot.error.toString();
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           }
// //           final meals = snapshot.data;
// //           if (meals == null || meals.isEmpty) {
// //             return const Center(child: Text('No meals tracked yet.'));
// //           }
// //           return ListView.builder(
// //             itemCount: meals.length,
// //             itemBuilder: (context, index) {
// //               final meal = meals[index];
// //               return ListTile(
// //                 leading: meal.photoUrl != null
// //                     ? Image.network(
// //                         meal.photoUrl!,
// //                         width: 56,
// //                         height: 56,
// //                         fit: BoxFit.cover,
// //                       )
// //                     : const Icon(Icons.fastfood),
// //                 title: Text(meal.title),
// //                 subtitle: Text(
// //                   "${meal.type} • ${meal.timestamp.hour.toString().padLeft(2, '0')}:"
// //                   "${meal.timestamp.minute.toString().padLeft(2, '0')}",
// //                 ),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (_) => AddEditMealPage(existingMeal: meal),
// //                     ),
// //                   );
// //                 },
// //               );
// //             },
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         child: const Icon(Icons.add),
// //         onPressed: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (_) => const AddEditMealPage()),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
// import 'package:meal_tracker_flutter/models/meals_models.dart';
// import 'package:share_plus/share_plus.dart';

// import 'add_edit_meal_page.dart';

// class MealListPage extends StatelessWidget {
//   const MealListPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text('Not authenticated')),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Meals'),
//       ),
//       body: StreamBuilder<List<Meal>>(
//         stream: FirestoreService().streamMealsForUser(user.uid),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             final err = snapshot.error;
//             String msg;
//             if (err is FirebaseException) {
//               msg = err.message ?? err.toString();
//             } else {
//               msg = err.toString();
//             }
//             return Center(child: Text('Error: \$msg'));
//           }
//           final meals = snapshot.data;
//           if (meals == null || meals.isEmpty) {
//             return const Center(child: Text('No meals tracked yet.'));
//           }
//           return ListView.builder(
//             itemCount: meals.length,
//             itemBuilder: (context, index) {
//               final meal = meals[index];
//               // Build share text summary
//               final timestamp = meal.timestamp;
//               final timeStr =
//                   '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
//               final shareText = (StringBuffer()
//                     ..write('I just had a ${meal.title} (')
//                     ..write(meal.type)
//                     ..write(') at $timeStr')
//                     ..write(meal.calories != null
//                         ? ' with ${meal.calories} calories.'
//                         : '.'))
//                   .toString();

//               return ListTile(
//                 leading: meal.photoUrl != null
//                     ? Image.network(
//                         meal.photoUrl!,
//                         width: 56,
//                         height: 56,
//                         fit: BoxFit.cover,
//                       )
//                     : const Icon(Icons.fastfood),
//                 title: Text(meal.title),
//                 subtitle: Text(
//                   '${meal.type} • $timeStr',
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.share),
//                   onPressed: () {
//                     Share.share(shareText);
//                   },
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => AddEditMealPage(existingMeal: meal),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddEditMealPage()),
//           );
//         },
//       ),
//     );
//   }
// }
// lib/screens/meal_list_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
import 'package:meal_tracker_flutter/models/meals_models.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // for FirebaseException

import 'add_edit_meal_page.dart';

class MealListPage extends StatefulWidget {
  const MealListPage({Key? key}) : super(key: key);

  @override
  _MealListPageState createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  String? _filterType;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }
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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/sign-in');
            },
          ),
        ],
      ),

      // appBar: AppBar(
      //   title: const Text('Your Meals'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       tooltip: 'Sign Out',
      //       onPressed: () async {
      //         await FirebaseAuth.instance.signOut();
      //         Navigator.pushReplacementNamed(context, '/sign-in');
      //       },
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String?>(
                  value: _filterType,
                  hint: const Text('All'),
                  items: <String?>[null, 'Breakfast', 'Lunch', 'Dinner']
                      .map((type) => DropdownMenuItem<String?>(
                            value: type,
                            child: Text(type ?? 'All'),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _filterType = val),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by title...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          // Meal list
          Expanded(
            child: StreamBuilder<List<Meal>>(
              stream: FirestoreService().streamMealsForUser(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  final err = snapshot.error;
                  String msg;
                  if (err is FirebaseException) {
                    msg = err.message ?? err.toString();
                  } else {
                    msg = err.toString();
                  }
                  return Center(child: Text('Error: $msg'));
                }
                final meals = snapshot.data ?? [];
                // Apply filters
                final filtered = meals.where((meal) {
                  final matchesType =
                      _filterType == null || meal.type == _filterType;
                  final query = _searchController.text.toLowerCase();
                  final matchesSearch =
                      query.isEmpty || meal.title.toLowerCase().contains(query);
                  return matchesType && matchesSearch;
                }).toList();
                if (filtered.isEmpty) {
                  return const Center(
                      child: Text('No meals match your filters.'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final meal = filtered[index];
                    final timestamp = meal.timestamp;
                    final timeStr =
                        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
                    final shareText = (StringBuffer()
                          ..write('I just had a ${meal.title} (')
                          ..write(meal.type)
                          ..write(') at $timeStr')
                          ..write(meal.calories != null
                              ? ' with ${meal.calories} calories.'
                              : '.'))
                        .toString();

                    return ListTile(
                        leading: meal.photoUrl != null
                            ? Image.network(
                                meal.photoUrl!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.fastfood),
                        title: Text(meal.title),
                        subtitle: Text('${meal.type} • $timeStr'),
                        trailing: IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () => Share.share(shareText),
                        ),
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddEditMealPage(existingMeal: meal),
                              ),
                            ));
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddEditMealPage(),
          ),
        ),
      ),
    );
  }
}
