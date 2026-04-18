import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _durationSeconds = 60;
  int _remainingSeconds = 60;
  bool _isRunning = false;

  final List<Map<String, dynamic>> _presets = [
    {'label': '30s\nQuick', 'seconds': 30},
    {'label': '60s\nRest', 'seconds': 60},
    {'label': '90s\nHeavy', 'seconds': 90},
    {'label': '2m\nRecovery', 'seconds': 120},
    {'label': '3m\nPower', 'seconds': 180},
    {'label': '5m\nMax', 'seconds': 300},
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_remainingSeconds > 0) {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _stopTimer();
            // Optional: Play a sound or vibrate here in the future
          }
        });
      });
    }
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _remainingSeconds = _durationSeconds;
    });
  }

  void _setPreset(int seconds) {
    _stopTimer();
    setState(() {
      _durationSeconds = seconds;
      _remainingSeconds = seconds;
    });
  }

  void _customTimerDialog() {
    Duration customDuration = Duration(seconds: _durationSeconds);
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext builder) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 16)),
                  ),
                  Text('Custom Timer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      if (customDuration.inSeconds > 0) {
                        _setPreset(customDuration.inSeconds);
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Done', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      pickerTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 22),
                    ),
                  ),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.ms,
                    initialTimerDuration: Duration(seconds: _durationSeconds),
                    onTimerDurationChanged: (Duration newDuration) {
                      customDuration = newDuration;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _durationSeconds > 0 
        ? _remainingSeconds / _durationSeconds 
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rest Timer', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'of ${_formatTime(_durationSeconds)}',
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: Icons.refresh,
                onPressed: _resetTimer,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              SizedBox(width: 32),
              _buildControlButton(
                icon: _isRunning ? Icons.pause : Icons.play_arrow,
                onPressed: _isRunning ? _stopTimer : _startTimer,
                color: Colors.black,
                backgroundColor: Theme.of(context).colorScheme.primary,
                size: 80,
                iconSize: 40,
              ),
              SizedBox(width: 32),
              _buildControlButton(
                icon: Icons.edit,
                onPressed: _customTimerDialog,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ],
          ),
          SizedBox(height: 40),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Presets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.antiAlias,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: _presets.length,
                      itemBuilder: (context, index) {
                        final preset = _presets[index];
                        final bool isSelected = _durationSeconds == preset['seconds'];
                        return GestureDetector(
                          onTap: () => _setPreset(preset['seconds']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2) : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                preset['label'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required Color backgroundColor,
    double size = 60,
    double iconSize = 28,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
