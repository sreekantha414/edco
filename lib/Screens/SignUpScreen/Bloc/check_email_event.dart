part of 'check_email_bloc.dart';

abstract class CheckEmailEvent {
  CheckEmailEvent();
}

class PerformCheckEmailEvent extends CheckEmailEvent {
  final String? email;

  PerformCheckEmailEvent({required this.email});
}
