import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../state/workout_state.dart';

class FeatureRequestScreen extends StatefulWidget {
  const FeatureRequestScreen({super.key});

  @override
  State<FeatureRequestScreen> createState() => _FeatureRequestScreenState();
}

class _FeatureRequestScreenState extends State<FeatureRequestScreen> {
  final emailController = TextEditingController();
  final feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    emailController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    const String scriptUrl =
        'https://script.google.com/macros/s/AKfycbyvL-sbaLsVB9xYkMrYSbsdmrU88u1eTPqp8D5zEGi0OWV4gmkoR9PCmPSp0MSwuk8HIQ/exec';

    if (emailController.text.trim().isEmpty || feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide your email and describe your feature request.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final String userName = WorkoutState.instance.profile.name.isNotEmpty 
          ? WorkoutState.instance.profile.name 
          : 'Anonymous';
      final String userEmail = emailController.text.trim();
          
      if (scriptUrl != 'YOUR_GOOGLE_APPS_SCRIPT_WEB_APP_URL') {
        await http.post(
          Uri.parse(scriptUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': userName,
            'email': userEmail,
            'feedback': feedbackController.text.trim(),
          }),
        );
      } else {
        await Future.delayed(const Duration(seconds: 1)); 
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you! Your feature request has been summitted.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feature Request', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 36, color: Colors.amber),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Have an idea?',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Share your feature suggestions with us!',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              
              // Email Label
              Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'john@example.com',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Input Label
              Text(
                'Describe your feature request',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              
              // Text Area
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)),
                ),
                child: TextField(
                  controller: feedbackController,
                  maxLines: null,
                  expands: true,
                  maxLength: 1000,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Example: It would be great if the app had a dark mode toggle...',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded),
                          SizedBox(width: 12),
                          Text('Submit Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
              ),
              
              SizedBox(height: 16),
              
              // Footer text
              Center(
                child: Text(
                  'Your feedback helps us improve Trainova!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
