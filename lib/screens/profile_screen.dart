import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../state/workout_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _goalController;
  bool _isMetric = true;
  String _gender = 'Other';

  @override
  void initState() {
    super.initState();
    final profile = WorkoutState.instance.profile;
    _nameController = TextEditingController(text: profile.name);
    _ageController = TextEditingController(text: profile.age.toString());
    _weightController = TextEditingController(text: profile.weight.toString());
    _heightController = TextEditingController(text: profile.height.toString());
    _goalController = TextEditingController(text: profile.weeklyGoalDays.toString());
    _isMetric = profile.isMetric;
    _gender = profile.gender;
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

  void _saveProfile() {
    final profile = UserProfile(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 25,
      weight: double.tryParse(_weightController.text) ?? 75.0,
      height: double.tryParse(_heightController.text) ?? 175.0,
      weeklyGoalDays: int.tryParse(_goalController.text) ?? 5,
      isMetric: _isMetric,
      gender: _gender,
    );

    WorkoutState.instance.updateProfile(profile);
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text('Save', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          SizedBox(width: 8)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            _buildTextField('Name', _nameController, TextInputType.name),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField('Age (yrs)', _ageController, TextInputType.number)),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _gender,
                        dropdownColor: const Color(0xFF1E1E1E),
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
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField(_isMetric ? 'Weight (kg)' : 'Weight (lbs)', _weightController, const TextInputType.numberWithOptions(decimal: true))),
                SizedBox(width: 16),
                Expanded(child: _buildTextField(_isMetric ? 'Height (cm)' : 'Height (in)', _heightController, const TextInputType.numberWithOptions(decimal: true))),
              ],
            ),
            SizedBox(height: 16),
            _buildTextField('Goal (days/wk)', _goalController, TextInputType.number),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}
