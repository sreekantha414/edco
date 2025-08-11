part of 'notification_list_bloc.dart';

abstract class NotificationListEvent {
  NotificationListEvent();
}

class PerformNotificationListEvent extends NotificationListEvent {
  final int? page;
  final String? tag;

  PerformNotificationListEvent({required this.page, required this.tag});
}
