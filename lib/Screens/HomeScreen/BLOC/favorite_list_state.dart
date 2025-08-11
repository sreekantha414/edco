part of 'favorite_list_bloc.dart';

@immutable
class FavoriteListState {
  final bool isLoading;
  final bool isCompleted;
  final bool isMoreLoading;
  final bool isFailed;
  final ApiError? error;
  final String? responseMsg;
  final bool? isFromSearch;
  final FavoriteListModel? model;

  FavoriteListState({
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
