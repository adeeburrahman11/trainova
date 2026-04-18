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
              SizedBox(height: 20),
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
              SizedBox(height: 32),
              Text(
                'Welcome to Trainova',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Let\'s personalize your fitness journey. Enter your base metrics below.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                ),
              ),
              SizedBox(height: 48),

              // Measurement Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Imperial', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70), fontWeight: FontWeight.bold)),
                  Switch(
                    value: _isMetric,
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                    inactiveThumbColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                    inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                    onChanged: (val) {
                      setState(() {
                        _isMetric = val;
                      });
                    },
                  ),
                  Text('Metric', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 24),

              _buildInputField('What should we call you?', _nameController, TextInputType.name, Icons.person_outline),
              SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildInputField('Age', _ageController, TextInputType.number, Icons.cake_outlined)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _gender,
                          dropdownColor: const Color(0xFF1E1E1E),
                          icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
                          isExpanded: true,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
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
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildInputField(_isMetric ? 'Weight (kg)' : 'Weight (lbs)', _weightController, const TextInputType.numberWithOptions(decimal: true), Icons.scale_outlined)),
                  SizedBox(width: 16),
                  Expanded(child: _buildInputField(_isMetric ? 'Height (cm)' : 'Height (in)', _heightController, const TextInputType.numberWithOptions(decimal: true), Icons.height)),
                ],
              ),
              SizedBox(height: 20),
              
              _buildInputField('Goal: Days per week to workout?', _goalController, TextInputType.number, Icons.track_changes_outlined),
              
              SizedBox(height: 56),
              
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
                child: Text(
                  'LAUNCH TRAINOVA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
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
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
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
