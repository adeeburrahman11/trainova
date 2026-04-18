import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
        title: Text('Settings'),
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
                // --- APPEARANCE SECTION ---
                Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
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
                          child: Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text('Theme Variant', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
                              ),
                              child: DropdownButton<String>(
                                value: WorkoutState.instance.themeVariant,
                                dropdownColor: Theme.of(context).colorScheme.surface,
                                icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
                                isDense: true,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 14,
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'System Default', child: Text('System Default')),
                                  DropdownMenuItem(value: 'Light', child: Text('Light')),
                                  DropdownMenuItem(value: 'Dark', child: Text('Dark')),
                                  DropdownMenuItem(value: 'AMOLED Black', child: Text('AMOLED Black')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    WorkoutState.instance.setThemeVariant(val);
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
                SizedBox(height: 32),

                // --- PREFERENCES SECTION ---
                Text(
                  'Application Preferences',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
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
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text('System of Measurement', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
                              ),
                              child: DropdownButton<bool>(
                                value: isMetric,
                                dropdownColor: Theme.of(context).colorScheme.surface,
                                icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
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
                SizedBox(height: 32),

                // --- ABOUT SECTION ---
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
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
                          child: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text('Version', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: FutureBuilder<PackageInfo>(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            String version = '...';
                            if (snapshot.hasData) {
                              version = snapshot.data!.version.isNotEmpty ? snapshot.data!.version : '1.0.0';
                            } else if (snapshot.hasError) {
                              version = '1.0.0'; // Fallback if native platform channels are out of sync
                            }
                            return Text(
                              version, 
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          },
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
