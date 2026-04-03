import 'package:flutter/material.dart';
import '../data/exercise_database.dart';
import '../state/workout_state.dart';
import '../models/workout.dart';
import '../widgets/progress_modal.dart';
import 'exercise_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hi, Athlete',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            radius: 18,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListenableBuilder(
        listenable: WorkoutState.instance,
        builder: (context, _) {
          final history = WorkoutState.instance.history;
          final now = DateTime.now();
          final weeklyWorkouts = history.where((w) => now.difference(w.date).inDays <= 7).length;
          const goal = 5;
          final progress = (weeklyWorkouts / goal).clamp(0.0, 1.0);

          final featuredExercise = ExerciseDatabase.allExercises[now.day % ExerciseDatabase.allExercises.length];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWeeklyProgress(context, weeklyWorkouts, goal, progress),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildActionCard(context, 'Start Workout', Icons.play_arrow_rounded, Theme.of(context).colorScheme.primary)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildActionCard(context, 'Quick Timer', Icons.timer_rounded, Colors.orangeAccent)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProgressCard(context),
                const SizedBox(height: 24),
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildHistorySummary(context, history.isNotEmpty ? history.first : null),
                const SizedBox(height: 24),
                const Text(
                  'Exercise of the Day',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildLibraryFeature(context, featuredExercise),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyProgress(BuildContext context, int count, int goal, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Weekly Goal', style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(count.toString(), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 32, fontWeight: FontWeight.bold)),
                  Text('/$goal Workouts', style: const TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
               fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white12,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Center(child: Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), Theme.of(context).colorScheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return GestureDetector(
      onTap: () => showProgressModal(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.primary, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personal Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('Track metrics, photos & advanced 1RM analytics', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySummary(BuildContext context, WorkoutSession? session) {
    if (session == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text('No recent activity. Time to hit the gym!', style: TextStyle(color: Colors.white54)),
      );
    }

    final diff = DateTime.now().difference(session.date);
    String timeStr;
    if (diff.inDays == 0) {
      timeStr = 'Today';
    } else if (diff.inDays == 1) {
      timeStr = 'Yesterday';
    } else {
      timeStr = '${diff.inDays} days ago';
    }

    final mins = session.durationSeconds ~/ 60;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.fitness_center, color: Colors.blueAccent)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                      Text('$timeStr • $mins mins', style: const TextStyle(color: Colors.white54, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  Widget _buildLibraryFeature(BuildContext context, ExerciseDef exercise) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
            gradient: const LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exercise.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Target: ${exercise.primaryMuscle}', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
