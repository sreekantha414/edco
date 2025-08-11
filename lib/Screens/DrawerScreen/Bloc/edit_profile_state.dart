part of 'edit_profile_bloc.dart';

@immutable
class EditProfileState {
  final bool isLoading;
  final bool isCompleted;
  final bool isMoreLoading;
  final bool isFailed;
  final ApiResponse? error;
  final String? responseMsg;
  final bool? isFromSearch;
  final EditProfileModel? model;

  EditProfileState({
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
