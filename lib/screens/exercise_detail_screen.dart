import 'package:flutter/material.dart';
import '../data/exercise_database.dart';
import '../state/workout_state.dart';
import '../models/workout.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseDef exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                exercise.name,
                style: TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(color: Theme.of(context).brightness == Brightness.light ? Colors.transparent : Colors.black, blurRadius: 10)]),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.6), Theme.of(context).colorScheme.surface],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 100,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildChip(context, Icons.bolt, exercise.difficulty, Colors.amber),
                      _buildChip(context, Icons.accessibility_new, exercise.primaryMuscle, Theme.of(context).colorScheme.primary),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text('Benefits', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 8),
                  Text(
                    exercise.benefits,
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70), height: 1.5),
                  ),
                  SizedBox(height: 32),
                  Text('Instructions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 8),
                  Text(
                    exercise.instructions,
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70), height: 1.5),
                  ),
                  SizedBox(height: 32),
                  Text('Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 16),
                  _buildDetailRow(context, Icons.build, 'Required Equipment', exercise.equipment),
                  SizedBox(height: 16),
                  _buildDetailRow(context, Icons.group_work, 'Secondary Muscles', exercise.secondaryMuscles.isEmpty ? 'None' : exercise.secondaryMuscles.join(', ')),
                  SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () {
                      if (WorkoutState.instance.isWorkoutActive) {
                        WorkoutState.instance.addActiveExercise(TrackedExercise(name: exercise.name, sets: [ExerciseSet()]));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${exercise.name} added to current workout!')),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            title: Text('No Active Workout'),
                            content: Text('You don\'t have a workout currently running. Start a Freestyle Workout with this exercise?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54))),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // close dialog
                                  Navigator.pop(context); // close detail screen
                                  WorkoutState.instance.startActiveWorkout(
                                    'Freestyle Workout', 
                                    exercises: [TrackedExercise(name: exercise.name, sets: [ExerciseSet()])]
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                                child: Text('Start', style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('ADD TO WORKOUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), size: 24),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
