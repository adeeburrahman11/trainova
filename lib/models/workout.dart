class ExerciseSet {
  double? weight;
  int? reps;
  bool isCompleted;

  ExerciseSet({this.weight, this.reps, this.isCompleted = false});

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'reps': reps,
      'isCompleted': isCompleted,
    };
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      reps: json['reps'] as int?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class TrackedExercise {
  String name;
  List<ExerciseSet> sets;

  TrackedExercise({required this.name, required this.sets});
  
  double get totalVolume {
    double vol = 0;
    for (var set in sets) {
      if (set.isCompleted && set.weight != null && set.reps != null) {
        vol += set.weight! * set.reps!;
      }
    }
    return vol;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets.map((s) => s.toJson()).toList(),
    };
  }

  factory TrackedExercise.fromJson(Map<String, dynamic> json) {
    return TrackedExercise(
      name: json['name'] as String,
      sets: (json['sets'] as List).map((s) => ExerciseSet.fromJson(s as Map<String, dynamic>)).toList(),
    );
  }
}

class WorkoutSession {
  final String id;
  final String title;
  final DateTime date;
  final int durationSeconds;
  final List<TrackedExercise> exercises;
  bool isFavorite;

  WorkoutSession({
    required this.id,
    required this.title,
    required this.date,
    required this.durationSeconds,
    required this.exercises,
    this.isFavorite = false,
  });

  double get totalVolume {
    return exercises.fold(0, (sum, ex) => sum + ex.totalVolume);
  }

  String get summaryText {
    if (exercises.isEmpty) return 'No exercises';
    return exercises.map((e) => e.name).join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'durationSeconds': durationSeconds,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'isFavorite': isFavorite,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      durationSeconds: json['durationSeconds'] as int,
      exercises: (json['exercises'] as List).map((e) => TrackedExercise.fromJson(e as Map<String, dynamic>)).toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
