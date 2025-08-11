part of 'login_bloc.dart';

abstract class LoginEvent {
  LoginEvent();
}

class PerformLoginEvent extends LoginEvent {
  final dynamic data;

  PerformLoginEvent({required this.data});
}
