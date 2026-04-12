import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../models/progress_metrics.dart';
import '../models/user_profile.dart';

class WorkoutState extends ChangeNotifier {
  // Singleton instance for easy mockup state sharing
  static final WorkoutState instance = WorkoutState._internal();
  WorkoutState._internal();

  final List<WorkoutSession> _history = [];
  final List<ProgressLog> _progressLogs = [];
  UserProfile _profile = UserProfile(
    name: 'Athlete',
    age: 25,
    weight: 75.0,
    height: 175.0,
    weeklyGoalDays: 5,
  );

  List<WorkoutSession> get history => List.unmodifiable(_history.reversed);
  List<ProgressLog> get progressLogs => List.unmodifiable(_progressLogs.reversed);
  UserProfile get profile => _profile;

  void addSession(WorkoutSession session) {
    _history.add(session);
    notifyListeners();
  }

  void addProgressLog(ProgressLog log) {
    _progressLogs.add(log);
    notifyListeners();
  }

  void updateProfile(UserProfile newProfile) {
    _profile = newProfile;
    notifyListeners();
  }
}

