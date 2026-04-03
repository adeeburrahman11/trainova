import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../state/workout_state.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final List<TrackedExercise> _exercises = [];
  late DateTime _startTime;
  bool _isWorkoutActive = false;
  String _workoutTitle = 'Freestyle Workout';

  final List<Map<String, dynamic>> _presets = [
    {
      'title': 'Push Day',
      'subtitle': 'Chest, Shoulders & Triceps',
      'exercises': ['Barbell Bench Press', 'Incline Dumbbell Press', 'Tricep Rope Pushdown']
    },
    {
      'title': 'Pull Day',
      'subtitle': 'Back & Biceps',
      'exercises': ['Pull-Up', 'Barbell Row', 'Barbell Bicep Curl']
    },
    {
      'title': 'Leg Day',
      'subtitle': 'Quads, Hamstrings & Glutes',
      'exercises': ['Barbell Back Squat', 'Leg Press', 'Romanian Deadlift (RDL)']
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _startPresetWorkout(Map<String, dynamic> preset) {
    setState(() {
      _workoutTitle = preset['title'];
      _exercises.clear();
      for (String exName in preset['exercises']) {
        _exercises.add(TrackedExercise(
          name: exName,
          sets: [ExerciseSet(), ExerciseSet(), ExerciseSet()], // prefill 3 sets
        ));
      }
      _startTime = DateTime.now();
      _isWorkoutActive = true;
    });
  }

  void _startEmptyWorkout() {
    setState(() {
      _workoutTitle = 'Freestyle Workout';
      _exercises.clear();
      _startTime = DateTime.now();
      _isWorkoutActive = true;
    });
  }

  void _addExercise() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Add Exercise'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'e.g. Lunges'),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _exercises.add(TrackedExercise(
                      name: controller.text.trim(),
                      sets: [ExerciseSet()], // initial empty set
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
              child: const Text('Add', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      _exercises[exerciseIndex].sets.add(ExerciseSet());
    });
  }

  void _removeSet(int exerciseIndex, int setIndex) {
    setState(() {
      _exercises[exerciseIndex].sets.removeAt(setIndex);
      if (_exercises[exerciseIndex].sets.isEmpty) {
        _exercises.removeAt(exerciseIndex);
      }
    });
  }

  void _toggleSetCompleted(int exerciseIndex, int setIndex) {
    setState(() {
      _exercises[exerciseIndex].sets[setIndex].isCompleted = !_exercises[exerciseIndex].sets[setIndex].isCompleted;
    });
  }

  void _finishWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Finish Workout?'),
        content: const Text('Are you sure you want to finish this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Training', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final session = WorkoutSession(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _workoutTitle,
                  date: DateTime.now(),
                  durationSeconds: DateTime.now().difference(_startTime).inSeconds,
                  exercises: List.from(_exercises), // copy
                );
                WorkoutState.instance.addSession(session);

                _exercises.clear();
                _isWorkoutActive = false; 
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workout saved successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            child: const Text('Finish', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isWorkoutActive) {
      return _buildPresetSelectionMode(context);
    }
    return _buildActiveWorkoutMode(context);
  }

  Widget _buildPresetSelectionMode(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Workout', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _startEmptyWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('START EMPTY WORKOUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 32),
            const Text('Routines', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _presets.length,
                itemBuilder: (context, index) {
                  final preset = _presets[index];
                  return GestureDetector(
                    onTap: () => _startPresetWorkout(preset),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(preset['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(preset['subtitle'], style: const TextStyle(color: Colors.white54, fontSize: 14)),
                            ],
                          ),
                          Icon(Icons.play_circle_fill, color: Theme.of(context).colorScheme.primary, size: 36),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveWorkoutMode(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_workoutTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Cancel current workout securely
            setState(() {
              _isWorkoutActive = false;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: Text('FINISH', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: _exercises.isEmpty
                  ? const Center(
                      child: Text(
                        "No exercises added yet.\nLet's get training!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _exercises.length,
                      itemBuilder: (context, index) {
                        return _buildExerciseCard(context, index);
                      },
                    ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                foregroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('+ ADD EXERCISE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, int exerciseIndex) {
    final exercise = _exercises[exerciseIndex];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${exerciseIndex + 1}. ${exercise.name}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.redAccent),
                onPressed: () {
                  setState(() {
                    _exercises.removeAt(exerciseIndex);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Set headers
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 30, child: Text('Set', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54))),
              SizedBox(width: 70, child: Text('kg', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54))),
              SizedBox(width: 70, child: Text('Reps', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54))),
              SizedBox(width: 40, child: Icon(Icons.check, color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(exercise.sets.length, (setIndex) {
            return _buildSetRow(context, exerciseIndex, setIndex);
          }),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _addSet(exerciseIndex),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Set', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white12,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSetRow(BuildContext context, int exerciseIndex, int setIndex) {
    final set = _exercises[exerciseIndex].sets[setIndex];
    final isCompleted = set.isCompleted;

    Color checkColor = isCompleted ? Theme.of(context).colorScheme.primary : Colors.white24;
    Color rowBg = isCompleted ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent;

    return Dismissible(
      key: ValueKey('${exerciseIndex}_${setIndex}_${DateTime.now().microsecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _removeSet(exerciseIndex, setIndex),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: rowBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '${setIndex + 1}',
                style: TextStyle(fontWeight: FontWeight.bold, color: isCompleted ? Colors.white70 : Colors.white54),
              ),
            ),
            SizedBox(
              width: 70,
              child: TextFormField(
                initialValue: set.weight?.toString(),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                onChanged: (val) => set.weight = double.tryParse(val),
              ),
            ),
            SizedBox(
              width: 70,
              child: TextFormField(
                initialValue: set.reps?.toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                onChanged: (val) => set.reps = int.tryParse(val),
              ),
            ),
            IconButton(
              icon: Icon(Icons.check_circle, color: checkColor),
              onPressed: () => _toggleSetCompleted(exerciseIndex, setIndex),
            ),
          ],
        ),
      ),
    );
  }
}
