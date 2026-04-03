import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../models/progress_metrics.dart';

class WorkoutState extends ChangeNotifier {
  // Singleton instance for easy mockup state sharing
  static final WorkoutState instance = WorkoutState._internal();
  WorkoutState._internal();

  final List<WorkoutSession> _history = [];
  final List<ProgressLog> _progressLogs = [];

  List<WorkoutSession> get history => List.unmodifiable(_history.reversed);
  List<ProgressLog> get progressLogs => List.unmodifiable(_progressLogs.reversed);

  void addSession(WorkoutSession session) {
    _history.add(session);
    notifyListeners();
  }

  void addProgressLog(ProgressLog log) {
    _progressLogs.add(log);
    notifyListeners();
  }
}
