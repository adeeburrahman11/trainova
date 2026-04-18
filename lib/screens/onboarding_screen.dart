import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../state/workout_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _goalController = TextEditingController(text: '4');

  bool _isMetric = true;
  String _gender = 'Other';

  void _completeOnboarding() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name to continue!')),
      );
      return;
    }

    final profile = UserProfile(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 25,
      weight: double.tryParse(_weightController.text) ?? 75.0,
      height: double.tryParse(_heightController.text) ?? 175.0,
      weeklyGoalDays: int.tryParse(_goalController.text) ?? 4,
      isMetric: _isMetric,
      gender: _gender,
    );

    // This automatically triggers the router in main.dart because isFirstLaunch becomes false!
    WorkoutState.instance.updateProfile(profile);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to Trainova',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Let\'s personalize your fitness journey. Enter your base metrics below.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),

              // Measurement Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Imperial', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  Switch(
                    value: _isMetric,
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                    inactiveThumbColor: Colors.white54,
                    inactiveTrackColor: Colors.white12,
                    onChanged: (val) {
                      setState(() {
                        _isMetric = val;
                      });
                    },
                  ),
                  Text('Metric', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),

              _buildInputField('What should we call you?', _nameController, TextInputType.name, Icons.person_outline),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildInputField('Age', _ageController, TextInputType.number, Icons.cake_outlined)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _gender,
                          dropdownColor: const Color(0xFF1E1E1E),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          items: ['Male', 'Female', 'Other'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              if (val != null) _gender = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildInputField(_isMetric ? 'Weight (kg)' : 'Weight (lbs)', _weightController, const TextInputType.numberWithOptions(decimal: true), Icons.scale_outlined)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInputField(_isMetric ? 'Height (cm)' : 'Height (in)', _heightController, const TextInputType.numberWithOptions(decimal: true), Icons.height)),
                ],
              ),
              const SizedBox(height: 20),
              
              _buildInputField('Goal: Days per week to workout?', _goalController, TextInputType.number, Icons.track_changes_outlined),
              
              const SizedBox(height: 56),
              
              ElevatedButton(
                onPressed: _completeOnboarding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                ),
                child: const Text(
                  'LAUNCH TRAINOVA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller, TextInputType type, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: type,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: Colors.white12,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
