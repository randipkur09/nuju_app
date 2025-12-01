import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications;

  /// Add notification
  void addNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
    );

    _notifications.add(notification);

    // auto remove after duration
    Future.delayed(duration, () {
      _notifications.remove(notification);
    });
  }

  /// Alias for addNotification (biar context_extension.dart tetap aman)
  void showNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    addNotification(
      title: title,
      message: message,
      type: type,
      duration: duration,
    );
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

enum NotificationType {
  success,
  error,
  warning,
  info,
}

extension NotificationTypeExtension on NotificationType {
  Color get backgroundColor {
    switch (this) {
      case NotificationType.success:
        return const Color(0xFF27AE60);
      case NotificationType.error:
        return const Color(0xFFE74C3C);
      case NotificationType.warning:
        return const Color(0xFFF39C12);
      case NotificationType.info:
        return const Color(0xFF3498DB);
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
    }
  }

  String get label {
    switch (this) {
      case NotificationType.success:
        return 'Sukses';
      case NotificationType.error:
        return 'Error';
      case NotificationType.warning:
        return 'Peringatan';
      case NotificationType.info:
        return 'Info';
    }
  }
}
