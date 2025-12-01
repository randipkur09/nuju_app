import 'package:flutter/material.dart';
import '../services/notification_service.dart';

extension ContextExtension on BuildContext {
  /// Show success notification
  void showSuccess(String title, String message) {
    NotificationService().showNotification(
      title: title,
      message: message,
      type: NotificationType.success,
    );
  }

  /// Show error notification
  void showError(String title, String message) {
    NotificationService().showNotification(
      title: title,
      message: message,
      type: NotificationType.error,
    );
  }

  /// Show warning notification
  void showWarning(String title, String message) {
    NotificationService().showNotification(
      title: title,
      message: message,
      type: NotificationType.warning,
    );
  }

  /// Show info notification
  void showInfo(String title, String message) {
    NotificationService().showNotification(
      title: title,
      message: message,
      type: NotificationType.info,
    );
  }
}
