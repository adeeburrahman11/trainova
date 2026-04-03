class ExerciseDef {
  final String id;
  final String name;
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  final String benefits;
  final String instructions;
  final String difficulty;
  final String equipment;

  const ExerciseDef({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.benefits,
    required this.instructions,
    required this.difficulty,
    required this.equipment,
  });
}

class ExerciseDatabase {
  static const List<ExerciseDef> allExercises = [
    // --- CHEST ---
    ExerciseDef(
      id: 'c1',
      name: 'Barbell Bench Press',
      primaryMuscle: 'Chest',
      secondaryMuscles: ['Triceps', 'Front Shoulders'],
      benefits: 'Supreme mass builder for the pectorals. Enhances overall upper body pressing strength and core stability.',
      instructions: 'Lie flat on the bench. Grip the bar slightly wider than shoulder-width. Lower the bar to your mid-chest, then press it back up explosively.',
      difficulty: 'Intermediate',
      equipment: 'Barbell, Bench',
    ),
    ExerciseDef(
      id: 'c2',
      name: 'Incline Dumbbell Press',
      primaryMuscle: 'Chest',
      secondaryMuscles: ['Triceps', 'Anterior Deltoid'],
      benefits: 'Focuses on the upper portion of the pectorals, creating a fuller chest appearance.',
      instructions: 'Set a bench to a 30-45 degree incline. Press dumbbells upward until arms are straight, keeping a slight bend in your elbows. Lower slowly.',
      difficulty: 'Intermediate',
      equipment: 'Dumbbells, Incline Bench',
    ),
    ExerciseDef(
      id: 'c3',
      name: 'Cable Crossover',
      primaryMuscle: 'Chest',
      secondaryMuscles: ['Shoulders'],
      benefits: 'Constant tension throughout the entire range of motion, providing a massive chest pump and targeting the inner chest.',
      instructions: 'Stand between two high cable pulleys. Pull the handles down and across your body until your hands meet in front of your hips.',
      difficulty: 'Beginner',
      equipment: 'Cable Machine',
    ),

    // --- LEGS ---
    ExerciseDef(
      id: 'l1',
      name: 'Barbell Back Squat',
      primaryMuscle: 'Legs',
      secondaryMuscles: ['Glutes', 'Lower Back', 'Core'],
      benefits: 'The king of all leg exercises. Builds foundational lower body strength, core stability, and triggers full-body muscle growth.',
      instructions: 'Rest the bar on your upper back. Keep your chest up and squat down until your thighs are parallel to the floor, then drive back up.',
      difficulty: 'Advanced',
      equipment: 'Barbell, Squat Rack',
    ),
    ExerciseDef(
      id: 'l2',
      name: 'Romanian Deadlift (RDL)',
      primaryMuscle: 'Hamstrings',
      secondaryMuscles: ['Glutes', 'Lower Back'],
      benefits: 'Excellent for targeting the posterior chain. Increases hamstring flexibility while building raw glute and back strength.',
      instructions: 'Hold a barbell with a shoulder-width grip. Hinge at the hips, keeping your legs mostly straight, until you feel a stretch in your hamstrings. Return to standing.',
      difficulty: 'Intermediate',
      equipment: 'Barbell',
    ),
    ExerciseDef(
      id: 'l3',
      name: 'Leg Press',
      primaryMuscle: 'Quads',
      secondaryMuscles: ['Hamstrings', 'Glutes'],
      benefits: 'Incredible for isolating the lower body muscles without putting strain on the lower back spine.',
      instructions: 'Sit in the machine and place your feet shoulder-width apart on the sled. Lower the weight until your knees are at 90 degrees, then press back up.',
      difficulty: 'Beginner',
      equipment: 'Leg Press Machine',
    ),

    // --- BACK ---
    ExerciseDef(
      id: 'b1',
      name: 'Pull-Up',
      primaryMuscle: 'Back',
      secondaryMuscles: ['Biceps', 'Shoulders'],
      benefits: 'The ultimate bodyweight exercise for creating the coveted V-taper back structure. Incredible for lat width.',
      instructions: 'Hang from a bar with a wide grip. Pull your body up until your chin clears the bar, focusing on driving your elbows down into your pockets.',
      difficulty: 'Intermediate',
      equipment: 'Pull-Up Bar',
    ),
    ExerciseDef(
      id: 'b2',
      name: 'Barbell Row',
      primaryMuscle: 'Back',
      secondaryMuscles: ['Biceps', 'Lower Back', 'Core'],
      benefits: 'Builds phenomenal back thickness, rear deltoid strength, and reinforces postural stability.',
      instructions: 'Bend your knees slightly and hinge forward at the hips. Pull the bar towards your lower stomach, squeezing your shoulder blades together.',
      difficulty: 'Intermediate',
      equipment: 'Barbell',
    ),
    ExerciseDef(
      id: 'b3',
      name: 'Lat Pulldown',
      primaryMuscle: 'Back',
      secondaryMuscles: ['Biceps'],
      benefits: 'Excellent progression tool for pull-ups. Allows for focused lat isolation and controlled eccentric stretching.',
      instructions: 'Sit at the machine with a wide grip on the bar. Pull the bar down to your upper chest while leaning slightly back.',
      difficulty: 'Beginner',
      equipment: 'Cable Machine',
    ),

    // --- ARMS ---
    ExerciseDef(
      id: 'a1',
      name: 'Barbell Bicep Curl',
      primaryMuscle: 'Biceps',
      secondaryMuscles: ['Forearms'],
      benefits: 'The gold standard for adding raw size and strength to the biceps.',
      instructions: 'Stand straight holding a barbell with a shoulder-width underhand grip. Curl the weight up towards your shoulders without swinging your back.',
      difficulty: 'Beginner',
      equipment: 'Barbell',
    ),
    ExerciseDef(
      id: 'a2',
      name: 'Tricep Rope Pushdown',
      primaryMuscle: 'Triceps',
      secondaryMuscles: [],
      benefits: 'Isolates the triceps perfectly with constant tension, helping to build the "horseshoe" shape on the back of the arm.',
      instructions: 'Attach a rope to a high pulley. Keep your elbows glued to your sides and push the rope down until your arms are fully extended. Spread the rope at the bottom.',
      difficulty: 'Beginner',
      equipment: 'Cable Machine, Rope Attachment',
    ),

    // --- CORE ---
    ExerciseDef(
      id: 'co1',
      name: 'Hanging Leg Raise',
      primaryMuscle: 'Core',
      secondaryMuscles: ['Hip Flexors', 'Forearms'],
      benefits: 'Develops incredible lower abdominal strength and grip endurance simultaneously.',
      instructions: 'Hang from a pull-up bar. Keeping your legs straight, raise them until they are parallel to the floor, then lower them slowly.',
      difficulty: 'Advanced',
      equipment: 'Pull-Up Bar',
    ),
  ];

  static List<String> get categories {
    return allExercises.map((e) => e.primaryMuscle).toSet().toList();
  }

  static List<ExerciseDef> getExercisesByCategory(String category) {
    if (category == 'All') return allExercises;
    return allExercises.where((e) => e.primaryMuscle == category).toList();
  }
}
