import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../state/workout_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isCheckingUpdate = false;

  Future<void> _checkForUpdate() async {
    setState(() => _isCheckingUpdate = true);
    try {
      final response = await http.get(Uri.parse('https://api.github.com/repos/adeeburrahman11/trainova/releases/latest'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = data['tag_name'].toString().replaceAll('v', '');
        final releaseUrl = 'https://github.com/adeeburrahman11/trainova/releases/download/${data['tag_name']}/Trainova.apk';
        
        String currentVersion = '1.0.0';
        try {
          final packageInfo = await PackageInfo.fromPlatform();
          if (packageInfo.version.isNotEmpty) currentVersion = packageInfo.version;
        } catch (_) {} // Handle MissingPluginException if session isn't restarted

        if (!mounted) return;
        
        if (latestVersion != currentVersion) {
          showDialog(context: context, builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text('Update Available!'),
            content: Text('A new version ($latestVersion) is available on GitHub. You are running $currentVersion.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Later', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)))),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final url = Uri.parse(releaseUrl);
                  if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                child: Text('Download', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ]
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trainova is up to date!')));
        }
      } else if (response.statusCode == 404) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No releases published yet on GitHub!')));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to check for updates. Status: ${response.statusCode}')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network error checking for updates.')));
    } finally {
      if (mounted) setState(() => _isCheckingUpdate = false);
    }
  }

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
                      Divider(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12), height: 1),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.system_update_alt_rounded, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text('Check for Updates', style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: _isCheckingUpdate 
                            ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                            : Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
                        onTap: _isCheckingUpdate ? null : _checkForUpdate,
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
