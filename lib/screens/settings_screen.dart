import 'package:flutter/material.dart';
import '../state/workout_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  void _changeMeasurementSystem(bool newIsMetric) {
    final currentProfile = WorkoutState.instance.profile;
    if (newIsMetric == currentProfile.isMetric) return;

    double newWeight;
    double newHeight;

    if (newIsMetric) {
      // Imperial (lbs/in) to Metric (kg/cm)
      newWeight = currentProfile.weight * 0.453592;
      newHeight = currentProfile.height * 2.54;
    } else {
      // Metric (kg/cm) to Imperial (lbs/in)
      newWeight = currentProfile.weight * 2.20462;
      newHeight = currentProfile.height * 0.393701;
    }

    final updatedProfile = currentProfile.copyWith(
      isMetric: newIsMetric,
      weight: double.parse(newWeight.toStringAsFixed(1)), // Keep it to 1 decimal point
      height: double.parse(newHeight.toStringAsFixed(1)),
    );

    WorkoutState.instance.updateProfile(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: WorkoutState.instance,
        builder: (context, _) {
          final isMetric = WorkoutState.instance.profile.isMetric;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Application Preferences',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.straighten_rounded, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text('System of Measurement', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: DropdownButton<bool>(
                                value: isMetric,
                                dropdownColor: const Color(0xFF1E1E1E),
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
                                isDense: true,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 14,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text('Metric (kg/cm)'),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text('Imperial (lbs/inches)'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    _changeMeasurementSystem(val);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Converted to ${val ? 'Metric' : 'Imperial'} units successfully!')),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
