part of 'resend_otp_bloc.dart';

abstract class ResendOtpEvent {
  ResendOtpEvent();
}

class PerformResendOtpEvent extends ResendOtpEvent {
  final String? id;
  final dynamic data;

  PerformResendOtpEvent({this.id, required this.data});
}
