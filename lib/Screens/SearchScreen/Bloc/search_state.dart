part of 'search_bloc.dart';

@immutable
class SearchState {
  final bool isLoading;
  final bool isCompleted;
  final bool isMoreLoading;
  final bool isFailed;
  final ApiResponse? error;
  final String? responseMsg;
  final bool? isFromSearch;
  final SearchModel? model;

  SearchState({
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
