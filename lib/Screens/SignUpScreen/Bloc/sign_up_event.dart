part of 'sign_up_bloc.dart';

abstract class SignUpEvent {
  SignUpEvent();
}

class PerformSignUpEvent extends SignUpEvent {
  final dynamic data;

  PerformSignUpEvent({required this.data});
}
