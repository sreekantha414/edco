part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent {
  ForgotPasswordEvent();
}

class PerformForgotPasswordEvent extends ForgotPasswordEvent {
  final dynamic data;

  PerformForgotPasswordEvent({required this.data});
}
