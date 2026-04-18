
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/exercise_database.dart';
import '../state/workout_state.dart';
import '../models/workout.dart';
import '../widgets/progress_modal.dart';
import 'exercise_detail_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'favourites_screen.dart';
import 'feature_request_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const DashboardScreen({super.key, this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _hasUnreadNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ListenableBuilder(
          listenable: WorkoutState.instance,
          builder: (context, _) {
            return Text(
              'Hi, ${WorkoutState.instance.profile.name}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _hasUnreadNotification,
              smallSize: 8,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.notifications_none_rounded),
            ),
            onPressed: () {
              setState(() {
                _hasUnreadNotification = false;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Text('New Notification'),
                    content: Text.rich(
                      TextSpan(
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70)),
                        children: [
                          const TextSpan(
                            text:
                                'Note: This app is in development. Some features may not work as expected. Please give feedback to improve the app. Thank you for using Trainova!🖤\n Author: ',
                          ),
                          TextSpan(
                            text: 'Adeebur Rahman',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = Uri.parse(
                                  'https://adeeburrahman.vercel.app/',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close notification dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FeatureRequestScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                          elevation: 0,
                          side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.24)),
                        ),
                        child: Text('Give Feedback'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            color: Theme.of(context).colorScheme.surface,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
            ),
            onSelected: (value) {
              if (value == 'Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              } else if (value == 'Settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              } else if (value == 'Favourites') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouritesScreen(),
                  ),
                );
              } else if (value == 'Feature Request') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeatureRequestScreen(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Theme.of(context).colorScheme.primary),
                    SizedBox(width: 12),
                    Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Favourites',
                child: Row(
                  children: [
                    Icon(Icons.star_border_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
                    SizedBox(width: 12),
                    Text('Favourites', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
                    SizedBox(width: 12),
                    Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 1),
              const PopupMenuItem<String>(
                value: 'Feature Request',
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber),
                    SizedBox(width: 12),
                    Text('Feature Request', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: WorkoutState.instance,
        builder: (context, _) {
          final history = WorkoutState.instance.history;
          final now = DateTime.now();
          final weeklyWorkouts = history
              .where((w) => now.difference(w.date).inDays <= 7)
              .length;
          final goal = WorkoutState.instance.profile.weeklyGoalDays;
          final progress = goal > 0
              ? (weeklyWorkouts / goal).clamp(0.0, 1.0)
              : 0.0;

          final featuredExercise = ExerciseDatabase
              .allExercises[now.day % ExerciseDatabase.allExercises.length];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWeeklyProgress(context, weeklyWorkouts, goal, progress),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onNavigate?.call(1),
                        child: _buildActionCard(
                          context,
                          'Start Workout',
                          Icons.play_arrow_rounded,
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onNavigate?.call(3),
                        child: _buildActionCard(
                          context,
                          'Rest Timer',
                          Icons.timer_rounded,
                          Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildProgressCard(context),
                SizedBox(height: 24),
                Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _buildHistorySummary(
                  context,
                  history.isNotEmpty ? history.first : null,
                ),
                SizedBox(height: 24),
                Text(
                  'Exercise of the Day',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _buildLibraryFeature(context, featuredExercise),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyProgress(
    BuildContext context,
    int count,
    int goal,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Goal',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70), fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/$goal Workouts',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18),
                  ),
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
                  backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                  color: Theme.of(context).colorScheme.primary,
                ),
                Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.2),
            Theme.of(context).colorScheme.surface,
          ],
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
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
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
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bar_chart,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Progress',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Track metrics, photos & advanced 1RM analytics',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70), fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
              size: 16,
            ),
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
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'No recent activity. Time to hit the gym!',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
        ),
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                  child: Icon(Icons.fitness_center, color: Colors.blueAccent),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$timeStr • $mins mins',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
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
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.surface, Colors.transparent],
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
              Text(
                exercise.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Target: ${exercise.primaryMuscle}',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70)),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
