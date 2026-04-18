import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import '../models/progress_metrics.dart';
import '../state/workout_state.dart';

void showProgressModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ProgressModal(),
  );
}

class ProgressModal extends StatefulWidget {
  const ProgressModal({super.key});

  @override
  State<ProgressModal> createState() => _ProgressModalState();
}

class _ProgressModalState extends State<ProgressModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();
  final weightController = TextEditingController();
  final bfController = TextEditingController();

  Color get primaryColor => Theme.of(context).colorScheme.primary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    weightController.dispose();
    bfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: primaryColor.withValues(alpha: 0.3), width: 2)),
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Text('Personal Progress', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
            tabs: const [
              Tab(text: 'Metrics'),
              Tab(text: 'Photos'),
              Tab(text: 'Analytics'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMetricsTab(context),
                _buildPhotosTab(context),
                _buildAnalyticsTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24.0,
        top: 24.0,
        right: 24.0,
        bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Log New Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Body Weight (kg)',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: bfController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Body Fat (%)',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (weightController.text.isNotEmpty) {
                final log = ProgressLog(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: DateTime.now(),
                  weight: double.tryParse(weightController.text) ?? 0,
                  bodyFat: double.tryParse(bfController.text) ?? 0,
                );
                WorkoutState.instance.addProgressLog(log);
                weightController.clear();
                bfController.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Metrics Logged!')));
                setState(() {});
              }
            },
            child: Text('SAVE METRICS', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 32),
          Text('Recent Entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ListenableBuilder(
            listenable: WorkoutState.instance,
            builder: (context, _) {
              final logs = WorkoutState.instance.progressLogs;
              if (logs.isEmpty) return Center(child: Padding(padding: EdgeInsets.all(16), child: Text('No entries yet.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)))));

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.monitor_weight, color: primaryColor),
                      title: Text('${log.weight} kg', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${log.date.day}/${log.date.month}/${log.date.year}'),
                      trailing: Text('${log.bodyFat}% BF', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54))),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab(BuildContext context) {
    return ListenableBuilder(
      listenable: WorkoutState.instance,
      builder: (context, _) {
        final logs = WorkoutState.instance.progressLogs.where((l) => l.photos.isNotEmpty).toList();

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Camera'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: logs.isEmpty
                    ? Center(child: Text('No photos uploaded yet.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54))))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          // Web compatibility requires network image or specific handling, 
                          // but for local mockup we assume mobile File handling.
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                kIsWeb 
                                  ? Image.network(log.photos.first.path, fit: BoxFit.cover)
                                  : Image.file(File(log.photos.first.path), fit: BoxFit.cover),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.transparent, Colors.black87],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Text('${log.date.day}/${log.date.month} - ${log.weight}kg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final logs = WorkoutState.instance.progressLogs;
        final recentWeight = logs.isNotEmpty ? logs.first.weight : 0.0;
        final recentBf = logs.isNotEmpty ? logs.first.bodyFat : 0.0;

        final log = ProgressLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now(),
          weight: recentWeight,
          bodyFat: recentBf,
          photos: [image],
        );
        WorkoutState.instance.addProgressLog(log);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image (Camera might not be supported on Windows/Web):\n$e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildAnalyticsTab(BuildContext context) {
    // Generate mock 1RM data if real history is sparse to showcase the graph capabilities
    final hasEnoughData = WorkoutState.instance.history.length > 2;

    List<FlSpot> lineSpots = [];
    if (hasEnoughData) {
      // Very basic 1RM calculation for 'first' exercise encountered
      double max1rm = 0;
      for (int i = 0; i < WorkoutState.instance.history.length; i++) {
        final session = WorkoutState.instance.history[i];
        if (session.exercises.isNotEmpty && session.exercises.first.sets.isNotEmpty) {
          final firstSet = session.exercises.first.sets.first;
          if (firstSet.weight != null && firstSet.reps != null) {
             max1rm = AnalyticsEngine.calculate1RM(firstSet.weight!, firstSet.reps!);
          }
        }
        lineSpots.add(FlSpot(i.toDouble(), max1rm));
      }
    } else {
      // Mock data for visual wow factor
      lineSpots = const [
        FlSpot(0, 60),
        FlSpot(1, 62.5),
        FlSpot(2, 65),
        FlSpot(3, 64),
        FlSpot(4, 70),
        FlSpot(5, 75),
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bench Press 1RM Estimate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Calculated via Brzycki Formula based on tracking history', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14)),
          SizedBox(height: 32),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12), strokeWidth: 1),
                  getDrawingVerticalLine: (value) => FlLine(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12), strokeWidth: 1),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: lineSpots.length > 5 ? lineSpots.length.toDouble() : 5,
                minY: 40,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: lineSpots,
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          // Additional stats card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Current 1RM', '${lineSpots.last.y.toStringAsFixed(1)} kg', primaryColor),
                Container(height: 40, width: 1, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.24)),
                _buildStatColumn('Progression', '+${(lineSpots.last.y - lineSpots.first.y).toStringAsFixed(1)} kg', Colors.greenAccent),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
