part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent {
  ChangePasswordEvent();
}

class PerformChangePasswordEvent extends ChangePasswordEvent {
  final String? id;
  final dynamic data;

  PerformChangePasswordEvent({this.id, required this.data});
}
