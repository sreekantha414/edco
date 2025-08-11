part of 'verify_otp_bloc.dart';

@immutable
class VerifyOtpState {
  final bool isLoading;
  final bool isCompleted;
  final bool isMoreLoading;
  final bool isFailed;
  final ApiResponse? error;
  final String? responseMsg;
  final bool? isFromSearch;
  final VerifyOtpModel? model;

  VerifyOtpState({
    this.isLoading = false,
    this.isMoreLoading = false,
    this.error,
    this.responseMsg,
    this.isFromSearch = false,
    this.isCompleted = false,
    this.isFailed = false,
    this.model,
  });
}
