class ExerciseSet {
  double? weight;
  int? reps;
  bool isCompleted;

  ExerciseSet({this.weight, this.reps, this.isCompleted = false});
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
}

class WorkoutSession {
  final String id;
  final String title;
  final DateTime date;
  final int durationSeconds;
  final List<TrackedExercise> exercises;

  WorkoutSession({
    required this.id,
    required this.title,
    required this.date,
    required this.durationSeconds,
    required this.exercises,
  });

  double get totalVolume {
    return exercises.fold(0, (sum, ex) => sum + ex.totalVolume);
  }

  String get summaryText {
    if (exercises.isEmpty) return 'No exercises';
    return exercises.map((e) => e.name).join(', ');
  }
}
