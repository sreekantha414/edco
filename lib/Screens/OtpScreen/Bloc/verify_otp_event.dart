part of 'verify_otp_bloc.dart';

abstract class VerifyOtpEvent {
  VerifyOtpEvent();
}

class PerformVerifyOtpEvent extends VerifyOtpEvent {
  final String? id;
  final dynamic data;

  PerformVerifyOtpEvent({this.id, required this.data});
}
