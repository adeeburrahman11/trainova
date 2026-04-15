import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';
import '../models/progress_metrics.dart';
import '../models/user_profile.dart';

class WorkoutState extends ChangeNotifier {
  // Singleton instance for easy mockup state sharing
  static final WorkoutState instance = WorkoutState._internal();
  WorkoutState._internal();

  List<WorkoutSession> _history = [];
  List<ProgressLog> _progressLogs = [];
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

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    
    final profileStr = prefs.getString('profile');
    if (profileStr != null) {
      _profile = UserProfile.fromJson(jsonDecode(profileStr));
    }

    final historyList = prefs.getStringList('history');
    if (historyList != null) {
      _history = historyList.map((s) => WorkoutSession.fromJson(jsonDecode(s))).toList();
    }

    final logsList = prefs.getStringList('progressLogs');
    if (logsList != null) {
      _progressLogs = logsList.map((s) => ProgressLog.fromJson(jsonDecode(s))).toList();
    }
    
    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', jsonEncode(_profile.toJson()));
    await prefs.setStringList('history', _history.map((s) => jsonEncode(s.toJson())).toList());
    await prefs.setStringList('progressLogs', _progressLogs.map((s) => jsonEncode(s.toJson())).toList());
  }

  void addSession(WorkoutSession session) {
    _history.add(session);
    _saveState();
    notifyListeners();
  }

  void addProgressLog(ProgressLog log) {
    _progressLogs.add(log);
    _saveState();
    notifyListeners();
  }

  void updateProfile(UserProfile newProfile) {
    _profile = newProfile;
    _saveState();
    notifyListeners();
  }
}


