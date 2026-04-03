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
}

class AnalyticsEngine {
  // Brzycki Formula: Weight * (36 / (37 - Reps))
  static double calculate1RM(double weight, int reps) {
    if (reps > 30) return weight; // Formula breaks down
    return weight * (36.0 / (37.0 - reps));
  }
}
