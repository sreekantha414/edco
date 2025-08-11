part of 'set_favorite_bloc.dart';

@immutable
class SetFavoriteState {
  final bool isLoading;
  final bool isCompleted;
  final bool isMoreLoading;
  final bool isFailed;
  final ApiError? error;
  final String? responseMsg;
  final bool? isFromSearch;
  final AwardListModel? model;

  SetFavoriteState({
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
