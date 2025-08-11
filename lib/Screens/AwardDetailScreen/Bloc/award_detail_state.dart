part of 'award_detail_bloc.dart';

@immutable
class AwardDetailState {
  final bool isLoading;
  final bool isCompleted;
  final bool isFailed;
  final ApiResponse? error;
  final String? responseMsg;
  final bool? isFromSearch;
  final AwardDetailModel? model;

  AwardDetailState({
    this.isLoading = false,
    this.error,
    this.responseMsg,
    this.isFromSearch = false,
    this.isCompleted = false,
    this.isFailed = false,
    this.model,
  });
}
