import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout.dart';
import '../state/workout_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: WorkoutState.instance,
        builder: (context, _) {
          final history = WorkoutState.instance.history;

          if (history.isEmpty) {
            return Center(
              child: Text(
                'No workout history yet.\nStart logging in the Track tab!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final session = history[index];
              return _buildHistoryCard(context, session);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, WorkoutSession session) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final formattedDate = dateFormat.format(session.date);
    
    // Format duration
    final h = session.durationSeconds ~/ 3600;
    final m = (session.durationSeconds % 3600) ~/ 60;
    final timeStr = h > 0 ? '${h}h ${m}m' : '${m}m';

    // Format volume
    final volumeStr = '${NumberFormat.compact().format(session.totalVolume)} kg';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formattedDate, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(
                  session.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: session.isFavorite ? Colors.amber : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                ),
                onPressed: () {
                  WorkoutState.instance.toggleFavorite(session.id);
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(session.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatDetail(Icons.schedule, timeStr),
              SizedBox(width: 24),
              _buildStatDetail(Icons.fitness_center, volumeStr),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
          SizedBox(height: 8),
          Text(
            session.summaryText,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueAccent),
        SizedBox(width: 8),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
