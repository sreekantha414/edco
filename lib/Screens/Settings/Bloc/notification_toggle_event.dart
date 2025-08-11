part of 'notification_toggle_bloc.dart';

abstract class NotificationToggleEvent {
  NotificationToggleEvent();
}

class PerformNotificationToggleEvent extends NotificationToggleEvent {
  final dynamic data;

  PerformNotificationToggleEvent({required this.data});
}
