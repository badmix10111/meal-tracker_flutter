import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String type;
  final String title;
  final String description;
  final String portion;
  final DateTime timestamp;
  final int? calories;
  final int? protein;
  final int? carbs;
  final int? fats;
  final String? photoUrl;

  Meal({
    this.id = '',
    required this.type,
    required this.title,
    required this.description,
    required this.portion,
    required this.timestamp,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.photoUrl,
  });

  /// Clone this Meal, replacing only the given fields.
  Meal copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? portion,
    DateTime? timestamp,
    int? calories,
    int? protein,
    int? carbs,
    int? fats,
    String? photoUrl,
  }) {
    return Meal(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      portion: portion ?? this.portion,
      timestamp: timestamp ?? this.timestamp,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'type': type,
        'title': title,
        'description': description,
        'portion': portion,
        'timestamp': timestamp.toIso8601String(),
        if (calories != null) 'calories': calories,
        if (protein != null) 'protein': protein,
        if (carbs != null) 'carbs': carbs,
        if (fats != null) 'fats': fats,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };

// …

  factory Meal.fromFirestore(Map<String, dynamic> data, String docId) {
    final rawTs = data['timestamp'];
    final dateTime =
        rawTs is Timestamp ? rawTs.toDate() : DateTime.parse(rawTs as String);

    return Meal(
      id: docId,
      type: data['type'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      portion: (data['portion'] as String?) ?? '',
      timestamp: dateTime,
      calories: data['calories'] as int?,
      protein: data['protein'] as int?,
      carbs: data['carbs'] as int?,
      fats: data['fats'] as int?,
      photoUrl: data['photoUrl'] as String?,
    );
  }
}
