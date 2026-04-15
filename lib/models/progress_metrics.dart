import 'package:image_picker/image_picker.dart';

class ProgressLog {
  final String id;
  final DateTime date;
  final double weight; // kg
  final double bodyFat; // %
  final List<XFile> photos;

  ProgressLog({
    required this.id,
    required this.date,
    required this.weight,
    required this.bodyFat,
    this.photos = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'bodyFat': bodyFat,
      'photos': photos.map((p) => p.path).toList(),
    };
  }

  factory ProgressLog.fromJson(Map<String, dynamic> json) {
    return ProgressLog(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num).toDouble(),
      bodyFat: (json['bodyFat'] as num).toDouble(),
      photos: (json['photos'] as List? ?? []).map((p) => XFile(p as String)).toList(),
    );
  }
}

class AnalyticsEngine {
  // Brzycki Formula: Weight * (36 / (37 - Reps))
  static double calculate1RM(double weight, int reps) {
    if (reps > 30) return weight; // Formula breaks down
    return weight * (36.0 / (37.0 - reps));
  }
}
