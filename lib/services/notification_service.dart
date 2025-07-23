import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize notifications
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Request notification permissions
  static Future<bool> requestPermissions() async {
    if (await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission() ?? false) {
      return true;
    }

    if (await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true) ?? false) {
      return true;
    }

    return false;
  }

  // Schedule daily reminder
  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String? customMessage,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'daily_reminder',
        'Daily Learning Reminder',
        channelDescription: 'Reminds you to practice Kinyarwanda daily',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule daily at specified time
      await _notifications.zonedSchedule(
        0,
        'Time to learn Kinyarwanda! 🇷🇼',
        customMessage ?? 'Keep your streak going! Complete today\'s lesson.',
        _nextInstanceOfTime(hour, minute),
        notificationDetails,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'daily_reminder',
      );

      // Save preference
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'notificationSettings': {
            'dailyReminder': true,
            'reminderTime': '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
            'customMessage': customMessage,
          },
        });
      }
    } catch (e) {
      throw Exception('Failed to schedule daily reminder: $e');
    }
  }

  // Cancel daily reminder
  static Future<void> cancelDailyReminder() async {
    try {
      await _notifications.cancel(0);

      // Update preference
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'notificationSettings.dailyReminder': false,
        });
      }
    } catch (e) {
      throw Exception('Failed to cancel daily reminder: $e');
    }
  }

  // Schedule streak reminder
  static Future<void> scheduleStreakReminder() async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'streak_reminder',
        'Streak Reminder',
        channelDescription: 'Reminds you not to break your learning streak',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule for 8 PM if user hasn't practiced today
      await _notifications.zonedSchedule(
        1,
        'Don\'t break your streak! 🔥',
        'You haven\'t practiced today. Keep your learning momentum going!',
        _nextInstanceOfTime(20, 0), // 8 PM
        notificationDetails,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'streak_reminder',
      );
    } catch (e) {
      throw Exception('Failed to schedule streak reminder: $e');
    }
  }

  // Show achievement notification
  static Future<void> showAchievementNotification(String achievementTitle, String description) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'achievements',
        'Achievements',
        channelDescription: 'Notifications for earned achievements',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFFFF9800),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        '🏆 Achievement Unlocked!',
        '$achievementTitle: $description',
        notificationDetails,
        payload: 'achievement',
      );
    } catch (e) {
      // Silently fail - notifications are not critical
    }
  }

  // Show lesson completion notification
  static Future<void> showLessonCompletionNotification(String lessonTitle, int score) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'lesson_completion',
        'Lesson Completion',
        channelDescription: 'Notifications for completed lessons',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      String message;
      if (score >= 90) {
        message = 'Excellent work! You scored $score%';
      } else if (score >= 70) {
        message = 'Good job! You scored $score%';
      } else {
        message = 'Keep practicing! You scored $score%';
      }

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        '✅ Lesson Complete!',
        '$lessonTitle - $message',
        notificationDetails,
        payload: 'lesson_completion',
      );
    } catch (e) {
      // Silently fail
    }
  }

  // Show goal achievement notification
  static Future<void> showGoalAchievementNotification(String goalType) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'goal_achievement',
        'Goal Achievement',
        channelDescription: 'Notifications for achieved goals',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF4CAF50),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      String title;
      String message;

      switch (goalType) {
        case 'daily':
          title = '🎯 Daily Goal Achieved!';
          message = 'You\'ve completed your daily learning goal. Great work!';
          break;
        case 'weekly':
          title = '🏆 Weekly Goal Achieved!';
          message = 'You\'ve reached your weekly learning target. Fantastic!';
          break;
        default:
          title = '🎉 Goal Achieved!';
          message = 'You\'ve reached your learning goal. Keep it up!';
      }

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        message,
        notificationDetails,
        payload: 'goal_achievement',
      );
    } catch (e) {
      // Silently fail
    }
  }

  // Get user notification preferences
  static Future<Map<String, dynamic>> getUserNotificationSettings(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        return userData['notificationSettings'] as Map<String, dynamic>? ?? _getDefaultNotificationSettings();
      }
      return _getDefaultNotificationSettings();
    } catch (e) {
      return _getDefaultNotificationSettings();
    }
  }

  // Update notification preferences
  static Future<void> updateNotificationSettings(String userId, Map<String, dynamic> settings) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'notificationSettings': settings,
      });

      // Apply settings
      if (settings['dailyReminder'] == true) {
        final time = settings['reminderTime'] as String? ?? '19:00';
        final parts = time.split(':');
        await scheduleDailyReminder(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
          customMessage: settings['customMessage'],
        );
      } else {
        await cancelDailyReminder();
      }
    } catch (e) {
      throw Exception('Failed to update notification settings: $e');
    }
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      // Silently fail
    }
  }

  // Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle navigation based on payload
    switch (response.payload) {
      case 'daily_reminder':
      case 'streak_reminder':
        // Navigate to lessons screen
        break;
      case 'achievement':
        // Navigate to achievements screen
        break;
      case 'lesson_completion':
        // Navigate to progress screen
        break;
    }
  }

  // Helper method to get next instance of time
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  // Default notification settings
  static Map<String, dynamic> _getDefaultNotificationSettings() {
    return {
      'dailyReminder': true,
      'reminderTime': '19:00',
      'streakReminder': true,
      'achievementNotifications': true,
      'goalNotifications': true,
      'lessonCompletionNotifications': false,
      'customMessage': null,
    };
  }
}
