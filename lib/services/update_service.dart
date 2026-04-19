import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null && response.payload!.startsWith('http')) {
          final url = Uri.parse(response.payload!);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        }
      },
    );

    // Request Android 13+ permissions
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> checkForUpdatesBg() async {
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
        } catch (_) {}

        if (latestVersion != currentVersion && latestVersion != '1.0.0') {
          // Trigger notification
          await _showUpdateNotification(latestVersion, releaseUrl);
        }
      }
    } catch (e) {
      // Fail silently in background
    }
  }

  static Future<void> _showUpdateNotification(String version, String payloadUrl) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'trainova_updates',
      'App Updates',
      channelDescription: 'Notifications for Trainova OTA updates.',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: 0,
      title: 'Update Available! 🚀',
      body: 'Trainova version $version is now available. Tap to download.',
      notificationDetails: platformDetails,
      payload: payloadUrl,
    );
  }
}
